import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';
import 'package:med_line/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:med_line/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';

class AuthRepository implements IAuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<User>> fetchUsers() async {
    return await remoteDataSource.getAllUsers();
  }

  @override
  Future<List<User>> getCachedUsers() async {
    return await localDataSource.getCachedUsers();
  }

  @override
  Future<void> cacheUsers(List<User> users) async {
    await localDataSource.cacheUsers(users);
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getCurrentUser();
  }

  @override
  Future<void> saveCurrentUser(User user) async {
    await localDataSource.saveUser(user);
  }

  @override
  Future<void> clearAuth() async {
    await localDataSource.clearAuth();
  }

  @override
  Future<void> deleteUser(String id) async {
    final token = await localDataSource.getAuthToken();
    if (token != null && token.isNotEmpty) {
      await remoteDataSource.deleteUser(token);
    }
    await localDataSource.deleteUser(id);
  }

  @override
  Future<User> createRemoteUser(User user) async {
    final response = await remoteDataSource.signup(user.name, user.email, user.passwordHash);
    final token = response['token']?.toString();
    final userData = response['user'] as Map<String, dynamic>;
    return User.fromJson({...userData, 'token': token});
  }

  @override
  Future<User?> login(String email, String password) async {
    final response = await remoteDataSource.login(email, password);
    final token = response['token']?.toString();
    final userData = response['user'] as Map<String, dynamic>;
    final user = User.fromJson({...userData, 'token': token});
    await saveCurrentUser(user);
    return user;
  }

  @override
  Future<User> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.signup(name, email, password);
    final token = response['token']?.toString();
    final userData = response['user'] as Map<String, dynamic>;
    final user = User.fromJson({...userData, 'token': token});
    await saveCurrentUser(user);
    return user;
  }

  @override
  Future<User?> fetchCurrentUser(String token) async {
    final response = await remoteDataSource.getCurrentUser(token);
    final userData = response['user'] as Map<String, dynamic>;
    final user = User.fromJson({...userData, 'token': token});
    await saveCurrentUser(user);
    return user;
  }
}
