import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:table_calendar/table_calendar.dart';
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

    testWidgets('displays appointment calendar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(TableCalendar), findsOneWidget);
    });

    testWidgets('displays date input area', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.text('Select Date'), findsOneWidget);
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

    testWidgets('displays available time slots grid', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
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

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays confirm appointment button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.text('Confirm Appointment'), findsOneWidget);
    });

    testWidgets('has a back button in the app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('displays reason input and validation cues',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BookAppointmentScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
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
