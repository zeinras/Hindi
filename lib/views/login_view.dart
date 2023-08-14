//import 'dart:math';

import 'package:flutter/material.dart';
//import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hindi_tutorial/constants/routes.dart';
import 'package:hindi_tutorial/views/Verify_email_view.dart';
import 'package:hindi_tutorial/main.dart';
import 'package:hindi_tutorial/utilities/show-dialog.dart';

import '../firebase_options.dart';
import 'dart:developer' show log;




class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController email ;
  late final TextEditingController pass ;


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
          title: const Text('Login')),
      body:
    FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
    switch (snapshot.connectionState) {
    case ConnectionState.none:
    break;
    case ConnectionState.waiting:
    break;
    case ConnectionState.active:
    break;
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
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );

    final e = email.text;
    final p = pass.text;
    try{

    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: e,
    password: p,
    ).then((value) => {Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false)});
    log(userCredential.toString());

    //Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);
    }
    on FirebaseAuthException catch (c)
    { if (c.code == 'user-not-found') {
      log("user not found");
      log(c.code.toString());}
      await AlertsDialog(context,c.code);

    }
    catch(l){
      await AlertsDialog(context,l);
    }

    },
    child: const Text('Login'),
    ),
    TextButton(onPressed: () {
      Navigator.of(context).pushNamedAndRemoveUntil(verifyRoute, (route) => false);

    }, child: const Text("Go"))
    ],
    );



    }

    return const Text("Loading...");




    },
    )



    );
  }
}


Future<bool> AlertsDialog(BuildContext context,ss) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alllert"),
          content: Text(ss.toString()),
          actions: [

            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
        );
      }).then((value) => value ?? false);
}
