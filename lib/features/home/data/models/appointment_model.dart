import 'package:med_line/features/home/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required String id,
    required String patientName,
    required DateTime date,
    required String timeSlot,
    String doctorName = 'Dr. Selam Mulat',
    String status = 'pending',
    String? patientId,
    String? doctorId,
    String reason = '',
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
          reason: reason,
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
      reason: appointment.reason,
      isCheckedIn: appointment.isCheckedIn,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final dateValue =
        json['date'] ?? json['dateTime'] ?? json['appointment_date'];
    final parsedDate = dateValue != null
        ? DateTime.parse(dateValue.toString())
        : DateTime.now();

    final rawIsCheckedIn =
        json['isCheckedIn'] ?? json['checked_in'] ?? json['is_checked_in'];
    final rawStatus = json['status'] ?? json['statusText'];
    final mappedStatus = Appointment.normalizeStatus(
      rawStatus,
      isCheckedIn: Appointment.parseCheckedInFlag(rawIsCheckedIn),
    );
    final isCheckedIn =
        Appointment.effectiveCheckedIn(rawIsCheckedIn, mappedStatus);

    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ??
          json['patient_id']?.toString() ??
          '',
      date: parsedDate,
      timeSlot: json['timeSlot']?.toString() ?? json['time']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? 'Dr. Selam Mulat',
      status: mappedStatus,
      patientId:
          json['patientId']?.toString() ?? json['patient_id']?.toString(),
      doctorId: json['doctorId']?.toString() ?? json['doctor_id']?.toString(),
      reason: json['reason']?.toString() ?? '',
      isCheckedIn: isCheckedIn,
    );
  }

  @override
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
      'reason': reason,
      'isCheckedIn': isCheckedIn ? 1 : 0,
    };
  }

  @override
  Map<String, dynamic> toApiJson() {
    return {
      if (patientId != null) 'patientId': patientId,
      'appointmentDate': date.toIso8601String().split('T')[0],
      'appointmentTime': timeSlot,
      'reason': reason,
    };
  }
}
