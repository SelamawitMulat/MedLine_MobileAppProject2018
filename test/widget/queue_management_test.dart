import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/data/providers.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/queue_management.dart';

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
    id: 'appointment-1',
    patientName: 'John Doe',
    patientId: 'patient-1',
    date: DateTime.now().add(const Duration(days: 1)),
    timeSlot: '09:00',
    doctorName: 'Dr. Selam Mulat',
    status: 'pending',
    reason: 'Review test results',
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

class FakeVisitSummaryRepository implements IVisitSummaryRepository {
  final List<VisitSummary> summaries;

  FakeVisitSummaryRepository([this.summaries = const <VisitSummary>[]]);

  @override
  Future<VisitSummary> addVisitSummary(VisitSummary summary) async {
    return summary;
  }

  @override
  Future<void> deleteVisitSummary(String appointmentId) async {}

  @override
  Future<List<VisitSummary>> getVisitSummaries() async {
    return summaries;
  }

  @override
  Future<VisitSummary> updateVisitSummary(VisitSummary summary) async {
    return summary;
  }
}

Future<void> pumpQueueManagementScreen(WidgetTester tester,
    {List<Appointment>? appointments}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => FakeAuthNotifier()),
        homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(appointments ?? _sampleAppointments)),
        visitSummaryRepositoryProvider.overrideWithValue(
            FakeVisitSummaryRepository(const <VisitSummary>[])),
      ],
      child: const MaterialApp(
        home: QueueManagementScreen(),
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

  group('Queue Management Screen', () {
    testWidgets('renders queue management scaffold',
        (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title', (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.text('Queue Management'), findsOneWidget);
    });

    testWidgets('displays queue list when appointments exist',
        (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('displays appointment item details',
        (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.textContaining('09:00'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('displays empty queue message when no appointments',
        (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester, appointments: []);

      expect(find.text('No queue appointments available.'), findsOneWidget);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('displays appointment status label',
        (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('displays skip and complete action buttons',
        (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('queue items are scrollable', (WidgetTester tester) async {
      await pumpQueueManagementScreen(tester);

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
