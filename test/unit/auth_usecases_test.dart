import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';
import 'package:med_line/features/auth/domain/usecases/delete_account.dart';
import 'package:med_line/features/auth/domain/usecases/get_current_user.dart';
import 'package:med_line/features/auth/domain/usecases/login_user.dart';
import 'package:med_line/features/auth/domain/usecases/logout_user.dart';
import 'package:med_line/features/auth/domain/usecases/signup_user.dart';

class FakeAuthRepository implements IAuthRepository {
  User? currentUser;
  User? loginResult;
  User? signupResult;
  User? fetchCurrentUserResult;
  bool throwOnFetchCurrentUser = false;
  String? loginEmail;
  String? loginPassword;
  String? lastSignupName;
  String? lastSignupEmail;
  String? lastSignupPassword;
  bool clearAuthCalled = false;
  String? deletedUserId;

  @override
  Future<List<User>> fetchUsers() async => [];

  @override
  Future<List<User>> getCachedUsers() async => [];

  @override
  Future<void> cacheUsers(List<User> users) async {}

  @override
  Future<User?> getCurrentUser() async => currentUser;

  @override
  Future<void> saveCurrentUser(User user) async {
    currentUser = user;
  }

  @override
  Future<void> clearAuth() async {
    clearAuthCalled = true;
    currentUser = null;
  }

  @override
  Future<void> deleteUser(String id) async {
    deletedUserId = id;
    if (currentUser?.id == id) {
      currentUser = null;
    }
  }

  @override
  Future<User> createRemoteUser(User user) async => user;

  @override
  Future<User?> login(String email, String password) async {
    loginEmail = email;
    loginPassword = password;
    return loginResult;
  }

  @override
  Future<User> signup({required String name, required String email, required String password}) async {
    lastSignupName = name;
    lastSignupEmail = email;
    lastSignupPassword = password;
    if (signupResult == null) {
      throw Exception('Signup result not configured');
    }
    return signupResult!;
  }

  @override
  Future<User?> fetchCurrentUser(String token) async {
    if (throwOnFetchCurrentUser) {
      throw Exception('Fetch failed');
    }
    return fetchCurrentUserResult;
  }
}

