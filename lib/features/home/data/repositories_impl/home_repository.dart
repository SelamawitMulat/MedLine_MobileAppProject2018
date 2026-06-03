import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/data/datasources/home_remote_datasource.dart';
import 'package:med_line/features/home/data/datasources/home_local_datasource.dart';

class HomeRepository implements IHomeRepository {
  final HomeRemoteDataSource remote;
  final HomeLocalDataSource local;

  HomeRepository({required this.remote, required this.local});

  @override
  Future<List<Appointment>> fetchAllAppointments() async {
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

  @override
  Future<List<Appointment>> getCachedAppointments() async {
    return await local.getCachedAppointments();
  }

  @override
  Future<void> cacheAppointments(List<Appointment> apps) async {
    await local.cacheAppointments(apps);
  }

  @override
  Future<Appointment> createAppointment(Appointment app) async {
    try {
      final createdApp = await remote.createAppointment(app);
      await local.addAppointment(createdApp);
      return createdApp;
    } catch (_) {
      await local.addAppointment(app);
      return app;
    }
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      await remote.updateAppointment(appointment);
    } catch (_) {
      // Remote may be unavailable; keep working locally.
    }
    await local.updateAppointment(appointment);
    return appointment;
  }

  @override
  Future<void> deleteAppointment(String id) async {
    try {
      await remote.deleteAppointment(id);
    } catch (_) {
      // Remote may be unavailable; keep working locally.
    }

    // Update local cache to mark as cancelled
    final appointment = await local.getCachedAppointmentById(id);
    if (appointment != null) {
      final cancelled = appointment.copyWith(status: 'Cancelled');
      await local.updateAppointment(cancelled);
    }
  }

  @override
  Future<Appointment?> getCachedAppointmentById(String id) async {
    return await local.getCachedAppointmentById(id);
  }
}
