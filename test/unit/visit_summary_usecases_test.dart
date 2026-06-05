import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';
import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/create_visit_summary.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/get_visit_history.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/update_visit_summary.dart';
import 'package:med_line/features/home/domain/usecases/visit_summary/delete_visit_summary.dart';

class FakeVisitSummaryRepository implements IVisitSummaryRepository {
  final List<VisitSummary> storage = [];
  bool deleted = false;

  @override
  Future<VisitSummary> addVisitSummary(VisitSummary summary) async {
    storage.add(summary);
    return summary;
  }

  @override
  Future<void> deleteVisitSummary(String appointmentId) async {
    storage.removeWhere((s) => s.appointmentId == appointmentId);
    deleted = true;
  }

  @override
  Future<List<VisitSummary>> getVisitSummaries() async {
    return storage;
  }

  @override
  Future<VisitSummary> updateVisitSummary(VisitSummary summary) async {
    final index =
        storage.indexWhere((s) => s.appointmentId == summary.appointmentId);
    if (index >= 0) storage[index] = summary;
    return summary;
  }
}

void main() {
  group('VisitSummary usecases', () {
    test('create and fetch visit summaries', () async {
      final repo = FakeVisitSummaryRepository();
      final create = CreateVisitSummaryUseCase(repo);
      final get = GetVisitHistoryUseCase(repo);

      final summary = VisitSummary(
        appointmentId: 'a1',
        patientId: 'p1',
        doctorId: 'd1',
        patientName: 'Patient',
        doctorName: 'Doctor',
        date: DateTime(2023, 1, 1),
        timeSlot: '09:00',
        diagnosis: 'ok',
        prescription: 'meds',
      );

      final created = await create.call(summary);
      expect(created.appointmentId, 'a1');

      final list = await get.call();
      expect(list.length, 1);
      expect(list.first.appointmentId, 'a1');
    });

    test('update visit summary', () async {
      final repo = FakeVisitSummaryRepository();
      final update = UpdateVisitSummaryUseCase(repo);

      final summary = VisitSummary(
        appointmentId: 'a2',
        patientId: 'p2',
        doctorId: 'd2',
        patientName: 'P2',
        doctorName: 'D2',
        date: DateTime(2023, 2, 2),
        timeSlot: '10:00',
        diagnosis: 'old',
        prescription: 'none',
      );

      await repo.addVisitSummary(summary);

      final updated = VisitSummary(
        appointmentId: 'a2',
        patientId: 'p2',
        doctorId: 'd2',
        patientName: 'P2',
        doctorName: 'D2',
        date: DateTime(2023, 2, 2),
        timeSlot: '10:00',
        diagnosis: 'new',
        prescription: 'med',
      );

      final result = await update.call(updated);
      expect(result.diagnosis, 'new');

      final list = await repo.getVisitSummaries();
      expect(list.first.diagnosis, 'new');
    });

    test('delete visit summary', () async {
      final repo = FakeVisitSummaryRepository();
      final delete = DeleteVisitSummaryUseCase(repo);

      final summary = VisitSummary(
        appointmentId: 'a3',
        patientId: 'p3',
        doctorId: 'd3',
        patientName: 'P3',
        doctorName: 'D3',
        date: DateTime(2023, 3, 3),
        timeSlot: '11:00',
        diagnosis: 'x',
        prescription: 'y',
      );

      await repo.addVisitSummary(summary);
      await delete.call('a3');
      expect(repo.deleted, isTrue);
      final list = await repo.getVisitSummaries();
      expect(list.isEmpty, isTrue);
    });
  });
}
