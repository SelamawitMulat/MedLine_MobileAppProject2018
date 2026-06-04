import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';

class SkipPatientUseCase {
  final IHomeRepository repository;

  SkipPatientUseCase(this.repository);

  Future<Appointment> call(String appointmentId) async {
    final appointment =
        await repository.getCachedAppointmentById(appointmentId);
    if (appointment == null) {
      throw Exception('Appointment not found');
    }
    // Set status to 'skipped' to keep appointment visible with lower priority
    final updated = appointment.copyWith(status: 'skipped');
    return await repository.updateAppointment(updated);
  }
}
