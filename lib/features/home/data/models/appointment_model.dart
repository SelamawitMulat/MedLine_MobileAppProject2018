import 'package:med_line/features/home/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required String id,
    required String patientName,
    required DateTime date,
    required String timeSlot,
    String doctorName = 'Dr. Selam Mulat',
    String status = 'Upcoming',
    String? patientId,
    String? doctorId,
    bool isCheckedIn = false,
  }) : super(
          id: id,
          patientName: patientName,
          date: date,
          timeSlot: timeSlot,
          doctorName: doctorName,
          status: status,
          patientId: patientId,
          doctorId: doctorId,
          isCheckedIn: isCheckedIn,
        );

  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      patientName: appointment.patientName,
      date: appointment.date,
      timeSlot: appointment.timeSlot,
      doctorName: appointment.doctorName,
      status: appointment.status,
      patientId: appointment.patientId,
      doctorId: appointment.doctorId,
      isCheckedIn: appointment.isCheckedIn,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final dateValue = json['date'] ?? json['dateTime'] ?? json['appointment_date'];
    final parsedDate = dateValue != null
        ? DateTime.parse(dateValue.toString())
        : DateTime.now();

    final rawIsCheckedIn =
        json['isCheckedIn'] ?? json['checked_in'] ?? json['is_checked_in'];
    final isCheckedIn =
        rawIsCheckedIn == true || rawIsCheckedIn == 1 || rawIsCheckedIn == '1';

    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? json['patientId']?.toString() ?? '',
      date: parsedDate,
      timeSlot: json['timeSlot']?.toString() ?? json['appointment_time']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? json['doctorId']?.toString() ?? 'Dr. Selam Mulat',
      status: json['status']?.toString() ?? 'Upcoming',
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
}
