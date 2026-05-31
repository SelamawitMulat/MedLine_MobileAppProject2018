import 'package:med_line/features/home/domain/entities/appointment.dart';

class UpdateQueueOrderUseCase {
  List<Appointment> call(List<Appointment> appointments, String doctorName) {
    final filtered = appointments
        .where((app) =>
            _normalizeDoctorName(app.doctorName) == _normalizeDoctorName(doctorName) &&
            app.status != 'Cancelled')
        .toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  String _normalizeDoctorName(String name) {
    return name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }
}
