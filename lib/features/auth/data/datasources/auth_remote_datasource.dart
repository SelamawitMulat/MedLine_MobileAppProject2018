import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';

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

  Future<User> signup(User user) async {
    final response = await apiClient.post(ApiEndpoints.users, data: {
      'username': user.username,
      'passwordHash': user.passwordHash,
      'role': user.role,
      'name': user.name.trim(),
      'email': user.email,
    });
    return User.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteUser(String id) async {
    await apiClient.delete('${ApiEndpoints.users}/$id');
  }
}
