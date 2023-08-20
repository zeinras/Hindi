//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hindi_tutorial/services/auth/auth_service.dart';
import 'package:hindi_tutorial/views/login_view.dart';
import 'package:hindi_tutorial/constants/routes.dart';
import 'dart:developer' show log;

import 'package:hindi_tutorial/views/register_view.dart';
import 'package:hindi_tutorial/views/Verify_email_view.dart';
import 'package:hindi_tutorial/views/notes_view.dart';
//import 'firebase_options.dart';
import 'package:hindi_tutorial/utilities/show-dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
/*
  // Initialize the named instance first
  await Firebase.initializeApp(
    name: 'secondaryInstance',
    options: FirebaseOptions(
        appId: '1:916543500329:android:c1f13d99fa612d69c86c38',
        apiKey: 'AIzaSyCDbyAGNG9IFrK4noDEIiyXzyWc5gWS-MM',
        projectId: 'hindi-9fad0',
        messagingSenderId: '916543500329'),
  );

   await Firebase.initializeApp();
*/

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      home: const RegisterView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyRoute: (context) => const VerifyEmail(),
        notesRoute: (context) => const NotesView(),
      },
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Home'),
      ),*/
      body: FutureBuilder(
        future:AuthServices.firebase().intialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              /*if (snapshot.hasError) {
                // Handle the error if initialization fails
                return Center(
                  child: Text('Error initializing Firebase'),
                );
              }*/

              final user = AuthServices.firebase().currentUser;
              log(user.toString());
              if (user == null) {
                return LoginView();
              } else {
                if (user.isEmailVerified) {
                  return NotesView();
                } else {
                  return VerifyEmail();
                }
              }

              /* Future.delayed(Duration.zero, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterView()),
                  );
                });*/

              //return Text("Done");
          }
          return Text("Done");
        },
      ),
    );
  }
}


