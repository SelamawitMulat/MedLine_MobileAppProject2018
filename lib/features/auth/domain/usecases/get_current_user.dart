import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final IAuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> call() async {
    final localUser = await repository.getCurrentUser();
    if (localUser == null) return null;

    final token = localUser.token;
    if (token == null || token.isEmpty) {
      return localUser;
    }

    try {
      return await repository.fetchCurrentUser(token);
    } catch (_) {
      return localUser;
    }
  }
}
