import'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';


// immutable y3ni el class w klshi byorato lazem ma yt3'ayro 5lal el tanfiz const ya3ni

@immutable
class AuthUser {
final bool isEmailVerified;
// had constructer
  const AuthUser(this.isEmailVerified);
//had howe function tanye bs byesta3mel el constructer
  factory AuthUser.fromFirebase(User user)=> AuthUser(user.emailVerified);


}