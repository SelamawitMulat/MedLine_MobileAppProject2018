import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/features/auth/data/auth_local_datasource.dart';
import 'package:med_line/features/auth/data/auth_remote_datasource.dart';
import 'package:med_line/features/auth/data/auth_repository.dart';

void main() {
  test('remote login works for known user', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final db = AppDatabase();
    final localDataSource = AuthLocalDataSource(db);
    final remoteDataSource = AuthRemoteDataSource(ApiClient());
    final repo = AuthRepository(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    final user = await repo.login('selam@gmail.com', 'seli2123');
    expect(user, isNotNull);
    expect(user!.email, 'selam@gmail.com');
  }, timeout: const Timeout(Duration(seconds: 30)));
}
