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

  Future<User?> login(String identifier, String password, String selectedRole) async {
    final user = await remoteDataSource.findUserByCredentials(identifier, password);

    if (user == null) {
      throw Exception('Invalid credentials');
    }

    if (user.role != selectedRole) {
      throw Exception('This account is registered as ${user.role}. You selected $selectedRole.');
    }

    await localDataSource.saveUserSession(user);
    return user;
  }

  Future<User?> signup({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    final existingUsers = await remoteDataSource.getAllUsers();
    final userExists = existingUsers.any((u) => u.email == email || u.username == username);

    if (userExists) {
      throw Exception('User already exists');
    }

    final user = await remoteDataSource.signup(
      username: username,
      password: password,
      role: role,
      name: name,
      email: email,
    );

    await localDataSource.saveUserSession(user);
    return user;
  }

  Future<void> logout() async {
    await localDataSource.clearSession();
  }

  Future<User?> getCurrentUser() async {
    return await localDataSource.getUserSession();
  }
}