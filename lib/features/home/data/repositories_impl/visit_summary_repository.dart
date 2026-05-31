import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';
import 'package:med_line/features/home/data/datasources/visit_summary_local_datasource.dart';
import 'package:med_line/features/home/data/datasources/visit_summary_remote_datasource.dart';

class VisitSummaryRepository implements IVisitSummaryRepository {
  final VisitSummaryLocalDataSource local;
  final VisitSummaryRemoteDataSource remote;

  VisitSummaryRepository({required this.local, required this.remote});

  @override
  Future<List<VisitSummary>> getVisitSummaries() async {
    final cached = await local.getVisitSummaries();
    if (cached.isNotEmpty) {
      return cached;
    }

    try {
      final remoteSummaries = await remote.fetchAllVisitSummaries();
      for (final summary in remoteSummaries) {
        await local.addVisitSummary(summary);
      }
      return remoteSummaries;
    } catch (_) {
      return cached;
    }
  }

  @override
  Future<VisitSummary> addVisitSummary(VisitSummary summary) async {
    await local.addVisitSummary(summary);
    try {
      return await remote.createVisitSummary(summary);
    } catch (_) {
      return summary;
    }
  }

  @override
  Future<VisitSummary> updateVisitSummary(VisitSummary summary) async {
    await local.updateVisitSummary(summary);
    try {
      return await remote.updateVisitSummary(summary);
    } catch (_) {
      return summary;
    }
  }

  @override
  Future<void> deleteVisitSummary(String appointmentId) async {
    await local.deleteVisitSummary(appointmentId);
    try {
      await remote.deleteVisitSummary(appointmentId);
    } catch (_) {
      // ignore remote failures and keep local cache consistent
    }
  }
}
