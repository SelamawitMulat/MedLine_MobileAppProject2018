import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

class LoginUserUseCase {
  final IAuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<User?> call(String identifier, String password) async {
    final cleanedIdentifier = identifier.trim().toLowerCase();
    final cleanedPassword = password.trim();
    final hashedPassword = User.hashPassword(cleanedPassword);

    final cachedUsers = await repository.getCachedUsers();
    final cachedMatch = _findMatchingUser(
      cachedUsers,
      cleanedIdentifier,
      cleanedPassword,
      hashedPassword,
    );
    if (cachedMatch != null) {
      await repository.saveCurrentUser(cachedMatch);
      return cachedMatch;
    }

    final remoteUsers = await repository.fetchUsers();
    await repository.cacheUsers(remoteUsers);

    final remoteMatch = _findMatchingUser(
      remoteUsers,
      cleanedIdentifier,
      cleanedPassword,
      hashedPassword,
    );
    if (remoteMatch != null) {
      await repository.saveCurrentUser(remoteMatch);
      return remoteMatch;
    }

    return null;
  }

  User? _findMatchingUser(
    List<User> users,
    String cleanedIdentifier,
    String cleanedPassword,
    String hashedPassword,
  ) {
    for (final user in users) {
      final emailLower = user.email.toLowerCase();
      final usernameLower = user.username.toLowerCase();
      final emailPrefix =
          emailLower.contains('@') ? emailLower.split('@').first : emailLower;
      final matchesIdentifier = cleanedIdentifier == emailLower ||
          cleanedIdentifier == usernameLower ||
          cleanedIdentifier == emailPrefix;
      if (!matchesIdentifier) continue;

      final storedHash = user.passwordHash;
      final matchesPassword = storedHash.isNotEmpty &&
          (storedHash == cleanedPassword || storedHash == hashedPassword);
      if (matchesPassword) {
        return user;
      }
    }
    return null;
  }
}
