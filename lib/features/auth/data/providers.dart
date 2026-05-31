import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/core/providers.dart';
import 'package:med_line/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:med_line/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:med_line/features/auth/data/repositories_impl/auth_repository.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(ref.watch(appDatabaseProvider));
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});
