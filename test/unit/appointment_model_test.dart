import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/data/models/appointment_model.dart';

void main() {
  group('AppointmentModel', () {
    test('fromEntity creates model from entity', () {
      final entity = Appointment(
        id: 'a1',
        patientName: 'Patient',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        doctorName: 'Dr. Smith',
        status: 'pending',
      );

      final model = AppointmentModel.fromEntity(entity);

      expect(model.id, 'a1');
      expect(model.patientName, 'Patient');
      expect(model.doctorName, 'Dr. Smith');
    });

    test('fromJson parses JSON correctly', () {
      final json = {
        'id': 'a2',
        'patientName': 'John',
        'date': DateTime(2025, 2, 15).toIso8601String(),
        'timeSlot': '14:00',
        'doctorName': 'Dr. Jane',
        'status': 'pending',
      };

      final model = AppointmentModel.fromJson(json);

      expect(model.id, 'a2');
      expect(model.patientName, 'John');
      expect(model.timeSlot, '14:00');
    });

    test('fromJson handles alternative field names', () {
      final json = {
        'id': 'a3',
        'patientName': 'Mike',
        'appointment_date': DateTime(2025, 3, 20).toIso8601String(),
        'time': '10:30',
        'status': 'pending',
      };

      final model = AppointmentModel.fromJson(json);

      expect(model.id, 'a3');
      expect(model.patientName, 'Mike');
      expect(model.timeSlot, '10:30');
    });

    test('fromJson parses status normalization', () {
      final json = {
        'id': 'a4',
        'patientName': 'Lisa',
        'date': DateTime(2025, 1, 1).toIso8601String(),
        'timeSlot': '11:00',
        'status': 'check-in',
      };

      final model = AppointmentModel.fromJson(json);

      expect(model.status, 'checked_in');
    });

    test('fromJson handles checked_in flag', () {
      final json = {
        'id': 'a5',
        'patientName': 'Bob',
        'date': DateTime(2025, 1, 1).toIso8601String(),
        'timeSlot': '09:00',
        'status': 'pending',
        'isCheckedIn': 1,
      };

      final model = AppointmentModel.fromJson(json);

      expect(model.isCheckedIn, isTrue);
      expect(model.status, 'checked_in');
    });

    test('toLocalJson serializes correctly', () {
      final model = AppointmentModel(
        id: 'a6',
        patientName: 'Sarah',
        date: DateTime(2025, 1, 10),
        timeSlot: '15:00',
        doctorName: 'Dr. Brown',
        status: 'pending',
        patientId: 'p1',
        isCheckedIn: false,
      );

      final json = model.toLocalJson();

      expect(json['id'], 'a6');
      expect(json['patientName'], 'Sarah');
      expect(json['isCheckedIn'], 0);
    });

    test('toApiJson formats for API correctly', () {
      final model = AppointmentModel(
        id: 'a7',
        patientName: 'Tom',
        date: DateTime(2025, 1, 15),
        timeSlot: '16:00',
        reason: 'Checkup',
        patientId: 'p2',
      );

      final json = model.toApiJson();

      expect(json['appointmentDate'], '2025-01-15');
      expect(json['appointmentTime'], '16:00');
      expect(json['reason'], 'Checkup');
    });
  });

  group('Appointment entity methods', () {
    test('appointmentDateTime parses correctly', () {
      final ap = Appointment(
        id: 'a8',
        patientName: 'Anna',
        date: DateTime(2025, 1, 20),
        timeSlot: '12:30',
      );

      final dt = ap.appointmentDateTime;

      expect(dt, isNotNull);
      expect(dt!.hour, 12);
      expect(dt.minute, 30);
    });

    test('isMissed returns true for overdue pending', () {
      final ap = Appointment(
        id: 'a9',
        patientName: 'Leo',
        date: DateTime(2020, 1, 1),
        timeSlot: '09:00',
        status: 'pending',
      );

      expect(ap.isMissed, isTrue);
    });

    test('isMissed returns false for cancelled', () {
      final ap = Appointment(
        id: 'a10',
        patientName: 'Eva',
        date: DateTime(2020, 1, 1),
        timeSlot: '09:00',
        status: 'cancelled',
      );

      expect(ap.isMissed, isFalse);
    });

    test('displayStatus returns human-readable status', () {
      expect(
        Appointment(
          id: 'a11',
          patientName: 'P',
          date: DateTime(2025, 1, 1),
          timeSlot: '09:00',
          status: 'completed',
        ).displayStatus,
        'Completed',
      );

      expect(
        Appointment(
          id: 'a12',
          patientName: 'P',
          date: DateTime(2030, 1, 1),
          timeSlot: '09:00',
          status: 'pending',
        ).displayStatus,
        'Pending',
      );
    });

    test('copyWith creates new instance', () {
      final original = Appointment(
        id: 'a13',
        patientName: 'Original',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        status: 'pending',
      );

      final copied = original.copyWith(status: 'completed');

      expect(copied.status, 'completed');
      expect(copied.patientName, 'Original');
      expect(copied.id, 'a13');
    });
  });
}
