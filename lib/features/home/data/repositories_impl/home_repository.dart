import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/data/datasources/home_remote_datasource.dart';
import 'package:med_line/features/home/data/datasources/home_local_datasource.dart';
import 'package:med_line/core/logging/app_logger.dart';

class HomeRepository implements IHomeRepository {
  final HomeRemoteDataSource remote;
  final HomeLocalDataSource local;

  HomeRepository({required this.remote, required this.local});

  @override
  Future<List<Appointment>> fetchAllAppointments() async {
    final cached = await local.getCachedAppointments();
    try {
      final remoteData = await remote.fetchAllAppointments();
      AppLogger.info('Fetched ${remoteData.length} appointments from remote',
          name: 'HomeRepository');
      await local.cacheAppointments(remoteData);
      return remoteData;
    } catch (e, st) {
      AppLogger.error('Failed to fetch remote appointments: $e',
          name: 'HomeRepository');
      AppLogger.error(st.toString(), name: 'HomeRepository');
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
      AppLogger.info('Created appointment ${createdApp.id}',
          name: 'HomeRepository');
      await local.addAppointment(createdApp);
      return createdApp;
    } catch (e, st) {
      AppLogger.error('Failed to create appointment: $e',
          name: 'HomeRepository');
      AppLogger.error(st.toString(), name: 'HomeRepository');
      rethrow;
    }
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      final updatedRemote = await remote.updateAppointment(appointment);
      AppLogger.info('Updated appointment ${updatedRemote.id}',
          name: 'HomeRepository');
      await local.updateAppointment(updatedRemote);
      return updatedRemote;
    } catch (e, st) {
      AppLogger.error('Failed to update appointment ${appointment.id}: $e',
          name: 'HomeRepository');
      AppLogger.error(st.toString(), name: 'HomeRepository');
      rethrow;
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    try {
      await remote.deleteAppointment(id);
      AppLogger.info('Deleted appointment $id', name: 'HomeRepository');
      await local.removeAppointment(id);
    } catch (e, st) {
      AppLogger.error('Failed to delete appointment $id: $e',
          name: 'HomeRepository');
      AppLogger.error(st.toString(), name: 'HomeRepository');
      rethrow;
    }
  }

  @override
  Future<Appointment?> getCachedAppointmentById(String id) async {
    return await local.getCachedAppointmentById(id);
  }
}
