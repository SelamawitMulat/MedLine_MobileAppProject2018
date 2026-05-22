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

  Future<User?> login(String username, String password) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere(
            (user) => user.username == username && user.password == password,
      );
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
    final response = await apiClient.post(ApiEndpoints.users, data: {
      'username': username,
      'password': password,
      'role': role,
      'name': name,
      'email': email,
    });
    return User.fromJson(response);
  }
}