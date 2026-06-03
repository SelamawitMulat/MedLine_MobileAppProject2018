import '../entities/appointment.dart';

abstract class IHomeRepository {
  Future<List<Appointment>> fetchAllAppointments();

  Future<List<Appointment>> getCachedAppointments();

  Future<void> cacheAppointments(List<Appointment> apps);

  Future<Appointment> createAppointment(Appointment appointment);

  Future<Appointment> updateAppointment(Appointment appointment);

  Future<void> deleteAppointment(String id);

  Future<Appointment?> getCachedAppointmentById(String id);
}
