import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeRemoteDataSource {
  final ApiClient _api;
  final String _url = ApiEndpoints.appointments;

  HomeRemoteDataSource(this._api);

  /// Fetches all appointments from the API
  Future<List<Appointment>> fetchAllAppointments() async {
    final List<dynamic> data = await _api.get(_url);
    return data
        .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Creates a new appointment and returns the created object
  Future<Appointment> createAppointment(Appointment appointment) async {
    // We cast the response to Map<String, dynamic> to satisfy the type checker
    final responseData = await _api.post(_url, data: appointment.toApiJson());

    // Ensure we are passing a Map, not just dynamic
    return Appointment.fromJson(responseData as Map<String, dynamic>);
  }

  /// Deletes an appointment from the server
  Future<void> deleteAppointment(String id) async {
    await _api.delete("$_url/$id");
  }
}
