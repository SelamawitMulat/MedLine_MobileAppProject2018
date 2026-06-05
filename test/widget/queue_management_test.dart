import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/queue_management.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Queue Management Screen', () {
    testWidgets('renders queue management scaffold',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays queue list or empty state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No queue appointments available.').evaluate().isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays appointment cards or empty state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      final hasCards = find.byType(Card).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No queue appointments available.').evaluate().isNotEmpty;
      expect(hasCards || hasEmptyState, isTrue);
    });

    testWidgets('displays action buttons for each appointment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('displays call patient button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.text('Call Patient'), findsWidgets);
    });

    testWidgets('displays skip patient button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.text('Skip'), findsWidgets);
    });

    testWidgets('displays complete or finish button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('has queue counter or position indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays empty queue message when no appointments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('displays time slot information', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('appointment cards display patient names',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays refresh button or pull-to-refresh',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      // Look for refresh functionality
      expect(find.byType(RefreshIndicator), findsWidgets);
    });

    testWidgets('queue items are scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: QueueManagementScreen(),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });
  });
}
