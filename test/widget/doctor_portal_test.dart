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
import 'package:med_line/features/home/presentation/screens/doctor_portal/doctor_portal.dart';

final _sampleUser = User(
  id: 'doctor-1',
  username: 'doctor1',
  role: 'doctor',
  name: 'Test Doctor',
  email: 'doctor@example.com',
  passwordHash: User.hashPassword('password123'),
);

final _sampleAppointments = [
  Appointment(
    id: '1',
    patientName: 'Test Patient',
    patientId: 'patient-1',
    doctorName: 'Test Doctor',
    date: DateTime.now().add(const Duration(hours: 2)),
    timeSlot: '09:00',
    status: Appointment.pending,
    reason: 'Routine checkup',
  ),
];

class FakeAuthNotifier extends AuthNotifier {
  @override
  FutureOr<User?> build() => _sampleUser;
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
    final matches = appointments.where((appointment) => appointment.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    return appointment;
  }
}

Future<void> pumpDoctorPortalScreen(WidgetTester tester,
    {List<Appointment>? appointments}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => FakeAuthNotifier()),
        homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(appointments ?? _sampleAppointments)),
      ],
      child: const MaterialApp(
        home: DoctorPortalScreen(),
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

  group('Doctor Portal', () {
    testWidgets('renders doctor portal scaffold', (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays the portal header and welcome text',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.text('Doctor Portal'), findsOneWidget);
      expect(find.textContaining('Dr.'), findsOneWidget);
    });

    testWidgets('displays queue management option',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.text('Queue\nManagement'), findsOneWidget);
    });

    testWidgets('displays visit summaries option',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.text('Visit\nSummaries'), findsOneWidget);
    });

    testWidgets('displays navigation cards and action buttons',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.text('Queue Overview'), findsOneWidget);
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('displays logout icon button', (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('does not require an AppBar for portal layout',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('portal contains navigation structure',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('displays doctor name or info if available',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      expect(find.textContaining('Test Doctor'), findsOneWidget);
    });

    testWidgets('displays professional layout for doctor',
        (WidgetTester tester) async {
      await pumpDoctorPortalScreen(tester);

      // Verify main structural elements
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
