import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/data/providers.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/my_appointments.dart';

final _sampleUser = User(
  id: 'patient-1',
  username: 'patient1',
  role: 'patient',
  name: 'Test Patient',
  email: 'patient@example.com',
  passwordHash: User.hashPassword('password123'),
);

final _sampleAppointments = [
  Appointment(
    id: 'appointment-1',
    patientName: 'Test Patient',
    patientId: 'patient-1',
    date: DateTime.now().add(const Duration(days: 1)),
    timeSlot: '09:00',
    doctorName: 'Dr. Selam Mulat',
    status: 'pending',
    reason: 'Routine checkup',
  ),
];

class FakeAuthNotifier extends AuthNotifier {
  @override
  FutureOr<User?> build() {
    return _sampleUser;
  }
}

class FakeHomeRepository implements IHomeRepository {
  final List<Appointment> appointments;

  FakeHomeRepository([this.appointments = const <Appointment>[]]);

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
    return appointments;
  }

  @override
  Future<List<Appointment>> getCachedAppointments() async {
    return appointments;
  }

  @override
  Future<Appointment?> getCachedAppointmentById(String id) async {
    for (final appointment in appointments) {
      if (appointment.id == id) {
        return appointment;
      }
    }
    return null;
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    return appointment;
  }
}

Future<void> pumpMyAppointmentsScreen(WidgetTester tester,
    {List<Appointment>? appointments}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => FakeAuthNotifier()),
        homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(appointments ?? _sampleAppointments)),
      ],
      child: const MaterialApp(
        home: MyAppointmentsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('My Appointments Screen', () {
    testWidgets('renders my appointments scaffold',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('My Appointments'), findsOneWidget);
    });

    testWidgets('displays appointment list', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(ListView), findsOneWidget);
      expect(find.textContaining('Routine checkup'), findsOneWidget);
    });

    testWidgets('displays appointment details', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.text('Routine checkup'), findsOneWidget);
      expect(find.text('09:00'), findsOneWidget);
    });

    testWidgets('displays cancel and reschedule buttons',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Reschedule'), findsOneWidget);
    });

    testWidgets('displays empty state message when no appointments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthNotifier()),
            homeRepositoryProvider.overrideWithValue(FakeHomeRepository()),
          ],
          child: const MaterialApp(
            home: MyAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No active appointments found.\nGo back to book a new one!'),
          findsOneWidget);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('displays appointment status text',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('displays helpful appointment information',
        (WidgetTester tester) async {
      await pumpMyAppointmentsScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });
  });
}
