//import 'dart:math';

import 'package:flutter/material.dart';

import 'package:hindi_tutorial/constants/routes.dart';
import 'package:hindi_tutorial/services/auth/auth_service.dart';
import 'package:hindi_tutorial/views/Verify_email_view.dart';
import 'package:hindi_tutorial/main.dart';
import 'package:hindi_tutorial/utilities/show-dialog.dart';

import 'dart:developer' show log;

import '../services/auth/auth_exceptions.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController email;
  late final TextEditingController pass;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    pass = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Login'),
      ),
      body: FutureBuilder(
        future: AuthServices.firebase().intialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: email,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'EMAIL'),
                  ),
                  TextField(
                    controller: pass,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(hintText: 'Pass'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final e = email.text;
                      final p = pass.text;
                      try {
                        final userCredential =
                        await AuthServices.firebase().logIn(email: e, pass: p);
                        final user = AuthServices.firebase().currentUser;

                          if (user?.isEmailVerified??false) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                notesRoute, (route) => false);
                          } else {
                            AlertsDialog(context, "Email not verified");
                          }

                      }
                      on UserNotFoundAuthException catch(e){
                        AlertsDialog(context, "User not found");
                      }
                      on WrongPasswordAuthException catch(e){
                        AlertsDialog(context, "Wrong Password");
                      }

                      on GenericAuthException catch(e)
                      {
                        AlertsDialog(context, "Authentication Error");
                      }
                   },
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                    },
                    child: const Text("Go"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute, (route) => false);
                    },
                    child: const Text("Reg"),
                  ),
                ],
              );
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}