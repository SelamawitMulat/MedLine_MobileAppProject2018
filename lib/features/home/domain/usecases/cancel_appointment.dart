import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';

class CancelAppointmentUseCase {
  final IHomeRepository repository;

  CancelAppointmentUseCase(this.repository);

  Future<Appointment> call(String id) async {
    final current = await repository.getCachedAppointmentById(id);
    if (current == null) {
      throw Exception('Appointment not found');
    }

    final cancelled = current.copyWith(status: 'cancelled');
    return await repository.updateAppointment(cancelled);
  }
}
