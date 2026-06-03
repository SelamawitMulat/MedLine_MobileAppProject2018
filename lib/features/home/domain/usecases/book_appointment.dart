import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';

class BookAppointmentUseCase {
  final IHomeRepository repository;
  final IAuthRepository authRepository;

  BookAppointmentUseCase({
    required this.repository,
    required this.authRepository,
  });

  Future<Appointment> call({
    required DateTime date,
    required String timeSlot,
    required String reason,
    required List<Appointment> existingAppointments,
  }) async {
    final currentUser = await authRepository.getCurrentUser();
    if (currentUser == null) {
      throw Exception('User must be logged in to book an appointment');
    }

    if (_isInPast(date, timeSlot)) {
      throw Exception('Cannot book appointments in the past');
    }

    if (_hasConflict(date, timeSlot,
        existingAppointments: existingAppointments)) {
      throw Exception('Appointment conflict detected');
    }

    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName:
          currentUser.name.isNotEmpty ? currentUser.name : currentUser.username,
      doctorName: 'Dr. Selam Mulat',
      date: date,
      timeSlot: timeSlot,
      status: 'Upcoming',
      patientId: currentUser.id,
      doctorId: '1',
      reason: reason,
    );

    return await repository.createAppointment(appointment);
  }

  bool _hasConflict(
    DateTime date,
    String timeSlot, {
    required List<Appointment> existingAppointments,
    String? ignoreId,
  }) {
    return existingAppointments.any((appointment) {
      if (appointment.status.toLowerCase() == 'cancelled') return false;
      if (ignoreId != null && appointment.id == ignoreId) return false;
      return appointment.date.year == date.year &&
          appointment.date.month == date.month &&
          appointment.date.day == date.day &&
          appointment.timeSlot == timeSlot;
    });
  }

  bool _isInPast(DateTime date, String timeSlot) {
    final selected = _combineDateAndTime(date, timeSlot);
    return selected.isBefore(DateTime.now());
  }

  DateTime _combineDateAndTime(DateTime date, String timeSlot) {
    final parts = timeSlot.split(':').map(int.parse).toList();
    if (parts.length != 2) return date;
    return DateTime(date.year, date.month, date.day, parts[0], parts[1]);
  }
}
