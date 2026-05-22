import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/features/auth/domain/user_model.dart';

class AuthLocalDataSource {
  final AppDatabase _db;

  AuthLocalDataSource(this._db);

  /// Saves the user data to the local SQLite database
  Future<void> saveUser(User user) async {
    final userData = user.toJson();
    // Add isLoggedIn flag for local session tracking
    userData['isLoggedIn'] = 1;
    await _db.insert('users', userData);
  }

  /// Retrieves the currently logged-in user from the database
  Future<User?> getCurrentUser() async {
    final results = await _db.getAll('users');
    // Finds the user marked as logged in, if any exists
    final loggedInUser = results.cast<Map<String, dynamic>?>().firstWhere(
      (user) => user?['isLoggedIn'] == 1,
      orElse: () => null,
    );
    return loggedInUser != null ? User.fromJson(loggedInUser) : null;
  }

  /// Clears the user authentication session data
  Future<void> clearAuth() async {
    await _db.clearTable('users');
  }

  /// Alias for clearAuth to match repository usage
  Future<void> clearAll() async {
    await clearAuth();
  }

  /// Deletes a specific user
  Future<void> deleteUser(String id) async {
    await _db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
