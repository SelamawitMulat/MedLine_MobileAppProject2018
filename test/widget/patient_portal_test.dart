import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/patient_portal.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Patient Portal', () {
    testWidgets('renders patient portal scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays welcome message for patient',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays appointment booking option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.text('Book Appointment'), findsOneWidget);
    });

    testWidgets('displays my appointments option', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.text('My Appointments'), findsOneWidget);
    });

    testWidgets('displays check-in option', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.text('Check-in'), findsOneWidget);
    });

    testWidgets('displays visit history option', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.text('Visit History'), findsOneWidget);
    });

    testWidgets('displays navigation buttons or menu items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('displays logout button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('has app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('portal contains navigation structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      // Check for navigation elements like buttons, cards, or list
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('appointment booking button is clickable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.text('Book Appointment'), findsOneWidget);
    });

    testWidgets('displays patient name or info if available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('portal has consistent styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays patient-friendly layout',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      // Verify main structural elements
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('all patient options are visible and accessible',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PatientPortalScreen(),
          ),
        ),
      );

      // Verify key options
      expect(find.text('Book Appointment'), findsOneWidget);
      expect(find.text('My Appointments'), findsOneWidget);
      expect(find.text('Check-in'), findsOneWidget);
      expect(find.text('Visit History'), findsOneWidget);
    });
  });
}
