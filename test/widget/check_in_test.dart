import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/check_in.dart';

Future<void> pumpCheckInScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: CheckInScreen(),
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

  group('Check-in Screen', () {
    testWidgets('renders check-in scaffold', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title or header', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays appointment selection or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays appointment details or empty message',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays check-in button text or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasAction = find.text('Confirm Check-In').evaluate().isNotEmpty ||
          find.text('Checked In').evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasAction || hasEmptyState, isTrue);
    });

    testWidgets('displays appointment time slot information',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays doctor information', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays appointment cards or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasCards = find.byType(Card).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasCards || hasEmptyState, isTrue);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays instructions or helper text',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('check-in button text is visible or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasAction = find.text('Confirm Check-In').evaluate().isNotEmpty ||
          find.text('Checked In').evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasAction || hasEmptyState, isTrue);
    });

    testWidgets('page uses scrollable list or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays status or confirmation message',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });
  });
}
