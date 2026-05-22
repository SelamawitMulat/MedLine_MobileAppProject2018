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

  Future<User?> login(String username, String password, String role) async {
    final localUser = await localDataSource.getUserSession();
    if (localUser != null &&
        localUser.username == username &&
        localUser.password == password &&
        localUser.role == role) {
      return localUser;
    }
    final remoteUser = await remoteDataSource.login(username, password);
    if (remoteUser != null && remoteUser.role == role) {
      await localDataSource.saveUserSession(remoteUser);
      return remoteUser;
    }
    return null;
  }

  Future<User?> signup({
    required String username,
    required String password,
    required String role,
    String? name,
    String? email,
  }) async {
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
