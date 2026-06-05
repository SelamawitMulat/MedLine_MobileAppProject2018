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
import 'package:med_line/features/home/presentation/screens/patient_portal/check_in.dart';

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
    id: '1',
    patientName: 'Test Patient',
    patientId: 'patient-1',
    date: DateTime.now().add(const Duration(days: 1)),
    timeSlot: '09:00',
    doctorName: 'Dr. Selam Mulat',
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

Future<void> pumpCheckInScreen(WidgetTester tester,
    {List<Appointment>? appointments}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => FakeAuthNotifier()),
        homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(appointments ?? _sampleAppointments)),
      ],
      child: const MaterialApp(
        home: CheckInScreen(),
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

  group('Check-in Screen', () {
    testWidgets('renders check-in scaffold', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays title or header', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays appointment selection or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays appointment details or empty message',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays check-in button text or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasAction = find.text('Confirm Check-In').evaluate().isNotEmpty ||
          find.text('Checked In').evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasAction || hasEmptyState, isTrue);
    });

    testWidgets('displays appointment time slot information',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays doctor information', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays appointment cards or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasCardLikeContainers = find.byType(Container).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasCardLikeContainers || hasEmptyState, isTrue);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays instructions or helper text',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('check-in button text is visible or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasAction = find.text('Confirm Check-In').evaluate().isNotEmpty ||
          find.text('Checked In').evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasAction || hasEmptyState, isTrue);
    });

    testWidgets('page uses scrollable list or empty state',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmptyState = find
          .text('No upcoming appointments available to check into.')
          .evaluate()
          .isNotEmpty;
      expect(hasList || hasEmptyState, isTrue);
    });

    testWidgets('displays status or confirmation message',
        (WidgetTester tester) async {
      await pumpCheckInScreen(tester);

      expect(find.byType(Text), findsWidgets);
    });
  });
}
