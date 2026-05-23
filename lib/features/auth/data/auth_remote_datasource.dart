import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/auth/domain/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<List<User>> getAllUsers() async {
    final List<dynamic> response = await apiClient.get(ApiEndpoints.users);
    return response.map((json) => User.fromJson(json)).toList();
  }

  Future<User?> findUserByCredentials(
      String identifier, String password) async {
    final users = await getAllUsers();
    final hashedPassword = User.hashPassword(password);

    try {
      return users.firstWhere((user) {
        final matchesIdentifier =
            user.email.toLowerCase() == identifier.toLowerCase() ||
                user.username.toLowerCase() == identifier.toLowerCase();
        final storedHash = user.passwordHash;
        final matchesPassword = storedHash.isNotEmpty
            ? storedHash == password || storedHash == hashedPassword
            : false;
        return matchesIdentifier && matchesPassword;
      });
    } catch (_) {
      return null;
    }
  }

  Future<User> signup({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    final passwordHash = User.hashPassword(password);
    final normalizedUsername = username.trim().toLowerCase();
    final normalizedEmail = email.trim().toLowerCase();
    final response = await apiClient.post(ApiEndpoints.users, data: {
      'username': normalizedUsername,
      'password': password,
      'passwordHash': passwordHash,
      'role': role,
      'name': name.trim(),
      'email': normalizedEmail,
    });
    return User.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteUser(String id) async {
    await apiClient.delete('${ApiEndpoints.users}/$id');
  }
}
