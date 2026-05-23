import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/data/visit_summary_local_datasource.dart';
import 'package:med_line/features/home/data/visit_summary_remote_datasource.dart';
import 'package:med_line/features/home/data/visit_summary_repository.dart';
import 'package:med_line/features/home/domain/visit_summary_model.dart';

final visitSummaryLocalDataSourceProvider =
    Provider<VisitSummaryLocalDataSource>((ref) {
  return VisitSummaryLocalDataSource(ref.watch(appDatabaseProvider));
});

final visitSummaryRemoteDataSourceProvider =
    Provider<VisitSummaryRemoteDataSource>((ref) {
  return VisitSummaryRemoteDataSource(ref.watch(apiClientProvider));
});

final visitSummaryRepositoryProvider = Provider<VisitSummaryRepository>((ref) {
  return VisitSummaryRepository(
    local: ref.watch(visitSummaryLocalDataSourceProvider),
    remote: ref.watch(visitSummaryRemoteDataSourceProvider),
  );
});

class VisitSummaryNotifier extends StateNotifier<List<VisitSummary>> {
  final VisitSummaryRepository _repository;

  VisitSummaryNotifier(this._repository) : super([]) {
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    state = await _repository.getVisitSummaries();
  }

  Future<void> addVisitSummary(VisitSummary summary) async {
    await _repository.addVisitSummary(summary);
    state = [
      for (final existing in state)
        if (existing.appointmentId != summary.appointmentId) existing,
      summary,
    ];
  }

  Future<void> deleteVisitSummary(String appointmentId) async {
    await _repository.deleteVisitSummary(appointmentId);
    state = state
        .where((summary) => summary.appointmentId != appointmentId)
        .toList();
  }
}

final visitSummaryProvider =
    StateNotifierProvider<VisitSummaryNotifier, List<VisitSummary>>(
  (ref) => VisitSummaryNotifier(ref.watch(visitSummaryRepositoryProvider)),
);
