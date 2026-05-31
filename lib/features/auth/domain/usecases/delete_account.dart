import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final IAuthRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call() async {
    final user = await repository.getCurrentUser();
    if (user != null) {
      await repository.deleteUser(user.id);
    }
  }
}
