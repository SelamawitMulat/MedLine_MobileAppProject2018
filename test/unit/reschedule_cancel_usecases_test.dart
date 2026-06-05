import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/usecases/reschedule_appointment.dart';
import 'package:med_line/features/home/domain/usecases/cancel_appointment.dart';

class FakeHomeRepository implements IHomeRepository {
  Appointment? stored;
  bool updateCalled = false;

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    updateCalled = true;
    stored = appointment;
    return appointment;
  }

  @override
  Future<Appointment?> getCachedAppointmentById(String id) async => stored;

  @override
  Future<void> cacheAppointments(List<Appointment> apps) async {}

  @override
  Future<void> deleteAppointment(String id) async {}

  @override
  Future<Appointment> createAppointment(Appointment appointment) async =>
      appointment;

  @override
  Future<List<Appointment>> fetchAllAppointments() async => [];

  @override
  Future<List<Appointment>> getCachedAppointments() async => [];
}

void main() {
  group('RescheduleAppointmentUseCase', () {
    test('throws when rescheduling into the past', () async {
      final repo = FakeHomeRepository();
      final usecase = RescheduleAppointmentUseCase(repo);

      final ap = Appointment(
        id: 'r1',
        patientName: 'P',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
      );

      expect(
        () => usecase.call(ap, DateTime(2020, 1, 1), '09:00', []),
        throwsA(isA<Exception>()),
      );
    });

    test('throws on conflict with existing appointment', () async {
      final repo = FakeHomeRepository();
      final usecase = RescheduleAppointmentUseCase(repo);

      final ap = Appointment(
        id: 'r1',
        patientName: 'P',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
      );

      final existing = Appointment(
        id: 'r2',
        patientName: 'Q',
        date: DateTime(2025, 2, 1),
        timeSlot: '10:00',
      );

      expect(
        () => usecase.call(ap, DateTime(2025, 2, 1), '10:00', [existing]),
        throwsA(isA<Exception>()),
      );
    });

    test('reschedules appointment successfully', () async {
      final repo = FakeHomeRepository();
      final usecase = RescheduleAppointmentUseCase(repo);

      final ap = Appointment(
        id: 'r1',
        patientName: 'P',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        status: 'pending',
      );

      final newDate = DateTime.now().add(Duration(days: 5));
      final result = await usecase.call(ap, newDate, '14:00', []);

      expect(result.status, 'pending');
      expect(result.timeSlot, '14:00');
      expect(result.date.day, newDate.day);
      expect(repo.updateCalled, isTrue);
    });
  });

  group('CancelAppointmentUseCase', () {
    test('throws when appointment not found', () async {
      final repo = FakeHomeRepository();
      repo.stored = null;
      final usecase = CancelAppointmentUseCase(repo);

      expect(
        () => usecase.call('notfound'),
        throwsA(isA<Exception>()),
      );
    });

    test('cancels appointment successfully', () async {
      final repo = FakeHomeRepository();
      repo.stored = Appointment(
        id: 'c1',
        patientName: 'P',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        status: 'pending',
      );
      final usecase = CancelAppointmentUseCase(repo);

      final result = await usecase.call('c1');

      expect(result.status, 'cancelled');
      expect(repo.updateCalled, isTrue);
    });
  });
}
