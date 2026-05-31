import 'package:med_line/features/home/domain/entities/visit_summary.dart';
import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';

class CreateVisitSummaryUseCase {
  final IVisitSummaryRepository repository;

  CreateVisitSummaryUseCase(this.repository);

  Future<VisitSummary> call(VisitSummary summary) async {
    return await repository.addVisitSummary(summary);
  }
}
