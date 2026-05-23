import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/features/auth/domain/user_model.dart';

class AuthLocalDataSource {
  final AppDatabase _db;

  AuthLocalDataSource(this._db);

  Future<void> cacheUsers(List<User> users) async {
    for (final user in users) {
      final json = user.toJson();
      json['isLoggedIn'] = 0;
      await _db.insert('users', json);
    }
  }

  Future<List<User>> getCachedUsers() async {
    final data = await _db.getAll('users');
    return data.map((json) => User.fromJson(json)).toList();
  }

  /// Saves the user data to the local SQLite database and marks them as logged in
  Future<void> saveUser(User user) async {
    await _db.update('users', {'isLoggedIn': 0});
    final userData = user.toJson();
    userData['isLoggedIn'] = 1;
    await _db.insert('users', userData);
  }

  /// Retrieves the currently logged-in user from the database
  Future<User?> getCurrentUser() async {
    final results = await _db.getAll('users');
    final loggedInUser = results.cast<Map<String, dynamic>?>().firstWhere(
      (user) => user?['isLoggedIn'] == 1,
      orElse: () => null,
    );
    return loggedInUser != null ? User.fromJson(loggedInUser) : null;
  }

  /// Clears only the logged-in flag for all cached users
  Future<void> clearAuth() async {
    await _db.update('users', {'isLoggedIn': 0});
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
