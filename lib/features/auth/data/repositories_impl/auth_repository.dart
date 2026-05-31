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
    await remoteDataSource.deleteUser(id);
    await localDataSource.deleteUser(id);
  }

  @override
  Future<User> createRemoteUser(User user) async {
    return await remoteDataSource.signup(user);
  }
}
