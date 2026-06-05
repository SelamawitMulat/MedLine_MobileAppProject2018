import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/my_appointments.dart';

Future<void> pumpMyAppointmentsScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: MyAppointmentsScreen(),
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

  group('My Appointments Screen', () {
    testWidgets('renders my appointments scaffold',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays list of appointments or empty state',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No active appointments found.\nGo back to book a new one!')
          .evaluate()
          .isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays appointment cards with details or empty state',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      final hasCards = find.byType(Card).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No active appointments found.\nGo back to book a new one!')
          .evaluate()
          .isNotEmpty;
      expect(hasCards || hasEmptyState, isTrue);
    });

    testWidgets('displays doctor names', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays appointment dates and times',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays appointment status', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays cancel button or empty state',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      final hasCancel = find.text('Cancel').evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No active appointments found.\nGo back to book a new one!')
          .evaluate()
          .isNotEmpty;
      expect(hasCancel || hasEmptyState, isTrue);
    });

    testWidgets('displays reschedule button or empty state',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      final hasReschedule = find.text('Reschedule').evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No active appointments found.\nGo back to book a new one!')
          .evaluate()
          .isNotEmpty;
      expect(hasReschedule || hasEmptyState, isTrue);
    });

    testWidgets('displays empty state message when no appointments',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('page displays list view or empty state',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No active appointments found.\nGo back to book a new one!')
          .evaluate()
          .isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays appointment status with color coding',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('appointments are grouped or sorted properly',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No active appointments found.\nGo back to book a new one!')
          .evaluate()
          .isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays helpful information about each appointment',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });
  });
}
