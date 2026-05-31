import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

class LogoutUserUseCase {
  final IAuthRepository repository;

  LogoutUserUseCase(this.repository);

  Future<void> call() async {
    await repository.clearAuth();
  }
}
