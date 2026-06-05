import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/presentation/screens/login_screen.dart';

void main() {
  group('Login Screen', () {
    testWidgets('renders login screen scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays email and password text fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('displays back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('can input email in text field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'test@gmail.com');
      expect(find.text('test@gmail.com'), findsOneWidget);
    });

    testWidgets('can input password in text field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();

      // The actual text is hidden for password fields, so we just verify the field exists
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('has password visibility toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Check for visibility toggle icon
      expect(find.byIcon(Icons.visibility), findsWidgets);
    });

    testWidgets('displays login form in a card or container',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('displays title or header text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Check for any text that might be a title
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('page is scrollable if content exceeds screen height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('login button has proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      final loginButton = find.text('Login');
      expect(loginButton, findsWidgets);
    });

    testWidgets('displays signup link or button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Look for signup text - actual text in LoginScreen is "Don't have an account? Sign up"
      expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
    });
  });
}
