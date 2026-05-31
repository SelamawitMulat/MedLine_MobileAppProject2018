import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/home/data/providers.dart';
import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';

// repository provider is provided by data layer in features/home/data/providers.dart

class VisitSummaryNotifier extends StateNotifier<List<VisitSummary>> {
  final IVisitSummaryRepository _repository;

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
