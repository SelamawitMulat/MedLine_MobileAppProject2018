import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/database/tables.dart';
import 'package:med_line/features/auth/domain/user_model.dart';

class AuthLocalDataSource {
  final AppDatabase db;

  AuthLocalDataSource(this.db);

  Future<void> saveUserSession(User user) async {
    await db.clearTable(Tables.userSession);
    await db.insert(Tables.userSession, user.toJson());
  }

  Future<User?> getUserSession() async {
    final data = await db.getSingle(Tables.userSession);
    if (data != null) {
      return User.fromJson(data);
    }
    return null;
  }

  Future<void> clearSession() async {
    await db.clearTable(Tables.userSession);
  }
}