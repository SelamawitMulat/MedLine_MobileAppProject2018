import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/home/data/home_repository.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';

final appointmentProvider = AsyncNotifierProvider<AppointmentNotifier, List<Appointment>>(() => AppointmentNotifier());

class AppointmentNotifier extends AsyncNotifier<List<Appointment>> {
  @override
  FutureOr<List<Appointment>> build() async {
    return await ref.read(homeRepositoryProvider).getAppointments();
  }

  Future<void> addAppointment(Appointment app) async {
    final previousState = state;
    state = const AsyncValue.loading();
    try {
      final newApp = await ref.read(homeRepositoryProvider).addAppointment(app);
      state = AsyncValue.data([...(previousState.value ?? []), newApp]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Appointment? getNextAppointment(String userId) {
    final all = state.value ?? [];
    final now = DateTime.now();
    final userApps = all.where((a) => a.patientId == userId).toList();
    final upcoming = userApps.where((a) => a.dateTime.isAfter(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  int getQueuePosition(String id) {
    final all = List<Appointment>.from(state.value ?? [])
      ..sort((a, b) => a.bookingTimestamp.compareTo(b.bookingTimestamp));
    return all.indexWhere((a) => a.id == id) + 1;
  }
}