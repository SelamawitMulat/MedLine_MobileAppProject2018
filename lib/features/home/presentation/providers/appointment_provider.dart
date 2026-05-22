import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/appointment_model.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  // CORRECTED: Set the initial state to a completely empty list
  // This removes the mock data so ghost appointments don't show up on startup
  AppointmentNotifier() : super([]);

  // Method to add a new appointment to the list
  void bookAppointment(Appointment appointment) {
    state = [...state, appointment];
  }

  // Reschedules an existing appointment with a new date/time slot
  void rescheduleAppointment(String id, DateTime newDate, String newTimeSlot) {
    state = [
      for (final app in state)
        if (app.id == id)
          Appointment(
            id: app.id,
            patientName: app.patientName,
            doctorName: app.doctorName,
            date: newDate,
            timeSlot: newTimeSlot,
            status: app.status,
          )
        else
          app,
    ];
  }

  // Status updates without relying on copyWith
  void updateAppointmentStatus(String id, String newStatus) {
    state = [
      for (final app in state)
        if (app.id == id)
          Appointment(
            id: app.id,
            patientName: app.patientName,
            doctorName: app.doctorName,
            date: app.date,
            timeSlot: app.timeSlot,
            status: newStatus, // Injects the updated status cleanly
          )
        else
          app,
    ];
  }
}

// The global provider your UI screens will read and watch
final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>((ref) {
  return AppointmentNotifier();
});
