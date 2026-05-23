import 'package:med_line/features/home/data/home_remote_datasource.dart';
import 'package:med_line/features/home/data/home_local_datasource.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeRepository {
  final HomeRemoteDataSource remote;
  final HomeLocalDataSource local;

  HomeRepository({required this.remote, required this.local});

  /// Fetches from network, caches on success, falls back to cache on error.
  Future<List<Appointment>> getAppointments() async {
    try {
      final remoteData = await remote.fetchAllAppointments();
      // Only clear and replace cache if we actually got data from the server
      await local.cacheAppointments(remoteData);
      return remoteData;
    } catch (e) {
      // Return local cache even if it's empty (no internet + no history)
      return await local.getCachedAppointments();
    }
  }

  /// Creates an appointment via API and persists it locally.
  Future<Appointment> addAppointment(Appointment app) async {
    final createdApp = await remote.createAppointment(app);
    // This ensures your local database is updated immediately
    await local.addAppointment(createdApp);
    return createdApp;
  }

  /// Deletes an appointment from both API and local cache.
  Future<void> cancelAppointment(String id) async {
    await remote.deleteAppointment(id);
    await local.removeAppointment(id);
  }
}
