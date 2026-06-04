import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';

class UpdateAppointmentStatusUseCase {
  final IHomeRepository repository;

  UpdateAppointmentStatusUseCase(this.repository);

  Future<Appointment> call(String id, String newStatus) async {
    final current = await repository.getCachedAppointmentById(id);
    if (current == null) {
      throw Exception('Appointment not found');
    }

    // Standardize incoming status to canonical values
    final normalized = newStatus.toString().trim().toLowerCase();

    if (normalized == 'checked_in') {
      final updated = current.copyWith(status: 'checked_in', isCheckedIn: true);
      return await repository.updateAppointment(updated);
    }

    if (normalized == 'cancelled') {
      final updated = current.copyWith(status: 'cancelled');
      return await repository.updateAppointment(updated);
    }

    // default: set to pending or pass through
    final updated = current.copyWith(
        status: normalized == 'pending' ? 'pending' : normalized);
    return await repository.updateAppointment(updated);
  }
}
