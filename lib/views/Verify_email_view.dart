import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hindi_tutorial/views/login_view.dart';
import 'package:hindi_tutorial/views/register_view.dart';
import 'package:hindi_tutorial/main.dart';
import '../firebase_options.dart';



class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( backgroundColor: Colors.green,
            title: const Text('Verfy')
        )
        ,body:
    Column(
      children: [
        Text("please verify your email address"),
        TextButton(onPressed:() async {
          await Firebase.initializeApp();
          final user = FirebaseAuth.instance.currentUser;
          print("HEEEYYYYYYYYYYYYYYYYYYYYYY  + $user");
          await user?.sendEmailVerification();

        } , child: Text("send email verf")),
        TextButton(onPressed:() async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NotesView()));
        } , child: Text("go to notes"))
      ],
    )


    );}
}