void main() {
  group('LoginUserUseCase', () {
    test('returns null for empty credentials', () async {
      final repository = FakeAuthRepository();
      final useCase = LoginUserUseCase(repository);

      final result = await useCase.call('   ', ' ');

      expect(result, isNull);
      expect(repository.loginEmail, isNull);
    });

    test('normalizes email and trims password before calling repository', () async {
      final repository = FakeAuthRepository();
      repository.loginResult = const User(
        id: '1',
        username: 'selam',
        role: 'patient',
        name: 'Selam',
        email: 'selam@gmail.com',
        passwordHash: 'abc',
      );
      final useCase = LoginUserUseCase(repository);

      await useCase.call('  SeLaM@GMAIL.com  ', ' secret ');

      expect(repository.loginEmail, 'selam@gmail.com');
      expect(repository.loginPassword, 'secret');
    });

    test('returns repository user when login succeeds', () async {
      final repository = FakeAuthRepository();
      final expectedUser = const User(
        id: '1',
        username: 'selam',
        role: 'patient',
        name: 'Selam',
        email: 'selam@gmail.com',
        passwordHash: 'abc',
      );
      repository.loginResult = expectedUser;
      final useCase = LoginUserUseCase(repository);

      final result = await useCase.call('selam@gmail.com', 'secret');

      expect(result, expectedUser);
    });
  });

  group('SignupUserUseCase', () {
    test('returns a new user for valid signup data', () async {
      final repository = FakeAuthRepository();
      final createdUser = const User(
        id: '2',
        username: 'newuser',
        role: 'patient',
        name: 'New User',
        email: 'new@example.com',
        passwordHash: 'abc',
      );
      repository.signupResult = createdUser;
      final useCase = SignupUserUseCase(repository);

      final result = await useCase.call(
        username: 'newuser',
        password: '  secret  ',
        role: 'patient',
        name: '  New User  ',
        email: ' NEW@Example.com ',
      );

      expect(result, createdUser);
      expect(repository.lastSignupEmail, 'new@example.com');
      expect(repository.lastSignupName, 'New User');
      expect(repository.lastSignupPassword, 'secret');
    });

    test('throws exception for invalid signup data', () async {
      final repository = FakeAuthRepository();
      final useCase = SignupUserUseCase(repository);

      expect(
        () => useCase.call(
          username: 'newuser',
          password: '   ',
          role: 'patient',
          name: 'Name',
          email: 'new@example.com',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('GetCurrentUserUseCase', () {
    test('returns null when there is no cached current user', () async {
      final repository = FakeAuthRepository();
      final useCase = GetCurrentUserUseCase(repository);

      final result = await useCase.call();

      expect(result, isNull);
    });

    test('returns cached user when token is missing', () async {
      final repository = FakeAuthRepository();
      repository.currentUser = const User(
        id: '3',
        username: 'cached',
        role: 'doctor',
        name: 'Cached User',
        email: 'cached@example.com',
        passwordHash: 'abc',
      );
      final useCase = GetCurrentUserUseCase(repository);

      final result = await useCase.call();

      expect(result, repository.currentUser);
    });

    test('fetches current user when token is present', () async {
      final repository = FakeAuthRepository();
      repository.currentUser = const User(
        id: '4',
        username: 'tokenuser',
        role: 'doctor',
        name: 'Token User',
        email: 'token@example.com',
        passwordHash: 'abc',
        token: 'token-value',
      );
      repository.fetchCurrentUserResult = const User(
        id: '4',
        username: 'tokenuser',
        role: 'doctor',
        name: 'Token User Updated',
        email: 'token@example.com',
        passwordHash: 'abc',
        token: 'token-value',
      );
      final useCase = GetCurrentUserUseCase(repository);

      final result = await useCase.call();

      expect(result, repository.fetchCurrentUserResult);
    });

    test('returns cached user when fetch fails', () async {
      final repository = FakeAuthRepository();
      repository.currentUser = const User(
        id: '5',
        username: 'cachedfail',
        role: 'patient',
        name: 'Cached Fail',
        email: 'cachedfail@example.com',
        passwordHash: 'abc',
        token: 'bad-token',
      );
      repository.throwOnFetchCurrentUser = true;
      final useCase = GetCurrentUserUseCase(repository);

      final result = await useCase.call();

      expect(result, repository.currentUser);
    });
  });

  group('LogoutUserUseCase', () {
    test('clears authentication when called', () async {
      final repository = FakeAuthRepository();
      repository.currentUser = const User(
        id: '6',
        username: 'logout',
        role: 'patient',
        name: 'Logout User',
        email: 'logout@example.com',
        passwordHash: 'abc',
      );
      final useCase = LogoutUserUseCase(repository);

      await useCase.call();

      expect(repository.clearAuthCalled, isTrue);
      expect(repository.currentUser, isNull);
    });
  });

  group('DeleteAccountUseCase', () {
    test('deletes user when current user exists', () async {
      final repository = FakeAuthRepository();
      repository.currentUser = const User(
        id: '7',
        username: 'delete',
        role: 'patient',
        name: 'Delete User',
        email: 'delete@example.com',
        passwordHash: 'abc',
      );
      final useCase = DeleteAccountUseCase(repository);

      await useCase.call();

      expect(repository.deletedUserId, '7');
      expect(repository.currentUser, isNull);
    });

    test('does not delete when there is no current user', () async {
      final repository = FakeAuthRepository();
      final useCase = DeleteAccountUseCase(repository);

      await useCase.call();

      expect(repository.deletedUserId, isNull);
    });
  });
}
