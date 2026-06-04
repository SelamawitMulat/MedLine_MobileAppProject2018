import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/main.dart'; // Ensure this matches your pubspec name

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Wrap with ProviderScope so Riverpod state is available in the router redirect
    await tester.pumpWidget(
      const ProviderScope(
        child: MedLineApp(),
      ),
    );

    // This looks for your main headline text from the landing page
    expect(find.textContaining('Modern'), findsOneWidget);

    // This verifies there are login buttons (there are 2 on the landing page)
    expect(find.text('Login'), findsNWidgets(2));
  });
}
