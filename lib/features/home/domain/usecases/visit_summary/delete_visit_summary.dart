import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';

class DeleteVisitSummaryUseCase {
  final IVisitSummaryRepository repository;

  DeleteVisitSummaryUseCase(this.repository);

  Future<void> call(String appointmentId) async {
    await repository.deleteVisitSummary(appointmentId);
  }
}
