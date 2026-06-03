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

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    try {
      final response = await apiClient.post(ApiEndpoints.authSignup, data: {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiClient.post(ApiEndpoints.authLogin, data: {
      'email': email.trim().toLowerCase(),
      'password': password,
    });
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCurrentUser(String token) async {
    final response = await apiClient.get(
      ApiEndpoints.authMe,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response as Map<String, dynamic>;
  }

  Future<void> deleteUser(String token) async {
    await apiClient.delete(
      ApiEndpoints.authMe,
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
