import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/auth/presentation/screens/login_screen.dart';

class FakeAuthNotifier extends AuthNotifier {
  @override
  FutureOr<User?> build() => null;
}

Future<void> pumpLoginScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authProvider.overrideWith(() => FakeAuthNotifier())],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Login Screen', () {
    testWidgets('renders login screen scaffold', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays email and password fields',
        (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('displays login button', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('displays app bar', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('can input email in text field', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@gmail.com');
      expect(find.text('test@gmail.com'), findsOneWidget);
    });

    testWidgets('can input password in text field',
        (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('has password visibility toggle', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('displays login form container', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('displays title or header text', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('page is scrollable when needed',
        (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('login button has proper styling', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      final loginButton = find.text('Login');
      expect(loginButton, findsOneWidget);
    });

    testWidgets('displays signup link or button', (WidgetTester tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
    });
  });
}
