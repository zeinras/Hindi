import 'package:flutter/material.dart';
import 'package:hindi_tutorial/services/auth/auth_service.dart';
import 'package:hindi_tutorial/views/login_view.dart';
import 'package:hindi_tutorial/views/register_view.dart';
import 'package:hindi_tutorial/main.dart';
import '../firebase_options.dart';
import 'dart:developer' show log;


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
        Center(child: Text(" We've sent you a verification email \n please verify your email address")),
        TextButton(onPressed:() async {
          await AuthServices.firebase().intialize();
          final user = AuthServices.firebase().currentUser;
          log("HEEEYYYYYYYYYYYYYYYYYYYYYY"  + user.toString());
          await AuthServices.firebase().sendEmailVerification();

        } , child: Text("send email verf")),
        TextButton(onPressed:() async {
          await AuthServices.firebase().logOut();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LoginView()));
        } , child: Text("just verified"))
      ],
    )


    );}
}
