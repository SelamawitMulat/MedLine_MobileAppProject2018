import 'package:med_line/features/auth/domain/entities/user.dart';

/// Auth repository interface - defines contracts for auth data operations
/// Implementation is in data layer (repositories_impl)
abstract class IAuthRepository {
  Future<List<User>> fetchUsers();

  Future<List<User>> getCachedUsers();

  Future<void> cacheUsers(List<User> users);

  Future<User?> getCurrentUser();

  Future<void> saveCurrentUser(User user);

  Future<void> clearAuth();

  Future<void> deleteUser(String id);

  Future<User> createRemoteUser(User user);

  Future<User?> login(String email, String password);

  Future<User> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<User?> fetchCurrentUser(String token);
}
