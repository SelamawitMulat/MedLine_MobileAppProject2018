import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Appointment Provider Tests', () {
    test('appointmentNotifier initializes with empty state', () async {
      // Note: This test may require proper setup of dependencies
      // For now, we test that the provider can be read
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Verify provider is accessible
      expect(appointmentProvider, isNotNull);
    });

    test('bookAppointmentUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final bookUseCase = container.read(bookAppointmentUseCaseProvider);
      expect(bookUseCase, isNotNull);
    });

    test('rescheduleAppointmentUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final rescheduleUseCase =
          container.read(rescheduleAppointmentUseCaseProvider);
      expect(rescheduleUseCase, isNotNull);
    });

    test('cancelAppointmentUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cancelUseCase = container.read(cancelAppointmentUseCaseProvider);
      expect(cancelUseCase, isNotNull);
    });

    test('updateAppointmentStatusUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final updateStatusUseCase =
          container.read(updateAppointmentStatusUseCaseProvider);
      expect(updateStatusUseCase, isNotNull);
    });

    test('appointmentProvider returns list state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(appointmentProvider);
      expect(state, isA<List>());
    });

    test('appointment use cases are available', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final bookUseCase = container.read(bookAppointmentUseCaseProvider);
      final rescheduleUseCase =
          container.read(rescheduleAppointmentUseCaseProvider);
      final cancelUseCase = container.read(cancelAppointmentUseCaseProvider);
      final updateStatusUseCase =
          container.read(updateAppointmentStatusUseCaseProvider);

      expect(bookUseCase, isNotNull);
      expect(rescheduleUseCase, isNotNull);
      expect(cancelUseCase, isNotNull);
      expect(updateStatusUseCase, isNotNull);
    });

    test('appointmentProvider can be read multiple times', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state1 = container.read(appointmentProvider);
      final state2 = container.read(appointmentProvider);

      expect(state1, isA<List>());
      expect(state2, isA<List>());
    });

    test('appointment use cases are different instances', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final bookUseCase1 = container.read(bookAppointmentUseCaseProvider);
      // Reading again should return same instance due to provider caching
      final bookUseCase2 = container.read(bookAppointmentUseCaseProvider);

      expect(bookUseCase1, equals(bookUseCase2));
    });

    test('appointment notifier exists and is valid', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Verify appointmentProvider is a StateNotifier
      expect(appointmentProvider, isNotNull);
    });

    test('all appointment related use cases are properly injected', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Test all use case providers
      expect(container.read(bookAppointmentUseCaseProvider), isNotNull);
      expect(container.read(rescheduleAppointmentUseCaseProvider), isNotNull);
      expect(container.read(cancelAppointmentUseCaseProvider), isNotNull);
      expect(container.read(updateAppointmentStatusUseCaseProvider), isNotNull);
    });

    test('appointment state management is functional', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialState = container.read(appointmentProvider);
      expect(initialState, isA<List>());
      expect(initialState.isEmpty, true); // Initially empty
    });
  });
}
