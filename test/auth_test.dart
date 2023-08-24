import 'package:hindi_tutorial/services/auth/auth_exceptions.dart';
import 'package:hindi_tutorial/services/auth/auth_provider.dart';
import 'package:hindi_tutorial/services/auth/auth_user.dart';
import 'package:test/test.dart';


void main() {
  group('Mock Authentication', () {

    late MockAuthProvider provider;

    setUp(() {
      provider = MockAuthProvider();
    });

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to be initialized', () async {
      await provider.intialize();
      expect(provider.isInitialized, true);
    });


    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
          () async {
        await provider.intialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        pass: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        pass: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        pass: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        pass: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  AuthUser? _user;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String pass,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(
      email: email,
      pass: pass,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> intialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String pass}) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (pass == 'foobar') throw WrongPasswordAuthException();
    const _user = AuthUser(isEmailVerified: false);
    return Future.value(_user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const NewUser = AuthUser(isEmailVerified: true);
    _user = NewUser;
  }
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }

}
