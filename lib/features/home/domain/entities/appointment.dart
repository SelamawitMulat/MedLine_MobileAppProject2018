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

    return Appointment(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName'] ?? json['patientId'] ?? '',
      date: parsedDate,
      timeSlot: json['timeSlot'] ?? json['appointment_time'] ?? '',
      doctorName: json['doctorName'] ?? json['doctorId'] ?? "Dr. Selam Mulat",
      status: json['status'] ?? "Upcoming",
      patientId: json['patientId']?.toString(),
      doctorId: json['doctorId']?.toString(),
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
      'patientName': patientName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'doctorName': doctorName,
      'status': status,
      if (patientId != null) 'patientId': patientId,
      if (doctorId != null) 'doctorId': doctorId,
      'isCheckedIn': isCheckedIn,
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
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}
