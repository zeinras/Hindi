//import 'dart:html';

import 'package:hindi_tutorial/firebase_options.dart';
import 'package:hindi_tutorial/services/auth/auth_user.dart';
import 'package:hindi_tutorial/services/auth/auth_provider.dart';
import 'package:hindi_tutorial/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> intialize() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  @override
  Future<AuthUser> createUser(
      {required String email, required String pass}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      final user = currentUser;
      if (user != null)
        {return user;}
      else{
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({required String email, required String pass}) async{

    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

      final user = currentUser;
      if (user !=null)
        {
          return user;
        }
      else
        {throw UserNotLoggedInException(); }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found')
      {throw UserNotFoundAuthException();}
      else if (e.code == 'wrong-password')
        {throw WrongPasswordAuthException();}
      else {throw GenericAuthException();}
    }
    // _ ya3ni ma bthmni el value
    catch (_) {
throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async{
   final user= FirebaseAuth.instance.currentUser;
    if(user!=null)
      {await FirebaseAuth.instance.signOut();}
    else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }
}
