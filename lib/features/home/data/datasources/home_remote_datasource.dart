import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/home/data/models/appointment_model.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';

class HomeRemoteDataSource {
  final ApiClient _api;
  final String _url = ApiEndpoints.appointments;

  HomeRemoteDataSource(this._api);

  Future<List<Appointment>> fetchAllAppointments() async {
    final List<dynamic> data = await _api.get(_url);
    return data
        .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final responseData = await _api.post(_url, data: appointment.toApiJson());
    return AppointmentModel.fromJson(responseData as Map<String, dynamic>);
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    final responseData = await _api.put('$_url/${appointment.id}',
        data: appointment.toApiJson());
    return AppointmentModel.fromJson(responseData as Map<String, dynamic>);
  }

  Future<void> deleteAppointment(String id) async {
    await _api.delete('$_url/$id');
  }
}
