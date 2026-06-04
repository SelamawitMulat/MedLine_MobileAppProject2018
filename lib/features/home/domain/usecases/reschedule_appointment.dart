import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';

class RescheduleAppointmentUseCase {
  final IHomeRepository repository;

  RescheduleAppointmentUseCase(this.repository);

  Future<Appointment> call(
    Appointment appointment,
    DateTime newDate,
    String newTimeSlot,
    List<Appointment> existingAppointments,
  ) async {
    if (_isInPast(newDate, newTimeSlot)) {
      throw Exception('Cannot reschedule into the past');
    }

    if (_hasConflict(newDate, newTimeSlot,
        existingAppointments: existingAppointments, ignoreId: appointment.id)) {
      throw Exception('Appointment conflict detected');
    }

    final updated = appointment.copyWith(
      date: newDate,
      timeSlot: newTimeSlot,
      status: 'pending',
    );

    return await repository.updateAppointment(updated);
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
