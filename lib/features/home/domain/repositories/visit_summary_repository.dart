import '../entities/visit_summary.dart';

abstract class IVisitSummaryRepository {
  Future<List<VisitSummary>> getVisitSummaries();

  Future<VisitSummary> addVisitSummary(VisitSummary summary);

  Future<VisitSummary> updateVisitSummary(VisitSummary summary);

  Future<void> deleteVisitSummary(String appointmentId);
}
