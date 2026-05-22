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

  // UPDATED: Completely removed 'String selectedRole' from the parameters
  Future<User?> login(String identifier, String password) async {
    final user =
        await remoteDataSource.findUserByCredentials(identifier, password);

    if (user == null) {
      throw Exception('Invalid credentials');
    }

    // REMOVED: The strict role mismatch check is gone, so users bypass manual selection.
    // The app will now automatically read user.role in the UI to navigate.

    await localDataSource.saveUser(user);
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
    final userExists =
        existingUsers.any((u) => u.email == email || u.username == username);

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

    await localDataSource.saveUser(user);
    return user;
  }

  Future<void> logout() async {
    await localDataSource.clearAll();
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
