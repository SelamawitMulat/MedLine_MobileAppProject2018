import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/data/auth_repository.dart';
import 'package:med_line/features/auth/data/auth_remote_datasource.dart';
import 'package:med_line/features/auth/data/auth_local_datasource.dart';
import 'package:med_line/features/auth/domain/user_model.dart';
import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/database/app_database.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(ref.watch(appDatabaseProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    return await ref.watch(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String identifier, String password, String selectedRole) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).login(identifier, password, selectedRole);
    });
  }

  Future<void> signup({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).signup(
        username: username,
        password: password,
        role: role,
        name: name,
        email: email,
      );
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});