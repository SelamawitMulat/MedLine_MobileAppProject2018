import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String patientName;
  final DateTime date;
  final String timeSlot;
  final String doctorName;
  final String status;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.date,
    required this.timeSlot,
    this.doctorName = "Dr. Selam Mulat",
    this.status = "Upcoming",
  });

  @override
  List<Object?> get props =>
      [id, patientName, date, timeSlot, doctorName, status];

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName'] ?? json['patientId'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      timeSlot: json['timeSlot'] ?? '',
      doctorName: json['doctorName'] ?? "Dr. Selam Mulat",
      status: json['status'] ?? "Upcoming",
    );
  }

  Map<String, dynamic> toLocalJson() => {
        'id': id,
        'patientName': patientName,
        'date': date.toIso8601String(),
        'timeSlot': timeSlot,
        'doctorName': doctorName,
        'status': status,
      };

  // ADD THIS METHOD BELOW:
  Map<String, dynamic> toApiJson() => {
        'patientName': patientName,
        'date': date.toIso8601String(),
        'timeSlot': timeSlot,
        'doctorName': doctorName,
        'status': status,
      };
}
