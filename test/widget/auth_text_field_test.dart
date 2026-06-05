import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  group('Auth Text Field', () {
    testWidgets('renders with label and hint', (WidgetTester tester) async {
      final widget = AuthTextField(
        label: 'Email',
        hint: 'Enter your email',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: widget),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('can be configured as password field',
        (WidgetTester tester) async {
      final widget = AuthTextField(
        label: 'Password',
        hint: 'Enter password',
        isPassword: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: widget),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders TextField widget', (WidgetTester tester) async {
      final widget = AuthTextField(
        label: 'Username',
        hint: 'Enter username',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: widget),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('applies styling', (WidgetTester tester) async {
      final widget = AuthTextField(
        label: 'Test Field',
        hint: 'Test hint',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: widget),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('accepts multiple instances', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AuthTextField(label: 'Username', hint: 'Enter username'),
                AuthTextField(
                    label: 'Password',
                    hint: 'Enter password',
                    isPassword: true),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(AuthTextField), findsNWidgets(2));
    });
  });
}
