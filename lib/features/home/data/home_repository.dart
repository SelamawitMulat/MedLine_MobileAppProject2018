import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/home/data/home_remote_datasource.dart';
import 'package:med_line/features/home/data/home_local_datasource.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

final homeRepositoryProvider = Provider((ref) => HomeRepository());

class HomeRepository {
  final HomeRemoteDataSource remote = HomeRemoteDataSource();
  final HomeLocalDataSource local = HomeLocalDataSource();

  Future<List<Appointment>> getAppointments() async {
    try {
      final remoteData = await remote.fetchAllAppointments();
      await local.cacheAppointments(remoteData);
      return remoteData;
    } catch (_) {
      return await local.getCachedAppointments();
    }
  }

  Future<Appointment> addAppointment(Appointment app) async {
    final createdApp = await remote.createAppointment(app);
    await local.addAppointment(createdApp);
    return createdApp;
  }

  Future<void> cancelAppointment(String id) async {
    await remote.deleteAppointment(id);
    await local.removeAppointment(id);
  }
}