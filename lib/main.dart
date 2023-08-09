//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hindi_tutorial/views/login_view.dart';
//import 'package:hindi_tutorial/views/register_view.dart';
import 'package:hindi_tutorial/views/Verify_email_view.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 //await Firebase.initializeApp();
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
        future: Firebase.initializeApp()
        ,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return  Center(
                child:  CircularProgressIndicator(),
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
              if (user==null)
                {
                  return LoginView();
                }
              else
                { if (user.emailVerified)
                  {return NotesView();}

                  else
                  {return VerifyEmail();}}


               /* Future.delayed(Duration.zero, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterView()),
                  );
                });*/

              return Text("Done");
          }
          return Text("Done");
        },
      ),
    );
  }
}



class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes!!") ,
      backgroundColor: Colors.blueAccent,),
      body: Center(child: Text( "Hey!!!!"))

    );
  }
}




