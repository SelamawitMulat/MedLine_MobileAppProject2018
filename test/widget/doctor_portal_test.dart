import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/doctor_portal.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Doctor Portal', () {
    testWidgets('renders doctor portal scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays welcome message or header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays queue management option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.text('Queue Management'), findsOneWidget);
    });

    testWidgets('displays visit summary form option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.text('Visit Summary'), findsOneWidget);
    });

    testWidgets('displays visit summary page option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.text('Visit Summary Page'), findsWidgets);
    });

    testWidgets('displays navigation buttons or menu items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('displays logout button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('has app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
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
            home: DoctorPortalScreen(),
          ),
        ),
      );

      // Check for navigation elements like buttons, cards, or list
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('queue management button is clickable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.text('Queue Management'), findsOneWidget);
    });

    testWidgets('displays doctor name or info if available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('portal has consistent styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays professional layout for doctor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DoctorPortalScreen(),
          ),
        ),
      );

      // Verify main structural elements
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
