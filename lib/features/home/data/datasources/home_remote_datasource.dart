import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/network/api_endpoints.dart';
import 'package:med_line/features/home/data/models/appointment_model.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';

class HomeRemoteDataSource {
  final ApiClient _api;
  final String _url = ApiEndpoints.appointments;

  HomeRemoteDataSource(this._api);

  Future<List<Appointment>> fetchAllAppointments() async {
    try {
      final dynamic data = await _api.get(_url);

      // Handle both single object and array responses
      if (data is List) {
        return data
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data.containsKey('appointments')) {
        final appointments = data['appointments'] as List;
        return appointments
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final responseData = await _api.post(_url, data: appointment.toApiJson());

      // Handle both direct object and {appointment: {...}} response
      final appointmentData =
          responseData is Map && responseData.containsKey('appointment')
              ? responseData['appointment']
              : responseData;

      return AppointmentModel.fromJson(appointmentData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      final updateData = <String, dynamic>{};

      updateData['appointmentDate'] =
          appointment.date.toIso8601String().split('T')[0];
      updateData['appointmentTime'] = appointment.timeSlot;

      // include status and checked_in when relevant (e.g., check-in)
      if (appointment.status.isNotEmpty) {
        updateData['status'] = appointment.status;
      }
      if (appointment.isCheckedIn) {
        updateData['checked_in'] = 1;
      }

      final requestUrl = '$_url/${appointment.id}';
      final responseData = await _api.put(requestUrl, data: updateData);

      // Handle both direct object and {appointment: {...}} response
      final appointmentData =
          responseData is Map && responseData.containsKey('appointment')
              ? responseData['appointment']
              : responseData;

      return AppointmentModel.fromJson(appointmentData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _api.delete('$_url/$id');
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }
}
