import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/data/auth_repository.dart';
import 'package:med_line/features/auth/data/auth_remote_datasource.dart';
import 'package:med_line/features/auth/data/auth_local_datasource.dart';
import 'package:med_line/features/auth/domain/user_model.dart';
import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/database/app_database.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AuthLocalDataSource(db);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final local = ref.watch(authLocalDataSourceProvider);
  return AuthRepository(localDataSource: local, remoteDataSource: remote);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      final user = await repository.login(username, password, role);
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        state = AsyncValue.error('Invalid credentials', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup({
    required String username,
    required String password,
    required String role,
    String? name,
    String? email,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await repository.signup(
        username: username,
        password: password,
        role: role,
        name: name,
        email: email,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await repository.logout();
    state = const AsyncValue.data(null);
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
