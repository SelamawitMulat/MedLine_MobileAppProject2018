import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/main.dart'; // Ensure this matches your pubspec name

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // 1. Changed MyApp() to MedLineApp()
    await tester.pumpWidget(const MedLineApp());

    // 2. Updated these to look for text that ACTUALLY exists on your landing page
    // This looks for your main headline
    expect(find.textContaining('Modern'), findsOneWidget);

    // This verifies the login button is there
    expect(find.text('Login'), findsOneWidget);
  });
}
