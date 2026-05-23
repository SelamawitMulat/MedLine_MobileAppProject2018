import 'dart:async';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/auth/data/auth_local_datasource.dart';
import 'package:med_line/features/auth/data/auth_remote_datasource.dart';
import 'package:med_line/features/auth/data/auth_repository.dart';
import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/network/api_client.dart';

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = AppDatabase();
  final localDataSource = AuthLocalDataSource(db);
  final remoteDataSource = AuthRemoteDataSource(ApiClient());
  final repo = AuthRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  print('Testing login...');
  try {
    final user = await repo.login('selam@gmail.com', 'seli2123');
    print('Login success: ${user?.username} ${user?.email} ${user?.role}');
  } catch (e) {
    print('Login failed: $e');
  }

  print('Testing login by username...');
  try {
    final user = await repo.login('selam@gmail.com', 'seli2123');
    print('Login success: ${user?.username} ${user?.email} ${user?.role}');
  } catch (e) {
    print('Login failed: $e');
  }
}
