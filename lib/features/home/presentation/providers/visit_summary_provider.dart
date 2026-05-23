import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/data/visit_summary_local_datasource.dart';
import 'package:med_line/features/home/domain/visit_summary_model.dart';

final visitSummaryLocalDataSourceProvider =
    Provider<VisitSummaryLocalDataSource>((ref) {
  return VisitSummaryLocalDataSource(ref.watch(appDatabaseProvider));
});

class VisitSummaryNotifier extends StateNotifier<List<VisitSummary>> {
  final VisitSummaryLocalDataSource _local;

  VisitSummaryNotifier(this._local) : super([]) {
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    state = await _local.getVisitSummaries();
  }

  Future<void> addVisitSummary(VisitSummary summary) async {
    await _local.addVisitSummary(summary);
    state = [
      for (final existing in state)
        if (existing.appointmentId != summary.appointmentId) existing,
      summary,
    ];
  }
}

final visitSummaryProvider =
    StateNotifierProvider<VisitSummaryNotifier, List<VisitSummary>>(
  (ref) => VisitSummaryNotifier(ref.watch(visitSummaryLocalDataSourceProvider)),
);
