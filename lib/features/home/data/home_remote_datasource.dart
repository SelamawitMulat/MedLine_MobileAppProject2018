import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

class HomeRemoteDataSource {
  final ApiClient _api = ApiClient();
  final String _url = ApiEndpoints.appointments;

  Future<List<Appointment>> fetchAllAppointments() async {
    final List<dynamic> data = await _api.get(_url);
    return data.map((json) => Appointment.fromJson(json)).toList();
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final Map<String, dynamic> data = await _api.post(_url, data: appointment.toApiJson());
    return Appointment.fromJson(data);
  }

  Future<void> deleteAppointment(String id) async {
    await _api.delete("$_url/$id");
  }
}