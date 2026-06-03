import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

class SignupUserUseCase {
  final IAuthRepository repository;

  SignupUserUseCase(this.repository);

  Future<User> call({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final cleanedName = name.trim();

    if (normalizedEmail.isEmpty || cleanedName.isEmpty || password.trim().isEmpty) {
      throw Exception('Invalid signup data');
    }

    return await repository.signup(
      name: cleanedName,
      email: normalizedEmail,
      password: password.trim(),
    );
  }
}
