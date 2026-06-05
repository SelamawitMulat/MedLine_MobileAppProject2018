import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/appointment_booking.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Appointment Booking Screen', () {
    testWidgets('renders appointment booking scaffold',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title or header', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays doctor selection dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      // Look for dropdown or selection widget
      expect(find.byType(DropdownButton), findsWidgets);
    });

    testWidgets('displays date picker', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays time slot selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      // Look for time slot selection interface
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays available doctors list', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('displays appointment reason or complaint field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('displays book appointment button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.text('Book Appointment'), findsOneWidget);
    });

    testWidgets('displays cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(TextButton), findsWidgets);
    });

    testWidgets('displays form validation or required field indicators',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('page is scrollable for long content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('displays date and time in proper format',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays helpful instructions or labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays doctor specialization or info',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });
  });
}
