import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/data/home_local_datasource.dart';
import 'package:med_line/features/home/data/home_remote_datasource.dart';
import 'package:med_line/features/home/data/home_repository.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSource(ref.watch(apiClientProvider));
});

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSource(ref.watch(appDatabaseProvider));
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
    remote: ref.watch(homeRemoteDataSourceProvider),
    local: ref.watch(homeLocalDataSourceProvider),
  );
});

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  final Ref _ref;
  final HomeRepository _repository;

  AppointmentNotifier(this._ref, this._repository) : super([]) {
    _loadAppointments();
  }

  String _normalizeDoctorName(String name) {
    return name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }

  Future<void> _loadAppointments() async {
    state = await _repository.getAppointments();
  }

  DateTime _combineDateAndTime(DateTime date, String timeSlot) {
    final parts = timeSlot.split(':').map(int.parse).toList();
    if (parts.length != 2) return date;
    return DateTime(date.year, date.month, date.day, parts[0], parts[1]);
  }

  bool _hasConflict(
    DateTime date,
    String timeSlot,
    String doctorName, {
    String? ignoreId,
  }) {
    final norm = _normalizeDoctorName(doctorName);
    return state.any((appointment) {
      if (appointment.status.toLowerCase() == 'cancelled') return false;
      if (ignoreId != null && appointment.id == ignoreId) return false;
      if (_normalizeDoctorName(appointment.doctorName) != norm) return false;
      return appointment.date.year == date.year &&
          appointment.date.month == date.month &&
          appointment.date.day == date.day &&
          appointment.timeSlot == timeSlot;
    });
  }

  bool _isInPast(DateTime date, String timeSlot) {
    final selected = _combineDateAndTime(date, timeSlot);
    return selected.isBefore(DateTime.now());
  }

  Future<void> bookAppointment({
    required String doctorName,
    required DateTime date,
    required String timeSlot,
  }) async {
    final currentUser = _ref.read(authProvider).value;
    if (currentUser == null) {
      throw Exception('User must be logged in to book an appointment');
    }

    if (_isInPast(date, timeSlot)) {
      throw Exception('Cannot book appointments in the past');
    }

    if (_hasConflict(date, timeSlot, doctorName)) {
      throw Exception('Appointment conflict detected');
    }

    final normalizedForSave = doctorName
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim();
    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName:
          currentUser.name.isNotEmpty ? currentUser.name : currentUser.username,
      doctorName: normalizedForSave,
      date: date,
      timeSlot: timeSlot,
      status: 'Upcoming',
      patientId: currentUser.id,
      doctorId: 'default-doctor',
    );

    final created = await _repository.addAppointment(appointment);
    state = [...state, created];
  }

  Future<void> rescheduleAppointment(
      String id, DateTime newDate, String newTimeSlot) async {
    if (_isInPast(newDate, newTimeSlot)) {
      throw Exception('Cannot reschedule into the past');
    }

    final current = state.firstWhere((app) => app.id == id);
    if (_hasConflict(newDate, newTimeSlot, current.doctorName, ignoreId: id)) {
      throw Exception('Appointment conflict detected');
    }

    final updated = await _repository.rescheduleAppointment(
      current,
      newDate,
      newTimeSlot,
    );

    state = [
      for (final app in state)
        if (app.id == id) updated else app,
    ];
  }

  Future<void> updateAppointmentStatus(String id, String newStatus) async {
    final updated = await _repository.updateAppointmentStatus(id, newStatus);
    state = [
      for (final app in state)
        if (app.id == id) updated else app,
    ];
  }
}

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>((ref) {
  return AppointmentNotifier(ref, ref.watch(homeRepositoryProvider));
});
