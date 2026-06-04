import 'package:med_line/features/home/domain/entities/appointment.dart';

class GetQueueUseCase {
  List<Appointment> call(List<Appointment> appointments, String doctorName) {
    final normalizedDoctor = _normalizeDoctorName(doctorName);
    final queueAppointments = appointments
        .where((app) =>
            _normalizeDoctorName(app.doctorName) == normalizedDoctor &&
            app.status != 'cancelled')
        .toList();

    DateTime combine(Appointment ap) {
      try {
        final parts = ap.timeSlot.split(':').map(int.parse).toList();
        return DateTime(
            ap.date.year, ap.date.month, ap.date.day, parts[0], parts[1]);
      } catch (_) {
        return ap.date;
      }
    }

    queueAppointments.sort((a, b) => combine(a).compareTo(combine(b)));
    return queueAppointments;
  }

  String _normalizeDoctorName(String name) {
    return name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }
}
