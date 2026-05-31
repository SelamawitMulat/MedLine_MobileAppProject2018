import 'package:med_line/features/home/domain/entities/visit_summary.dart';
import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';

class GetVisitHistoryUseCase {
  final IVisitSummaryRepository repository;

  GetVisitHistoryUseCase(this.repository);

  Future<List<VisitSummary>> call() async {
    return await repository.getVisitSummaries();
  }
}
