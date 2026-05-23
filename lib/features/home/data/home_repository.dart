import 'package:med_line/features/home/data/home_remote_datasource.dart';
import 'package:med_line/features/home/data/home_local_datasource.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeRepository {
  final HomeRemoteDataSource remote;
  final HomeLocalDataSource local;

  HomeRepository({required this.remote, required this.local});

  Future<List<Appointment>> getAppointments() async {
    final cached = await local.getCachedAppointments();
    if (cached.isNotEmpty) {
      return cached;
    }

    try {
      final remoteData = await remote.fetchAllAppointments();
      await local.cacheAppointments(remoteData);
      return remoteData;
    } catch (_) {
      return cached;
    }
  }

  Future<Appointment> addAppointment(Appointment app) async {
    try {
      final createdApp = await remote.createAppointment(app);
      await local.addAppointment(createdApp);
      return createdApp;
    } catch (_) {
      await local.addAppointment(app);
      return app;
    }
  }

  Future<Appointment> rescheduleAppointment(
      Appointment appointment, DateTime newDate, String newTimeSlot) async {
    final updated = appointment.copyWith(
      date: newDate,
      timeSlot: newTimeSlot,
      status: 'Upcoming',
    );
    try {
      await remote.updateAppointment(updated);
    } catch (_) {
      // Remote may be unavailable; keep working locally.
    }
    await local.updateAppointment(updated);
    return updated;
  }

  Future<Appointment> updateAppointmentStatus(String id, String status) async {
    final current = await local.getCachedAppointmentById(id);
    if (current == null) {
      throw Exception('Appointment not found');
    }
    final updated = current.copyWith(status: status);
    try {
      await remote.updateAppointment(updated);
    } catch (_) {
      // API may not exist; use local cache.
    }
    await local.updateAppointment(updated);
    return updated;
  }

  Future<void> cancelAppointment(String id) async {
    await updateAppointmentStatus(id, 'Cancelled');
  }
}
