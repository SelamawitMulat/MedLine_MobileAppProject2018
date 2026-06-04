import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';

class CallNextPatientUseCase {
  final IHomeRepository repository;

  CallNextPatientUseCase(this.repository);

  Future<Appointment?> call(
      List<Appointment> appointments, String doctorName) async {
    final upcoming = appointments
        .where((app) =>
            _normalizeDoctorName(app.doctorName) ==
                _normalizeDoctorName(doctorName) &&
            app.status == 'pending')
        .toList();

    if (upcoming.isEmpty) {
      return null;
    }

    upcoming.sort((a, b) => a.date.compareTo(b.date));
    // Return the next pending appointment; do not change status here to avoid
    // introducing non-standard statuses. Caller can decide how to proceed.
    return upcoming.first;
  }

  String _normalizeDoctorName(String name) {
    return name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }
}
