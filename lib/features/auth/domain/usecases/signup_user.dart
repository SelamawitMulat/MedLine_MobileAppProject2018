import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

class SignupUserUseCase {
  final IAuthRepository repository;

  SignupUserUseCase(this.repository);

  Future<User> call({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedUsername = username.trim().toLowerCase();

    var cachedUsers = await repository.getCachedUsers();
    if (cachedUsers.isEmpty) {
      final remoteUsers = await repository.fetchUsers();
      cachedUsers = remoteUsers;
      if (remoteUsers.isNotEmpty) {
        await repository.cacheUsers(remoteUsers);
      }
    }

    final userExists = cachedUsers.any((u) =>
        u.email.toLowerCase() == normalizedEmail ||
        u.username.toLowerCase() == normalizedUsername);
    if (userExists) {
      throw Exception('User already exists');
    }

    final newUser = User(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      username: normalizedUsername,
      role: role,
      name: name.trim(),
      email: normalizedEmail,
      passwordHash: User.hashPassword(password.trim()),
    );

    try {
      final createdUser = await repository.createRemoteUser(newUser);
      await repository.saveCurrentUser(createdUser);
      return createdUser;
    } catch (_) {
      await repository.saveCurrentUser(newUser);
      return newUser;
    }
  }
}
