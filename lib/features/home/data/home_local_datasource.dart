import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/database/tables.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeLocalDataSource {
  final AppDatabase db = AppDatabase();

  Future<void> cacheAppointments(List<Appointment> apps) async {
    await db.clearTable(Tables.appointmentsCache);
    for (var a in apps) {
      await db.insert(Tables.appointmentsCache, a.toLocalJson());
    }
  }

  Future<List<Appointment>> getCachedAppointments() async {
    final data = await db.getAll(Tables.appointmentsCache);
    return data.map((json) => Appointment.fromJson(json)).toList();
  }

  Future<void> removeAppointment(String id) async {
    await db.delete(Tables.appointmentsCache, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addAppointment(Appointment app) async {
    await db.insert(Tables.appointmentsCache, app.toLocalJson());
  }
}