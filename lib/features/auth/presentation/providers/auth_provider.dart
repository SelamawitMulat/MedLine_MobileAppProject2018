import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/data/providers.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/usecases/delete_account.dart';
import 'package:med_line/features/auth/domain/usecases/get_current_user.dart';
import 'package:med_line/features/auth/domain/usecases/login_user.dart';
import 'package:med_line/features/auth/domain/usecases/logout_user.dart';
import 'package:med_line/features/auth/domain/usecases/signup_user.dart';

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final loginUserUseCaseProvider = Provider<LoginUserUseCase>((ref) {
  return LoginUserUseCase(ref.watch(authRepositoryProvider));
});

final signupUserUseCaseProvider = Provider<SignupUserUseCase>((ref) {
  return SignupUserUseCase(ref.watch(authRepositoryProvider));
});

final logoutUserUseCaseProvider = Provider<LogoutUserUseCase>((ref) {
  return LogoutUserUseCase(ref.watch(authRepositoryProvider));
});

final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  return DeleteAccountUseCase(ref.watch(authRepositoryProvider));
});

// Presentation Layer AuthNotifier
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    final current = await ref.watch(getCurrentUserUseCaseProvider).call();
    return current;
  }

  Future<void> login(String identifier, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(loginUserUseCaseProvider)
          .call(identifier, password);
    });
  }

  Future<void> signup({
    required String username,
    required String password,
    required String role,
    required String name,
    required String email,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(signupUserUseCaseProvider).call(
            username: username,
            password: password,
            role: role,
            name: name,
            email: email,
          );
    });
  }

  Future<void> logout() async {
    await ref.read(logoutUserUseCaseProvider).call();
    state = const AsyncValue.data(null);
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(deleteAccountUseCaseProvider).call();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Global UI-consumed Authentication State Provider
final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});
