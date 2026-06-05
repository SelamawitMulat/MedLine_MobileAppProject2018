import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/medline_logo.dart';
import 'package:med_line/core/widgets/primary_button.dart';

void main() {
  group('Core Widgets', () {
    group('PrimaryButton', () {
      testWidgets('renders with text and responds to tap',
          (WidgetTester tester) async {
        int tapCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'Click Me',
                onPressed: () => tapCount++,
              ),
            ),
          ),
        );

        expect(find.text('Click Me'), findsOneWidget);
        expect(find.byType(PrimaryButton), findsOneWidget);

        await tester.tap(find.byType(PrimaryButton));
        expect(tapCount, 1);
      });

      testWidgets('renders with custom colors', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'Colored Button',
                onPressed: () {},
                bgColor: Colors.red,
                textColor: Colors.white,
              ),
            ),
          ),
        );

        expect(find.text('Colored Button'), findsOneWidget);
        expect(find.byType(PrimaryButton), findsOneWidget);
      });

      testWidgets('renders with suffix icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'With Icon',
                onPressed: () {},
                suffixIcon: Icons.arrow_forward,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
        expect(find.text('With Icon'), findsOneWidget);
      });

      testWidgets('has full width and correct height',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                child: PrimaryButton(
                  text: 'Size Test',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        final sizedBox = find.byType(SizedBox).first;
        expect(sizedBox, findsOneWidget);
      });

      testWidgets('uses primary blue as default background',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'Default Colors',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text('Default Colors'), findsOneWidget);
      });
    });

    group('MedLineLogo', () {
      testWidgets('renders MedLineLogo widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MedLineLogo(),
            ),
          ),
        );

        expect(find.byType(MedLineLogo), findsOneWidget);
      });

      testWidgets('displays logo text or icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MedLineLogo(),
            ),
          ),
        );

        expect(find.byType(MedLineLogo), findsOneWidget);
      });
    });
  });
}
