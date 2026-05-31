import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/database/tables.dart';
import 'package:med_line/features/home/data/models/visit_summary_model.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';

class VisitSummaryLocalDataSource {
  final AppDatabase db;

  VisitSummaryLocalDataSource(this.db);

  Future<void> addVisitSummary(VisitSummary summary) async {
    await db.insert(Tables.visitSummariesCache, summary.toJson());
  }

  Future<void> updateVisitSummary(VisitSummary summary) async {
    await db.delete(
      Tables.visitSummariesCache,
      where: 'appointmentId = ?',
      whereArgs: [summary.appointmentId],
    );
    await db.insert(Tables.visitSummariesCache, summary.toJson());
  }

  Future<void> deleteVisitSummary(String appointmentId) async {
    await db.delete(
      Tables.visitSummariesCache,
      where: 'appointmentId = ?',
      whereArgs: [appointmentId],
    );
  }

  Future<List<VisitSummary>> getVisitSummaries() async {
    final data = await db.getAll(Tables.visitSummariesCache);
    return data.map((json) => VisitSummaryModel.fromJson(json)).toList();
  }
}
