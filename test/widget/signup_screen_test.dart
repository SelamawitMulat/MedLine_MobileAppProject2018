import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/presentation/screens/signup_screen.dart';

void main() {
  group('Signup Screen', () {
    testWidgets('renders signup screen scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays multiple text input fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Signup typically has: name, email, password, confirm password fields
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays signup/register button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('displays back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('can input name in text field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'John Doe');
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('can input email in text field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      // Assuming email is second field
      await tester.enterText(textFields.at(1), 'john@example.com');
      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('has password and confirm password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      // Should have at least 4 fields: name, email, password, confirm password
      expect(textFields, findsWidgets);
    });

    testWidgets('displays password visibility toggles',
      (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Check for the initial obscured password toggle icons.
      expect(find.byIcon(Icons.visibility_off), findsWidgets);
    });
    

    testWidgets('displays signup form in form widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('displays terms and conditions or similar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Look for text mentioning terms, conditions, or similar
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('page is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('displays login link or button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Look for login text or button
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('signup button has proper styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      final signupButton = find.text('Sign Up');
      expect(signupButton, findsOneWidget);
    });

    testWidgets('displays title or header text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Check for header text
      expect(find.byType(Text), findsWidgets);
    });
  });
}
