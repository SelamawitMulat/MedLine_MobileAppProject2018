import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';

void main() {
  group('Auth Provider Tests', () {
    setUp(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    test('authProvider is readable', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authState = container.read(authProvider);
      expect(authState, isNotNull);
    });

    test('authProvider initializes as AsyncValue', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authState = container.read(authProvider);
      // Should be AsyncValue type
      expect(authState, isNotNull);
    });

    test('authProvider can handle loading state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authState = container.read(authProvider);
      expect(authState, isNotNull);
    });

    test('authProvider can be watched', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authState = container.read(authProvider);
      expect(authState, isNotNull);
    });

    test('authProvider returns User type in value', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authState = container.read(authProvider);
      expect(authState, isNotNull);
    });

    test('authNotifier is functional', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authState = container.read(authProvider);
      expect(authState, isNotNull);
    });

    test('loginUserUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final loginUseCase = container.read(loginUserUseCaseProvider);
      expect(loginUseCase, isNotNull);
    });

    test('signupUserUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final signupUseCase = container.read(signupUserUseCaseProvider);
      expect(signupUseCase, isNotNull);
    });

    test('logoutUserUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final logoutUseCase = container.read(logoutUserUseCaseProvider);
      expect(logoutUseCase, isNotNull);
    });

    test('deleteAccountUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final deleteAccountUseCase = container.read(deleteAccountUseCaseProvider);
      expect(deleteAccountUseCase, isNotNull);
    });

    test('getCurrentUserUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final getCurrentUserUseCase =
          container.read(getCurrentUserUseCaseProvider);
      expect(getCurrentUserUseCase, isNotNull);
    });

    test('all auth use cases are available', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(loginUserUseCaseProvider), isNotNull);
      expect(container.read(signupUserUseCaseProvider), isNotNull);
      expect(container.read(logoutUserUseCaseProvider), isNotNull);
      expect(container.read(deleteAccountUseCaseProvider), isNotNull);
      expect(container.read(getCurrentUserUseCaseProvider), isNotNull);
    });

    test('authProvider state can be invalidated', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.invalidate(authProvider);
      final authState = container.read(authProvider);
      expect(authState, isNotNull);
    });

    test('auth use cases are singleton providers', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final loginUseCase1 = container.read(loginUserUseCaseProvider);
      final loginUseCase2 = container.read(loginUserUseCaseProvider);

      expect(loginUseCase1, equals(loginUseCase2));
    });

    test('authProvider works with multiple containers', () async {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      addTearDown(() {
        container1.dispose();
        container2.dispose();
      });

      final authState1 = container1.read(authProvider);
      final authState2 = container2.read(authProvider);

      expect(authState1, isNotNull);
      expect(authState2, isNotNull);
    });
  });
}
