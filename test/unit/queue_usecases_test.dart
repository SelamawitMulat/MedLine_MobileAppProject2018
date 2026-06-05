import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/usecases/queue/get_queue.dart';
import 'package:med_line/features/home/domain/usecases/queue/update_queue_order.dart';
import 'package:med_line/features/home/domain/usecases/queue/call_next_patient.dart';
import 'package:med_line/features/home/domain/usecases/queue/skip_patient.dart';

class FakeHomeRepository implements IHomeRepository {
  Appointment? byId;
  bool updated = false;

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
  Future<Appointment?> getCachedAppointmentById(String id) async => byId;

  @override
  Future<List<Appointment>> getCachedAppointments() async => [];

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    updated = true;
    byId = appointment;
    return appointment;
  }
}

Appointment make(String id, String doctorName, DateTime date, String timeSlot,
    {String status = 'pending'}) {
  return Appointment(
    id: id,
    patientName: 'p',
    date: date,
    timeSlot: timeSlot,
    doctorName: doctorName,
    status: status,
  );
}

void main() {
  group('Queue usecases', () {
    test('GetQueue filters and orders properly', () {
      final usecase = GetQueueUseCase();
      final apps = [
        make('1', 'Dr. Alice', DateTime(2023, 1, 1), '09:00'),
        make('2', 'Alice', DateTime(2023, 1, 1), '08:00'),
        make('3', 'Dr. Alice', DateTime(2023, 1, 1), '10:00',
            status: 'cancelled'),
      ];

      final queue = usecase.call(apps, 'Dr. Alice');
      expect(queue.length, 2);
      expect(queue[0].id, '2');
      expect(queue[1].id, '1');
    });

    test('UpdateQueueOrder sorts correctly', () {
      final usecase = UpdateQueueOrderUseCase();
      final apps = [
        make('1', 'Dr. Bob', DateTime(2023, 1, 1), '12:00'),
        make('2', 'Bob', DateTime(2023, 1, 1), '08:00'),
      ];

      final ordered = usecase.call(apps, 'Dr. Bob');
      expect(ordered[0].id, '2');
      expect(ordered[1].id, '1');
    });

    test('CallNextPatient returns next pending appointment', () async {
      final repo = FakeHomeRepository();
      final usecase = CallNextPatientUseCase(repo);

      final apps = [
        make('a', 'Dr. Z', DateTime(2023, 1, 2), '09:00', status: 'pending'),
        make('b', 'Dr. Z', DateTime(2023, 1, 1), '09:00', status: 'pending'),
      ];

      final next = await usecase.call(apps, 'Dr. Z');
      expect(next, isNotNull);
      expect(next!.id, 'b');
    });

    test('SkipPatient updates appointment status to skipped', () async {
      final repo = FakeHomeRepository();
      final usecase = SkipPatientUseCase(repo);

      final ap =
          make('s1', 'Dr. K', DateTime(2023, 1, 1), '09:00', status: 'pending');
      repo.byId = ap;

      final skipped = await usecase.call('s1');
      expect(skipped.status, 'skipped');
      expect(repo.updated, isTrue);
    });
  });
}
