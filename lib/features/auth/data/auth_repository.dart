import 'package:med_line/features/auth/data/auth_local_datasource.dart';
import 'package:med_line/features/auth/data/auth_remote_datasource.dart';
import 'package:med_line/features/auth/domain/user_model.dart';

class AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<List<User>> getAllUsers() async {
    final cachedUsers = await localDataSource.getCachedUsers();
    if (cachedUsers.isNotEmpty) {
      return cachedUsers;
    }

    final remoteUsers = await remoteDataSource.getAllUsers();
    await localDataSource.cacheUsers(remoteUsers);
    return remoteUsers;
  }

  User? _findMatchingUser(
      List<User> users, String identifier, String password) {
    final cleanedIdentifier = identifier.trim().toLowerCase();
    final cleanedPassword = password.trim();
    final hashedPassword = User.hashPassword(cleanedPassword);

    for (final u in users) {
      final emailLower = u.email.toLowerCase();
      final usernameLower = u.username.toLowerCase();
      final emailPrefix =
          emailLower.contains('@') ? emailLower.split('@').first : emailLower;
      final matchesIdentifier = cleanedIdentifier == emailLower ||
          cleanedIdentifier == usernameLower ||
          cleanedIdentifier == emailPrefix;
      if (!matchesIdentifier) continue;

      final storedHash = u.passwordHash;
      final matchesPassword = storedHash.isNotEmpty &&
          (storedHash == cleanedPassword || storedHash == hashedPassword);
      if (matchesPassword) {
        return u;
      }
    }
    return null;
  }

  Future<User?> login(String identifier, String password) async {
    final cachedUsers = await localDataSource.getCachedUsers();
    final cachedMatch = _findMatchingUser(cachedUsers, identifier, password);
    if (cachedMatch != null) {
      await localDataSource.saveUser(cachedMatch);
      return cachedMatch;
    }

    final remoteUsers = await remoteDataSource.getAllUsers();
    await localDataSource.cacheUsers(remoteUsers);

    final remoteMatch = _findMatchingUser(remoteUsers, identifier, password);
    if (remoteMatch != null) {
      await localDataSource.saveUser(remoteMatch);
      return remoteMatch;
    }

    throw Exception('Invalid credentials');
  }

  Future<User?> signup({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedUsername = username.trim().toLowerCase();
    final users = await getAllUsers();
    final userExists = users.any((u) =>
        u.email.toLowerCase() == normalizedEmail ||
        u.username.toLowerCase() == normalizedUsername);

    if (userExists) {
      throw Exception('User already exists');
    }

    try {
      final user = await remoteDataSource.signup(
        username: username,
        password: password,
        role: role,
        name: name,
        email: email,
      );
      await localDataSource.saveUser(user);
      return user;
    } catch (_) {
      final localUser = User(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        username: normalizedUsername,
        role: role,
        name: name.trim(),
        email: normalizedEmail,
        passwordHash: User.hashPassword(password.trim()),
      );
      await localDataSource.saveUser(localUser);
      return localUser;
    }
  }

  Future<void> logout() async {
    await localDataSource.clearAuth();
  }

  Future<void> deleteAccount() async {
    final user = await localDataSource.getCurrentUser();
    if (user != null) {
      await remoteDataSource.deleteUser(user.id);
      await localDataSource.deleteUser(user.id);
    }
  }

  Future<User?> getCurrentUser() async {
    return await localDataSource.getCurrentUser();
  }
}
