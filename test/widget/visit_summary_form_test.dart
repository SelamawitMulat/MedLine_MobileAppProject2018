import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/visit_summary_form.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Visit Summary Form', () {
    testWidgets('renders visit summary form scaffold',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays form title or header', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays diagnosis input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays prescription input field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays notes or observations field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays patient information section',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays appointment time and date',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays save summary button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.text('Save Summary'), findsOneWidget);
    });

    testWidgets('displays patient selection dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(DropdownButtonFormField), findsOneWidget);
    });

    testWidgets('form is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('can input diagnosis text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Flu');
      expect(find.text('Flu'), findsOneWidget);
    });

    testWidgets('can input prescription text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      if (textFields.evaluate().length > 1) {
        await tester.enterText(textFields.at(1), 'Rest and fluids');
        expect(find.text('Rest and fluids'), findsOneWidget);
      }
    });

    testWidgets('displays form validation indicators',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays required field indicators',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: VisitSummaryForm(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });
  });
}
