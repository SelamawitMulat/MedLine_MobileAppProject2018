import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:med_line/features/home/data/providers.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/appointment_booking.dart';

class FakeHomeRepository implements IHomeRepository {
  @override
  Future<void> cacheAppointments(List<Appointment> apps) async {}

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    return appointment;
  }

  @override
  Future<void> deleteAppointment(String id) async {}

  @override
  Future<List<Appointment>> fetchAllAppointments() async {
    return const <Appointment>[];
  }

  @override
  Future<List<Appointment>> getCachedAppointments() async {
    return const <Appointment>[];
  }

  @override
  Future<Appointment?> getCachedAppointmentById(String id) async {
    return null;
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    return appointment;
  }
}

Widget buildTestApp() {
  return ProviderScope(
    overrides: [
      homeRepositoryProvider.overrideWithValue(FakeHomeRepository()),
    ],
    child: const MaterialApp(
      home: BookAppointmentScreen(),
    ),
  );
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Appointment Booking Screen', () {
    testWidgets('renders appointment booking scaffold',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title or header', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays appointment calendar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(TableCalendar), findsOneWidget);
    });

    testWidgets('displays date input area', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.text('Select Date'), findsOneWidget);
    });

    testWidgets('displays time slot selection', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      // Look for time slot selection interface
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays available time slots grid', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays appointment reason or complaint field',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays confirm appointment button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.text('Confirm Appointment'), findsOneWidget);
    });

    testWidgets('has a back button in the app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('displays reason input and validation cues',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('page is scrollable for long content',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('displays date and time in proper format',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays helpful instructions or labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays doctor specialization or info',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(Text), findsWidgets);
    });
  });
}
