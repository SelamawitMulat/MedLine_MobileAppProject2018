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
import 'package:med_line/features/home/presentation/screens/patient_portal/patient_portal.dart';

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

Future<void> pumpPatientPortalScreen(WidgetTester tester,
    {List<Appointment>? appointments}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => FakeAuthNotifier()),
        homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(appointments ?? _sampleAppointments)),
      ],
      child: const MaterialApp(
        home: PatientPortalScreen(),
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

  group('Patient Portal', () {
    testWidgets('renders patient portal scaffold', (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays welcome text for patient',
        (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.textContaining('Hi, Test Patient'), findsOneWidget);
    });

    testWidgets('displays appointment booking option',
        (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.textContaining('Book'), findsWidgets);
    });

    testWidgets('displays my appointments option', (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.textContaining('My'), findsWidgets);
      expect(find.textContaining('Appointments'), findsWidgets);
    });

    testWidgets('displays check-in option', (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.text('Check In'), findsOneWidget);
    });

    testWidgets('displays visit history option', (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.textContaining('Visit'), findsWidgets);
      expect(find.textContaining('History'), findsWidgets);
    });

    testWidgets('displays action tiles grid', (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays delete and logout icons', (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('page contains scrollable layout', (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('all patient options are visible and accessible',
        (WidgetTester tester) async {
      await pumpPatientPortalScreen(tester);

      expect(find.textContaining('Book'), findsWidgets);
      expect(find.textContaining('My'), findsWidgets);
      expect(find.text('Check In'), findsOneWidget);
      expect(find.textContaining('Visit'), findsWidgets);
      expect(find.textContaining('History'), findsWidgets);
    });
  });
}
