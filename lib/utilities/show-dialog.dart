
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
