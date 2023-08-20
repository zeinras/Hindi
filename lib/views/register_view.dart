import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindi_tutorial/constants/routes.dart';
import 'package:hindi_tutorial/services/auth/auth_service.dart';
import 'package:hindi_tutorial/views/Verify_email_view.dart';
import 'package:hindi_tutorial/views/login_view.dart';
import '../services/auth/auth_exceptions.dart';
import 'dart:developer' show log;

import '../utilities/show-dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController Email;
  late final TextEditingController Pass;

  late final p;
  String tt = "Register";
  bool vis = false;

  @override
  void initState() {
    Email = TextEditingController();
    Pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    Email.dispose();
    Pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
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
                    TextField(controller: Email,
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(hintText: 'Email'),),
                    TextField(controller: Pass,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(hintText: 'Pass')),
                    TextButton(onPressed: () async {
                      final e = Email.text;
                      final p = Pass.text;
                      try {
                        final userCredential = await AuthServices.firebase()
                            .createUser(email: e, pass: p);

                        await AuthServices.firebase().sendEmailVerification();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyRoute, (route) => false);

                        setState(() {
                          tt = "no verification?";
                        });

                        vis = true;
                      }
                      on WeakPasswordAuthException catch  (e)
                      { AlertsDialog(context, "Weak Password");  }

                      on EmailAlreadyInUseAuthException catch  (e)
                      { AlertsDialog(context, "email already in use");  }

                      on InvalidEmailAuthException catch(e){
                        AlertsDialog(context, "Invalid Email");
                      }
                      on GenericAuthException catch(e){
                        AlertsDialog(context, "Generic");
                      }
                    }, child: Text(tt)


                    ),
                    TextButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginView()));
                    }, child: Text("LOGIN")),
                    Visibility(
                        visible: vis,
                        child: TextButton(onPressed: () async {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyRoute, (route) => false);
                        }, child: Text("Verify now"))),
                    TextButton(onPressed: () async {
                      final user1 = AuthServices.firebase().currentUser;
                      log(user1.toString());
                    }, child: Text("user?"))

                  ],
                );

              default:
                return const Text("Loading");
            }
          },

        )
    );
    //return const Placeholder();
  }
}