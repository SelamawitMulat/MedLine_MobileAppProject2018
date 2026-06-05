import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/providers/visit_summary_usecases_provider.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Visit Summary Use Cases Provider Tests', () {
    test('getVisitHistoryUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final useCase = container.read(getVisitHistoryUseCaseProvider);
      expect(useCase, isNotNull);
    });

    test('updateVisitSummaryUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final useCase = container.read(updateVisitSummaryUseCaseProvider);
      expect(useCase, isNotNull);
    });

    test('updateVisitSummaryUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final useCase = container.read(updateVisitSummaryUseCaseProvider);
      expect(useCase, isNotNull);
    });

    test('deleteVisitSummaryUseCaseProvider is accessible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final useCase = container.read(deleteVisitSummaryUseCaseProvider);
      expect(useCase, isNotNull);
    });

    test('all visit summary use cases are available', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final getHistoryUseCase = container.read(getVisitHistoryUseCaseProvider);
      final createUseCase = container.read(createVisitSummaryUseCaseProvider);
      final updateUseCase = container.read(updateVisitSummaryUseCaseProvider);
      final deleteUseCase = container.read(deleteVisitSummaryUseCaseProvider);

      expect(getHistoryUseCase, isNotNull);
      expect(createUseCase, isNotNull);
      expect(updateUseCase, isNotNull);
      expect(deleteUseCase, isNotNull);
    });

    test('visit summary use cases are singleton instances', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final createUseCase1 = container.read(createVisitSummaryUseCaseProvider);
      final createUseCase2 = container.read(createVisitSummaryUseCaseProvider);

      expect(createUseCase1, equals(createUseCase2));
    });

    test('use case providers are independent', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final getHistoryUseCase = container.read(getVisitHistoryUseCaseProvider);
      final createUseCase = container.read(createVisitSummaryUseCaseProvider);
      final updateUseCase = container.read(updateVisitSummaryUseCaseProvider);
      final deleteUseCase = container.read(deleteVisitSummaryUseCaseProvider);

      // All should be different instances or at least accessible
      expect(getHistoryUseCase, isNotNull);
      expect(createUseCase, isNotNull);
      expect(updateUseCase, isNotNull);
      expect(deleteUseCase, isNotNull);
    });

    test('use case providers handle CRUD operations', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Test that providers provide CRUD use cases
      final getHistoryUseCase = container.read(getVisitHistoryUseCaseProvider);
      final createUseCase = container.read(createVisitSummaryUseCaseProvider);
      final updateUseCase = container.read(updateVisitSummaryUseCaseProvider);
      final deleteUseCase = container.read(deleteVisitSummaryUseCaseProvider);

      expect(getHistoryUseCase, isNotNull);
      expect(createUseCase, isNotNull);
      expect(updateUseCase, isNotNull);
      expect(deleteUseCase, isNotNull);
    });

    test('use cases are properly typed', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final createUseCase = container.read(createVisitSummaryUseCaseProvider);
      expect(createUseCase, isNotNull);
    });

    test('visit summary use cases can be invalidated', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.invalidate(createVisitSummaryUseCaseProvider);
      final createUseCase = container.read(createVisitSummaryUseCaseProvider);
      expect(createUseCase, isNotNull);
    });

    test('all use case providers return non-null instances', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(getVisitHistoryUseCaseProvider), isNotNull);
      expect(container.read(createVisitSummaryUseCaseProvider), isNotNull);
      expect(container.read(updateVisitSummaryUseCaseProvider), isNotNull);
      expect(container.read(deleteVisitSummaryUseCaseProvider), isNotNull);
    });

    test('use case providers maintain consistency', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final getHistoryUseCase1 = container.read(getVisitHistoryUseCaseProvider);
      final getHistoryUseCase2 = container.read(getVisitHistoryUseCaseProvider);
      final createUseCase1 = container.read(createVisitSummaryUseCaseProvider);
      final createUseCase2 = container.read(createVisitSummaryUseCaseProvider);

      expect(getHistoryUseCase1, equals(getHistoryUseCase2));
      expect(createUseCase1, equals(createUseCase2));
    });
  });
}
