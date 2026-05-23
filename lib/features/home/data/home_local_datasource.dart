import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/database/tables.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeLocalDataSource {
  final AppDatabase db;

  HomeLocalDataSource(this.db);

  /// Caches the list by updating existing records or adding new ones
  Future<void> cacheAppointments(List<Appointment> apps) async {
    // REMOVED: await db.delete(Tables.appointmentsCache);
    // We no longer clear the table, so existing data persists.

    for (var app in apps) {
      // .insert in your AppDatabase already uses ConflictAlgorithm.replace,
      // which handles updating the record if the ID is the same.
      await db.insert(Tables.appointmentsCache, app.toLocalJson());
    }
  }

  /// Fetches all appointments from the local SQLite database
  Future<List<Appointment>> getCachedAppointments() async {
    final List<Map<String, dynamic>> data =
        await db.getAll(Tables.appointmentsCache);
    return data.map((json) => Appointment.fromJson(json)).toList();
  }

  /// Removes a single appointment by ID
  Future<void> removeAppointment(String id) async {
    await db.delete(Tables.appointmentsCache, where: 'id = ?', whereArgs: [id]);
  }

  /// Adds or updates a single appointment
  Future<void> addAppointment(Appointment app) async {
    await db.insert(Tables.appointmentsCache, app.toLocalJson());
  }
}
