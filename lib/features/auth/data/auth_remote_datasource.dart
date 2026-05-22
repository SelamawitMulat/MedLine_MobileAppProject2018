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
    // For demo purposes: simulate login by calling a /login endpoint
    // In production, passwords should be hashed and validated server-side
    try {
      final response =
          await apiClient.post('${ApiEndpoints.users}/login', data: {
        'identifier': identifier,
        'password': password,
      });
      return User.fromJson(response);
    } catch (e) {
      // Fallback: fetch all users and find by email/username (password validation skipped in demo)
      final users = await getAllUsers();
      try {
        return users.firstWhere(
          (user) => user.email == identifier || user.username == identifier,
        );
      } catch (_) {
        return null;
      }
    }
  }

  Future<User> signup({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    final response = await apiClient.post(ApiEndpoints.users, data: {
      'username': username,
      'password': password,
      'role': role,
      'name': name,
      'email': email,
    });
    return User.fromJson(response);
  }

  Future<void> deleteUser(String id) async {
    await apiClient.delete('${ApiEndpoints.users}/$id');
  }
}
