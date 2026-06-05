import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';

void main() {
  group('VisitSummary entity', () {
    test('creates with required fields', () {
      final summary = VisitSummary(
        appointmentId: 'app1',
        patientId: 'p1',
        doctorId: 'd1',
        patientName: 'Patient',
        doctorName: 'Doctor',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        diagnosis: 'Flu',
        prescription: 'Rest',
      );

      expect(summary.appointmentId, 'app1');
      expect(summary.patientId, 'p1');
      expect(summary.diagnosis, 'Flu');
    });

    test('fromJson parses correctly', () {
      final json = {
        'appointmentId': 'app2',
        'patientId': 'p2',
        'doctorId': 'd2',
        'patientName': 'John',
        'doctorName': 'Dr. Jane',
        'date': DateTime(2025, 2, 15).toIso8601String(),
        'timeSlot': '14:00',
        'diagnosis': 'Diabetes',
        'prescription': 'Insulin',
      };

      final summary = VisitSummary.fromJson(json);

      expect(summary.appointmentId, 'app2');
      expect(summary.patientName, 'John');
      expect(summary.prescription, 'Insulin');
    });

    test('fromJson handles missing date', () {
      final json = {
        'appointmentId': 'app3',
        'patientId': 'p3',
        'doctorId': 'd3',
        'patientName': 'Bob',
        'doctorName': 'Dr. Smith',
        'timeSlot': '10:00',
        'diagnosis': 'Cold',
        'prescription': 'Cough syrup',
      };

      final summary = VisitSummary.fromJson(json);

      expect(summary.date, isNotNull);
    });

    test('fromJson handles empty/null diagnosis', () {
      final json = {
        'appointmentId': 'app4',
        'patientId': 'p4',
        'doctorId': 'd4',
        'patientName': 'Lisa',
        'doctorName': 'Dr. Brown',
        'date': DateTime(2025, 3, 1).toIso8601String(),
        'timeSlot': '11:00',
      };

      final summary = VisitSummary.fromJson(json);

      expect(summary.diagnosis, '');
      expect(summary.prescription, '');
    });

    test('toJson serializes correctly', () {
      final summary = VisitSummary(
        appointmentId: 'app5',
        patientId: 'p5',
        doctorId: 'd5',
        patientName: 'Sarah',
        doctorName: 'Dr. White',
        date: DateTime(2025, 4, 10),
        timeSlot: '15:00',
        diagnosis: 'Migraine',
        prescription: 'Paracetamol',
      );

      final json = summary.toJson();

      expect(json['appointmentId'], 'app5');
      expect(json['diagnosis'], 'Migraine');
      expect(json['timeSlot'], '15:00');
    });

    test('same instance returns true', () {
      final s1 = VisitSummary(
        appointmentId: 'a',
        patientId: 'p',
        doctorId: 'd',
        patientName: 'Pat',
        doctorName: 'Doc',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        diagnosis: 'X',
        prescription: 'Y',
      );

      expect(s1, equals(s1));
    });

    test('different instances are not equal', () {
      final s1 = VisitSummary(
        appointmentId: 'a',
        patientId: 'p1',
        doctorId: 'd',
        patientName: 'Pat1',
        doctorName: 'Doc',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        diagnosis: 'X',
        prescription: 'Y',
      );

      final s2 = VisitSummary(
        appointmentId: 'a',
        patientId: 'p1',
        doctorId: 'd',
        patientName: 'Pat1',
        doctorName: 'Doc',
        date: DateTime(2025, 1, 1),
        timeSlot: '09:00',
        diagnosis: 'X',
        prescription: 'Y',
      );

      expect(s1, isNot(equals(s2)));
    });
  });
}
