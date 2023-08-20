import 'package:hindi_tutorial/services/auth/auth_provider.dart';
import 'package:hindi_tutorial/services/auth/auth_user.dart';
import 'package:hindi_tutorial/services/auth/firebase_auth_provider.dart';
import 'package:hindi_tutorial/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServices implements AuthProvider {
  final AuthProvider provider;

  const AuthServices(this.provider);
  factory AuthServices.firebase()=>AuthServices(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email
    , required String pass})=>provider.createUser(email: email, pass: pass);

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser =>provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String pass}) => provider.logIn(email: email, pass: pass);

  @override
  Future<void> logOut() =>provider.logOut();
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> intialize() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }


}
