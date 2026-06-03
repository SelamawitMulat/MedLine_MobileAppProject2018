import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/features/auth/data/models/user_model.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';

class AuthLocalDataSource {
  final AppDatabase _db;

  AuthLocalDataSource(this._db);

  Future<void> cacheUsers(List<User> users) async {
    for (final user in users) {
      final json = user.toJson();
      json['isLoggedin'] = 0;
      await _db.insert('users', json);
    }
  }

  Future<List<User>> getCachedUsers() async {
    final data = await _db.getAll('users');
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  /// Saves the user data to the local SQLite database and marks them as logged in
  Future<void> saveUser(User user) async {
    await _db.update('users', {'isLoggedin': 0});
    final userData = user.toJson();
    userData['isLoggedin'] = 1;
    await _db.insert('users', userData);
  }

  /// Retrieves the currently logged-in user from the database
  Future<User?> getCurrentUser() async {
    final results = await _db.getAll('users');
    final loggedInUser = results.cast<Map<String, dynamic>?>().firstWhere(
      (user) => user?['isLoggedin'] == 1,
      orElse: () => null,
    );
    return loggedInUser != null ? UserModel.fromJson(loggedInUser) : null;
  }

  Future<String?> getAuthToken() async {
    final currentUser = await getCurrentUser();
    return currentUser?.token;
  }

  /// Clears stored auth/session state for all cached users.
  Future<void> clearAuth() async {
    await _db.update('users', {'isLoggedin': 0, 'token': null});
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
