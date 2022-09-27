import 'package:ireview/services/auth/auth_exceptions.dart';
import 'package:ireview/services/auth/auth_provider.dart';
import 'package:ireview/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('mock Authentication', () {
    final provider = MockAuthProvider();
    test('should not be initialized to begin with', () {
      expect(provider.isInitilized, false);
    });

    test('cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotinitializedException>()),
      );
    });

    test('should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitilized, true);
    });

    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'ahould be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitilized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('create user shoul delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'ishtaiwi@gamil.com',
        password: 'anypassword',
      );

      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPasswordUser = provider.createUser(
        email: "any@gmail.com",
        password: '12345689',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'ishtaiwi',
        password: '12345678',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotinitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitilized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitilized) throw NotinitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitilized) throw NotinitializedException();
    if (email == 'ishtaiwi@gamil.com') throw UserNotFoundAuthException();
    if (password == '12345689') throw WrongPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'ishtaiwi@gmail.com',
      id: 'my_id',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitilized) throw NotinitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitilized) throw NotinitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      email: 'ishtaiwi@gmail.com',
      id: 'my_id',
    );
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}
