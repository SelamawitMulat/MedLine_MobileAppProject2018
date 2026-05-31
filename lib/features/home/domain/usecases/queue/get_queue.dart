import 'package:med_line/features/home/domain/entities/appointment.dart';

class GetQueueUseCase {
  List<Appointment> call(List<Appointment> appointments, String doctorName) {
    final normalizedDoctor = _normalizeDoctorName(doctorName);
    final queueAppointments = appointments
        .where((app) =>
            _normalizeDoctorName(app.doctorName) == normalizedDoctor &&
            app.status != 'Cancelled' &&
            app.status != 'Completed')
        .toList();

    queueAppointments.sort((a, b) => a.date.compareTo(b.date));
    return queueAppointments;
  }

  String _normalizeDoctorName(String name) {
    return name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }
}
