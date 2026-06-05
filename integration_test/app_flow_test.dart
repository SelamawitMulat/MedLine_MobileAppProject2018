import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/main.dart' as app;

Future<void> _clearDatabase() async {
  final db = AppDatabase();
  await db.clearTable('users');
  await db.clearTable('appointments_cache');
  await db.clearTable('visit_summaries_cache');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('MedLine App Integration Tests', () {
    setUp(() async {
      await _clearDatabase();
    });

    testWidgets('Landing page navigates to login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Modern\nHealthcare\nQueue\nManagement'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Login'), findsOneWidget);

      await tester.tap(find.text('Login').first);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Email or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('Login -> Signup -> Back returns to Login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Login').first);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
      await tester.tap(find.text('Don\'t have an account? Sign up'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);

      // ensure back navigation returns to login
      expect(find.text('Sign Up'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Email or Username'), findsOneWidget);
    });
  });
}
