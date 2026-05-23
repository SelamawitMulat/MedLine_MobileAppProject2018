import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/database/tables.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeLocalDataSource {
  final AppDatabase db;

  HomeLocalDataSource(this.db);

  Future<void> cacheAppointments(List<Appointment> apps) async {
    for (var app in apps) {
      await db.insert(Tables.appointmentsCache, app.toLocalJson());
    }
  }

  Future<List<Appointment>> getCachedAppointments() async {
    final List<Map<String, dynamic>> data =
        await db.getAll(Tables.appointmentsCache);
    return data.map((json) => Appointment.fromJson(json)).toList();
  }

  Future<Appointment?> getCachedAppointmentById(String id) async {
    final json = await db
        .getSingle(Tables.appointmentsCache, where: 'id = ?', whereArgs: [id]);
    return json != null ? Appointment.fromJson(json) : null;
  }

  Future<void> addAppointment(Appointment app) async {
    await db.insert(Tables.appointmentsCache, app.toLocalJson());
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await db.insert(Tables.appointmentsCache, appointment.toLocalJson());
  }

  Future<void> removeAppointment(String id) async {
    await db.delete(Tables.appointmentsCache, where: 'id = ?', whereArgs: [id]);
  }
}
