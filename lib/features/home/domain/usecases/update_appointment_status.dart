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

    final updated = current.copyWith(status: newStatus);
    return await repository.updateAppointment(updated);
  }
}
