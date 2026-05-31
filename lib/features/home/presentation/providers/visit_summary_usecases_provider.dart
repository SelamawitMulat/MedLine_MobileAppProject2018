import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/home/data/providers.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/create_visit_summary.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/delete_visit_summary.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/get_visit_history.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/update_visit_summary.dart';

final getVisitHistoryUseCaseProvider =
  Provider<GetVisitHistoryUseCase>((ref) =>
    GetVisitHistoryUseCase(ref.watch(visitSummaryRepositoryProvider)));

final createVisitSummaryUseCaseProvider = Provider<CreateVisitSummaryUseCase>(
  (ref) => CreateVisitSummaryUseCase(ref.watch(visitSummaryRepositoryProvider)));

final updateVisitSummaryUseCaseProvider = Provider<UpdateVisitSummaryUseCase>(
  (ref) => UpdateVisitSummaryUseCase(ref.watch(visitSummaryRepositoryProvider)));

final deleteVisitSummaryUseCaseProvider = Provider<DeleteVisitSummaryUseCase>(
  (ref) => DeleteVisitSummaryUseCase(ref.watch(visitSummaryRepositoryProvider)));
