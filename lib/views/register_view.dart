
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hindi_tutorial/views/login_view.dart';
import '../firebase_options.dart';
import 'dart:developer' show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController Email;
  late final TextEditingController Pass ;

  @override
  void initState() {
    Email = TextEditingController();
    Pass = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    Email.dispose();
    Pass.dispose() ;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: FutureBuilder(
          future:  Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context,snapshot){
            switch (snapshot.connectionState)
            {case ConnectionState.none:
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
                      decoration:const InputDecoration(hintText: 'Email'),),
                    TextField(controller: Pass,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration:const InputDecoration(hintText: 'Pass')),
                    TextButton(onPressed:() async {
                      // await Firebase.initializeApp(
                      //  options: DefaultFirebaseOptions.currentPlatform,
                      //);
                      final e=Email.text;
                      final p=Pass.text;
                      final userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: e, password: p);
                    },child: const Text("Register")


                    ),
                  TextButton(onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginView() ));
                  }, child: Text("LOGIN"))
                  ],
                );
                break;
              default:
                return const Text("Loading");


            }

          },

        )
    );
    //return const Placeholder();
  }
}