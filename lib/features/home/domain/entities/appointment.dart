import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String patientName;
  final DateTime date;
  final String timeSlot;
  final String doctorName;
  final String status;
  final String? patientId;
  final String? doctorId;
  final String reason;
  final bool isCheckedIn;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.date,
    required this.timeSlot,
    this.doctorName = "Dr. Selam Mulat",
    this.status = "Upcoming",
    this.patientId,
    this.doctorId,
    this.reason = "",
    this.isCheckedIn = false,
  });

  @override
  List<Object?> get props => [
        id,
        patientName,
        date,
        timeSlot,
        doctorName,
        status,
        patientId,
        doctorId,
        reason,
        isCheckedIn,
      ];

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final dateValue =
        json['date'] ?? json['dateTime'] ?? json['appointment_date'];
    final parsedDate = dateValue != null
        ? DateTime.parse(dateValue.toString())
        : DateTime.now();

    final rawIsCheckedIn =
        json['isCheckedIn'] ?? json['checked_in'] ?? json['is_checked_in'];
    final isCheckedIn =
        rawIsCheckedIn == true || rawIsCheckedIn == 1 || rawIsCheckedIn == '1';
    
    final status = json['status'] ?? "Upcoming";
    final mappedStatus = status.toLowerCase() == 'cancelled' ? 'Cancelled' : 'Upcoming';

    return Appointment(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName'] ?? json['patient_id']?.toString() ?? '',
      date: parsedDate,
      timeSlot: json['timeSlot'] ?? json['time'] ?? '',
      doctorName: json['doctorName'] ?? "Dr. Selam Mulat",
      status: mappedStatus,
      patientId: json['patientId']?.toString() ?? json['patient_id']?.toString(),
      doctorId: json['doctorId']?.toString() ?? json['doctor_id']?.toString(),
      reason: json['reason']?.toString() ?? '',
      isCheckedIn: isCheckedIn,
    );
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'patientName': patientName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'doctorName': doctorName,
      'status': status,
      if (patientId != null) 'patientId': patientId,
      if (doctorId != null) 'doctorId': doctorId,
      'isCheckedIn': isCheckedIn ? 1 : 0,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      if (patientId != null) 'patientId': patientId,
      'appointmentDate': date.toIso8601String().split('T')[0],
      'appointmentTime': timeSlot,
      'reason': reason,
    };
  }

  Appointment copyWith({
    String? id,
    String? patientName,
    DateTime? date,
    String? timeSlot,
    String? doctorName,
    String? status,
    String? patientId,
    String? doctorId,
    String? reason,
    bool? isCheckedIn,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      doctorName: doctorName ?? this.doctorName,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      reason: reason ?? this.reason,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}
