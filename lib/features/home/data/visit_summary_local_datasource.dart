import 'package:med_line/core/database/app_database.dart';
import 'package:med_line/core/database/tables.dart';
import 'package:med_line/features/home/domain/visit_summary_model.dart';

class VisitSummaryLocalDataSource {
  final AppDatabase db;

  VisitSummaryLocalDataSource(this.db);

  Future<void> addVisitSummary(VisitSummary summary) async {
    await db.insert(Tables.visitSummariesCache, summary.toJson());
  }

  Future<List<VisitSummary>> getVisitSummaries() async {
    final data = await db.getAll(Tables.visitSummariesCache);
    return data.map((json) => VisitSummary.fromJson(json)).toList();
  }
}
