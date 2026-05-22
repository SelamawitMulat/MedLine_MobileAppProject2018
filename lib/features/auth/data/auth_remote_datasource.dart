import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/features/auth/domain/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;
  static const String baseUrl =
      'https://6a0f328b1736097c360b457c.mockapi.io/users';

  AuthRemoteDataSource(this.apiClient);

  Future<User?> login(String username, String password) async {
    final response = await apiClient.get(baseUrl);
    final users = (response as List)
        .map((json) => User.fromJson(json))
        .where((user) => user.username == username && user.password == password)
        .toList();
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<User> signup({
    required String username,
    required String password,
    required String role,
    String? name,
    String? email,
  }) async {
    final response = await apiClient.post(baseUrl, data: {
      'username': username,
      'password': password,
      'role': role,
      'name': name,
      'email': email,
    });
    return User.fromJson(response);
  }

  Future<User?> fetchUserById(String id) async {
    final response = await apiClient.get('[baseUrl]/$id');
    return User.fromJson(response);
  }
}
