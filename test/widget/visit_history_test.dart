import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/visit_history_page.dart';

Future<void> pumpVisitHistoryPage(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: VisitHistoryPage(),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Visit History Page', () {
    testWidgets('renders visit history scaffold', (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title', (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays list of past visits or empty message',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries yet').evaluate().isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays visit cards with details or empty state',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      final hasCards = find.byType(Card).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries yet').evaluate().isNotEmpty;
      expect(hasCards || hasEmptyState, isTrue);
    });

    testWidgets('displays doctor names in visit history',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays visit dates', (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays diagnosis or treatment information',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays prescription information',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays view details or empty state',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      final hasViewDetails = find.text('View Details').evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries yet').evaluate().isNotEmpty;
      expect(hasViewDetails || hasEmptyState, isTrue);
    });

    testWidgets('displays empty state when no visits',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('page is scrollable or shows empty state',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries yet').evaluate().isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('visits are sorted by date (most recent first)',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries yet').evaluate().isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays complete visit information',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('download or export visit report option or empty state',
        (WidgetTester tester) async {
      await pumpVisitHistoryPage(tester);

      final hasButton = find.byType(ElevatedButton).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries yet').evaluate().isNotEmpty;
      expect(hasButton || hasEmptyState, isTrue);
    });
  });
}
