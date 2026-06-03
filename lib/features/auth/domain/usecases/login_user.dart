import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

class LoginUserUseCase {
  final IAuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<User?> call(String email, String password) async {
    final cleanedEmail = email.trim().toLowerCase();
    final cleanedPassword = password.trim();
    if (cleanedEmail.isEmpty || cleanedPassword.isEmpty) {
      return null;
    }
    return await repository.login(cleanedEmail, cleanedPassword);
  }
}
