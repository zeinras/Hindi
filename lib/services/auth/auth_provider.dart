import 'package:hindi_tutorial/services/auth/auth_user.dart';
 abstract class AuthProvider {

 // el variable esmo auth user , el method yalli hiye getter esma current user kl ma 7da ystad3i el
   // abstract class auth provider lazem y3abbi kime bi function current user yalli 7a t3ti kime la authuser
AuthUser? get currentUser;
Future<AuthUser>logIn(
{required String email,
required String pass,}
    );

Future<AuthUser>createUser(
    {required String email,
     required String pass,}
    );


Future<void> logOut();
Future<void> sendEmailVerification();
 }