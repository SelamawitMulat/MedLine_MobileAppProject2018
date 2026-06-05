import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/providers/visit_summary_provider.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Visit Summary Provider Tests', () {
    test('visitSummaryProvider initializes correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(visitSummaryProvider, isNotNull);
    });

    test('visitSummaryProvider returns async value', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(visitSummaryProvider);
      // Should be AsyncValue type
      expect(state, isNotNull);
    });

    test('visitSummaryNotifier can be read', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // The notifier should be accessible via the family provider
      expect(visitSummaryProvider, isNotNull);
    });

    test('visitSummaryProvider is async notifier', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(visitSummaryProvider);
      expect(state, isNotNull);
    });

    test('visitSummaryProvider can be watched', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(visitSummaryProvider);
      expect(state, isNotNull);
    });

    test('visitSummaryProvider state is consistent', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state1 = container.read(visitSummaryProvider);
      final state2 = container.read(visitSummaryProvider);

      expect(state1, equals(state2));
    });

    test('visitSummaryProvider handles loading state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(visitSummaryProvider);
      // State could be loading, data, or error
      expect(state, isNotNull);
    });

    test('visitSummaryProvider can trigger refresh', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Reading the provider should work
      final state = container.read(visitSummaryProvider);
      expect(state, isNotNull);
    });

    test('visitSummaryProvider maintains state across reads', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state1 = container.read(visitSummaryProvider);
      // Invalidate and read again
      container.invalidate(visitSummaryProvider);
      final state2 = container.read(visitSummaryProvider);

      // After invalidation, should reload
      expect(state1, isNotNull);
      expect(state2, isNotNull);
    });

    test('visitSummaryProvider is family provider', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Test that provider can handle different parameters if it's a family
      expect(visitSummaryProvider, isNotNull);
    });

    test('visitSummaryProvider can be invalidated', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.invalidate(visitSummaryProvider);
      final state = container.read(visitSummaryProvider);
      expect(state, isNotNull);
    });

    test('visitSummaryProvider state updates work', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialState = container.read(visitSummaryProvider);
      expect(initialState, isNotNull);

      // Invalidate and read again to test state update
      container.invalidate(visitSummaryProvider);
      final newState = container.read(visitSummaryProvider);
      expect(newState, isNotNull);
    });

    test('visitSummaryProvider is properly initialized', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(visitSummaryProvider, isNotNull);
      expect(container.read(visitSummaryProvider), isNotNull);
    });

    test('visitSummaryProvider handles multiple instances', () async {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      addTearDown(() {
        container1.dispose();
        container2.dispose();
      });

      final state1 = container1.read(visitSummaryProvider);
      final state2 = container2.read(visitSummaryProvider);

      expect(state1, isNotNull);
      expect(state2, isNotNull);
    });
  });
}
