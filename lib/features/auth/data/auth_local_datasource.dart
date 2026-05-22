import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/features/auth/domain/user_model.dart';
import 'package:sqflite/sqflite.dart';

class AuthLocalDataSource {
  final AppDatabase db;
  static const String sessionTable = 'user_session';

  AuthLocalDataSource(this.db);

  Future<void> saveUserSession(User user) async {
    final Database database = await db.database;
    await database.delete(sessionTable);
    await database.insert(sessionTable, user.toJson());
  }

  Future<User?> getUserSession() async {
    final Database database = await db.database;
    final List<Map<String, dynamic>> maps =
        await database.query(sessionTable, limit: 1);
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<void> clearSession() async {
    final Database database = await db.database;
    await database.delete(sessionTable);
  }
}
