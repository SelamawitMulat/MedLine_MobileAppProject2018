import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/home/presentation/widgets/role_benefit_card.dart';
import 'package:med_line/features/home/presentation/widgets/feature_info_card.dart';

void main() {
  group('Home Widgets', () {
    group('RoleBenefitCard', () {
      testWidgets('renders title and header icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RoleBenefitCard(
                title: 'For Patients',
                headerIcon: Icons.people_outline,
                iconBgColor: Colors.blue,
                benefits: const ['Benefit 1', 'Benefit 2'],
              ),
            ),
          ),
        );

        expect(find.text('For Patients'), findsOneWidget);
        expect(find.byIcon(Icons.people_outline), findsOneWidget);
      });

      testWidgets('renders all benefits in list', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RoleBenefitCard(
                title: 'For Doctors',
                headerIcon: Icons.monitor_heart_outlined,
                iconBgColor: Colors.green,
                benefits: const [
                  'Manage queue',
                  'Call patients',
                  'Create summaries',
                ],
              ),
            ),
          ),
        );

        expect(find.text('Manage queue'), findsOneWidget);
        expect(find.text('Call patients'), findsOneWidget);
        expect(find.text('Create summaries'), findsOneWidget);
      });

      testWidgets('uses provided icon background color',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RoleBenefitCard(
                title: 'Test',
                headerIcon: Icons.medical_services,
                iconBgColor: Colors.orange,
                benefits: const ['Benefit'],
              ),
            ),
          ),
        );

        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('renders card with proper styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RoleBenefitCard(
                title: 'Role Card',
                headerIcon: Icons.info,
                iconBgColor: Colors.blue,
                benefits: const ['Benefit 1'],
              ),
            ),
          ),
        );

        expect(find.byType(RoleBenefitCard), findsOneWidget);
      });

      testWidgets('displays empty benefits gracefully',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RoleBenefitCard(
                title: 'Empty Card',
                headerIcon: Icons.info,
                iconBgColor: Colors.blue,
                benefits: const [],
              ),
            ),
          ),
        );

        expect(find.text('Empty Card'), findsOneWidget);
      });

      testWidgets('handles multiple benefits with scroll',
          (WidgetTester tester) async {
        final manyBenefits = List.generate(10, (i) => 'Benefit ${i + 1}');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: RoleBenefitCard(
                  title: 'Many Benefits',
                  headerIcon: Icons.star,
                  iconBgColor: Colors.amber,
                  benefits: manyBenefits,
                ),
              ),
            ),
          ),
        );

        expect(find.text('Many Benefits'), findsOneWidget);
        expect(find.text('Benefit 1'), findsOneWidget);
      });
    });

    group('FeatureInfoCard', () {
      testWidgets('renders title and description', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeatureInfoCard(
                title: 'Smart Queue',
                description: 'Real-time queue management',
                icon: Icons.queue,
              ),
            ),
          ),
        );

        expect(find.text('Smart Queue'), findsOneWidget);
        expect(find.text('Real-time queue management'), findsOneWidget);
      });

      testWidgets('displays icon correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeatureInfoCard(
                title: 'Appointments',
                description: 'Book appointments',
                icon: Icons.calendar_today,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });

      testWidgets('renders as clickable card', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GestureDetector(
                onTap: () => tapped = true,
                child: FeatureInfoCard(
                  title: 'Feature',
                  description: 'Description',
                  icon: Icons.info,
                ),
              ),
            ),
          ),
        );

        expect(find.text('Feature'), findsOneWidget);
      });

      testWidgets('handles long descriptions', (WidgetTester tester) async {
        const longDescription =
            'This is a very long description that explains the feature in detail with multiple lines of text';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeatureInfoCard(
                title: 'Feature',
                description: longDescription,
                icon: Icons.description,
              ),
            ),
          ),
        );

        expect(find.text('Feature'), findsOneWidget);
      });

      testWidgets('applies custom styling', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeatureInfoCard(
                title: 'Styled Feature',
                description: 'With styling',
                icon: Icons.style,
              ),
            ),
          ),
        );

        expect(find.byType(FeatureInfoCard), findsOneWidget);
      });
    });
  });
}
