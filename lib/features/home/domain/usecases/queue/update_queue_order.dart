import 'package:med_line/features/home/domain/entities/appointment.dart';

class UpdateQueueOrderUseCase {
  List<Appointment> call(List<Appointment> appointments, String doctorName) {
    final filtered = appointments
        .where((app) =>
            _normalizeDoctorName(app.doctorName) ==
                _normalizeDoctorName(doctorName) &&
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

    filtered.sort((a, b) => combine(a).compareTo(combine(b)));
    return filtered;
  }

  String _normalizeDoctorName(String name) {
    return name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }
}
