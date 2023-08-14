//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hindi_tutorial/views/login_view.dart';
import 'package:hindi_tutorial/constants/routes.dart';
import 'dart:developer' show log;

import 'package:hindi_tutorial/views/register_view.dart';
import 'package:hindi_tutorial/views/Verify_email_view.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const Homepage(),
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
        future: Firebase.initializeApp(name:'secondaryInstance'),
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

              final user = FirebaseAuth.instance.currentUser;
              log(user.toString());
              if (user == null) {
                return LoginView();
              } else {
                if (user.emailVerified) {
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

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes!!"),
        backgroundColor: Colors.blueAccent,
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final should = await showLogOutDialog(context);

                if (should) {
                  //Firebase.initializeApp().then((value) => {
                  await FirebaseAuth.instance.signOut();
                  //});

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginView()));
                }
                break;
            }

            //log(should.toString());
            /*if (should){
               // await Firebase.initializeApp();
               await FirebaseAuth.instance.signOut();
               Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginView()));
              }*/
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text("Logout"))
            ];
          })
        ],
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginView()));
            },
            child: Text("Login")),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alllert"),
          content: Text("Sign out??"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No"))
          ],
        );
      }).then((value) => value ?? false);
}
