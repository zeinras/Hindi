//import 'dart:math';

import 'package:flutter/material.dart';
//import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hindi_tutorial/views/Verify_email_view.dart';
import 'package:hindi_tutorial/main.dart';
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
    );
    print(userCredential);}
    on FirebaseAuthException catch (c)
    { if (c.code == 'user-not-found') {
      log("user not found");
      log("hey");
      log(c.code.toString());
    }
    }


    },
    child: const Text('Login'),
    ),
    TextButton(onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil('/verify/', (route) => false);

    }, child: Text("Go"))
    ],
    );
    }

    return const Text("Loading...");
    },
    )



    );
  }
}
