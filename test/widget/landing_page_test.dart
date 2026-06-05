import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/home/presentation/screens/landing_page.dart';
import 'package:med_line/features/home/presentation/widgets/role_benefit_card.dart';
import 'package:med_line/core/widgets/primary_button.dart';

void main() {
  group('Landing Page Screen', () {
    testWidgets('renders landing page scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title text with multiple lines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.text('Modern\nHealthcare\nQueue\nManagement'), findsOneWidget);
    });

    testWidgets('displays description text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((widget) =>
            widget is Text &&
            widget.data?.contains('Streamline your clinic') == true),
        findsOneWidget,
      );
    });

    testWidgets('displays Login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('displays role cards for patients and doctors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.text('For Patients'), findsOneWidget);
      expect(find.text('For Doctors'), findsOneWidget);
    });

    testWidgets('displays two role benefit cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.byType(RoleBenefitCard), findsNWidgets(2));
    });

    testWidgets('displays primary buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.byType(PrimaryButton), findsWidgets);
    });

    testWidgets('displays cta section with Create Account button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.text('Create Your Account'), findsOneWidget);
    });

    testWidgets('page is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('has safe area widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('displays icons for patient and doctor roles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      expect(find.byIcon(Icons.monitor_heart_outlined), findsOneWidget);
    });

    testWidgets('displays footer copyright text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandingScreen(),
          ),
        ),
      );

      expect(find.text('© 2026 MedLine. Clinical Appointment System.'),
          findsOneWidget);
    });
  });
}
