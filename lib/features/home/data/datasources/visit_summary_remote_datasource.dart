import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/home/data/models/visit_summary_model.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';

class VisitSummaryRemoteDataSource {
  final ApiClient apiClient;
  final String _url = ApiEndpoints.visitSummaries;

  VisitSummaryRemoteDataSource(this.apiClient);

  Future<List<VisitSummary>> fetchAllVisitSummaries() async {
    final List<dynamic> response = await apiClient.get(_url);
    return response
        .map((json) => VisitSummaryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<VisitSummary> createVisitSummary(VisitSummary summary) async {
    final response = await apiClient.post(_url, data: summary.toJson());
    return VisitSummaryModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VisitSummary> updateVisitSummary(VisitSummary summary) async {
    final response = await apiClient.put('$_url/${summary.appointmentId}',
        data: summary.toJson());
    return VisitSummaryModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteVisitSummary(String appointmentId) async {
    await apiClient.delete('$_url/$appointmentId');
  }
}
