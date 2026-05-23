import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeRemoteDataSource {
  final ApiClient _api;
  final String _url = ApiEndpoints.appointments;

  HomeRemoteDataSource(this._api);

  Future<List<Appointment>> fetchAllAppointments() async {
    final List<dynamic> data = await _api.get(_url);
    return data
        .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final responseData = await _api.post(_url, data: appointment.toApiJson());
    return Appointment.fromJson(responseData as Map<String, dynamic>);
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    final responseData = await _api.put('$_url/${appointment.id}',
        data: appointment.toApiJson());
    return Appointment.fromJson(responseData as Map<String, dynamic>);
  }

  Future<void> deleteAppointment(String id) async {
    await _api.delete('$_url/$id');
  }
}
