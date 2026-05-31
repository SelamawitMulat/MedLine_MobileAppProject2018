import 'package:med_line/features/home/domain/entities/visit_summary.dart';

class VisitSummaryModel extends VisitSummary {
  VisitSummaryModel({
    required String appointmentId,
    required String patientId,
    required String doctorId,
    required String patientName,
    required String doctorName,
    required DateTime date,
    required String timeSlot,
    required String diagnosis,
    required String prescription,
  }) : super(
          appointmentId: appointmentId,
          patientId: patientId,
          doctorId: doctorId,
          patientName: patientName,
          doctorName: doctorName,
          date: date,
          timeSlot: timeSlot,
          diagnosis: diagnosis,
          prescription: prescription,
        );

  factory VisitSummaryModel.fromEntity(VisitSummary summary) {
    return VisitSummaryModel(
      appointmentId: summary.appointmentId,
      patientId: summary.patientId,
      doctorId: summary.doctorId,
      patientName: summary.patientName,
      doctorName: summary.doctorName,
      date: summary.date,
      timeSlot: summary.timeSlot,
      diagnosis: summary.diagnosis,
      prescription: summary.prescription,
    );
  }

  factory VisitSummaryModel.fromJson(Map<String, dynamic> json) {
    return VisitSummaryModel(
      appointmentId: json['appointmentId']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.now(),
      timeSlot: json['timeSlot']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      prescription: json['prescription']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'doctorId': doctorId,
      'patientName': patientName,
      'doctorName': doctorName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'diagnosis': diagnosis,
      'prescription': prescription,
    };
  }
}
