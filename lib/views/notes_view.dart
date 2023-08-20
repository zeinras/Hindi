import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindi_tutorial/enums/menu_actions.dart';
import 'package:hindi_tutorial/services/auth/auth_service.dart';
import '../utilities/show-dialog.dart';
import 'package:hindi_tutorial/views/login_view.dart';

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
                  await AuthServices.firebase().logOut();

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
