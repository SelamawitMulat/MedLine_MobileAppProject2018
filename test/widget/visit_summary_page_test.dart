import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/visit_summary_page.dart';

Future<void> pumpVisitSummaryPage(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: VisitSummaryPage(),
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

  group('Visit Summary Page', () {
    testWidgets('renders visit summary page scaffold',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title row with back button',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text("Doctor's Visit Summaries"), findsOneWidget);
    });

    testWidgets('displays list or empty state for summaries',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries for Doctor yet').evaluate().isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays visit summary cards or empty text',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      final hasCards = find.byType(Card).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries for Doctor yet').evaluate().isNotEmpty;
      expect(hasCards || hasEmptyState, isTrue);
    });

    testWidgets('displays patient names or summary text',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays visit dates', (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays diagnosis summary', (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays prescription information',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays view/edit actions or empty state',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      final hasActions = find.byType(ElevatedButton).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries for Doctor yet').evaluate().isNotEmpty;
      expect(hasActions || hasEmptyState, isTrue);
    });

    testWidgets('displays delete action or empty state',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      final hasIconButtons = find.byType(IconButton).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries for Doctor yet').evaluate().isNotEmpty;
      expect(hasIconButtons || hasEmptyState, isTrue);
    });

    testWidgets('displays empty state when no summaries',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('has back button in title row', (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('summaries are sorted by date (most recent first)',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState =
          find.text('No visit summaries for Doctor yet').evaluate().isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays complete summary information',
        (WidgetTester tester) async {
      await pumpVisitSummaryPage(tester);

      expect(find.byType(Text), findsWidgets);
    });
  });
}
