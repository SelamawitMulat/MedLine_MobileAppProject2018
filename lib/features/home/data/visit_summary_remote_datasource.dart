import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/home/domain/visit_summary_model.dart';

class VisitSummaryRemoteDataSource {
  final ApiClient apiClient;
  final String _url = ApiEndpoints.visitSummaries;

  VisitSummaryRemoteDataSource(this.apiClient);

  Future<List<VisitSummary>> fetchAllVisitSummaries() async {
    final List<dynamic> response = await apiClient.get(_url);
    return response
        .map((json) => VisitSummary.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<VisitSummary> createVisitSummary(VisitSummary summary) async {
    final response = await apiClient.post(_url, data: summary.toJson());
    return VisitSummary.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteVisitSummary(String appointmentId) async {
    await apiClient.delete('$_url/$appointmentId');
  }
}
