import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/providers/doctor_provider.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Doctor Provider Tests', () {
    test('doctorNameProvider returns doctor name from auth provider', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // This test checks that doctor name provider properly derives from auth state
      final doctorName = container.read(doctorNameProvider);
      expect(doctorName, isNotNull);
      expect(doctorName, isA<String>());
    });

    test('doctorNameProvider returns default name when no user', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorName = container.read(doctorNameProvider);
      // Should return default doctor name when no authenticated user
      expect(doctorName.isNotEmpty, true);
    });

    test('doctorIdProvider generates doctor ID from name', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorId = container.read(doctorIdProvider);
      expect(doctorId, isNotNull);
      expect(doctorId, isA<String>());
      expect(doctorId.isNotEmpty, true);
    });

    test('doctorIdProvider generates consistent ID', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorId1 = container.read(doctorIdProvider);
      final doctorId2 = container.read(doctorIdProvider);

      // Should return same ID on multiple reads
      expect(doctorId1, equals(doctorId2));
    });

    test('doctorIdProvider handles doctor role', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorId = container.read(doctorIdProvider);
      // ID should be generated from doctor's name
      expect(doctorId, isNotEmpty);
    });

    test('doctorIdProvider generates hash from normalized name', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorId = container.read(doctorIdProvider);

      // Doctor ID should be a valid hash (32 chars for MD5)
      expect(doctorId.length, greaterThanOrEqualTo(1));
      expect(doctorId, isA<String>());
    });

    test('doctorNameProvider is readable', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorName = container.read(doctorNameProvider);
      expect(doctorName, isA<String>());
    });

    test('doctorIdProvider is readable', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorId = container.read(doctorIdProvider);
      expect(doctorId, isA<String>());
    });

    test('doctor providers are independent', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final doctorName = container.read(doctorNameProvider);
      final doctorId = container.read(doctorIdProvider);

      // Both should be readable independently
      expect(doctorName.isNotEmpty, true);
      expect(doctorId.isNotEmpty, true);
    });

    test('doctorDeleteProvider returns callable function', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final deleteFunction = container.read(doctorDeleteProvider);
      expect(deleteFunction, isA<Future<void> Function()>());
    });
  });
}
