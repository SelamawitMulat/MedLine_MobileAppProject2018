import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/core/providers.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/auth/data/providers.dart';
import 'package:med_line/features/home/data/providers.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/usecases/book_appointment.dart';
import 'package:med_line/features/home/domain/usecases/cancel_appointment.dart';
import 'package:med_line/features/home/domain/usecases/reschedule_appointment.dart';
import 'package:med_line/features/home/domain/usecases/update_appointment_status.dart';

// Data providers (home & auth repositories) are provided by data layer

final bookAppointmentUseCaseProvider = Provider<BookAppointmentUseCase>((ref) {
  return BookAppointmentUseCase(
    repository: ref.watch(homeRepositoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});

final rescheduleAppointmentUseCaseProvider = Provider<RescheduleAppointmentUseCase>((ref) {
  return RescheduleAppointmentUseCase(ref.watch(homeRepositoryProvider));
});

final cancelAppointmentUseCaseProvider = Provider<CancelAppointmentUseCase>((ref) {
  return CancelAppointmentUseCase(ref.watch(homeRepositoryProvider));
});

final updateAppointmentStatusUseCaseProvider = Provider<UpdateAppointmentStatusUseCase>((ref) {
  return UpdateAppointmentStatusUseCase(ref.watch(homeRepositoryProvider));
});

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  final Ref _ref;
  final IHomeRepository _repository;

  AppointmentNotifier(this._ref, this._repository) : super([]) {
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    state = await _repository.fetchAllAppointments();
  }

  Future<void> bookAppointment({
    required String doctorName,
    required String doctorId,
    required DateTime date,
    required String timeSlot,
  }) async {
    final created = await _ref.read(bookAppointmentUseCaseProvider).call(
          doctorName: doctorName,
          doctorId: doctorId,
          date: date,
          timeSlot: timeSlot,
          existingAppointments: state,
        );
    state = [...state, created];
  }

  Future<void> rescheduleAppointment(
      String id, DateTime newDate, String newTimeSlot) async {
    final current = state.firstWhere((app) => app.id == id);
    final updated = await _ref
        .read(rescheduleAppointmentUseCaseProvider)
        .call(current, newDate, newTimeSlot, state);

    state = [
      for (final app in state)
        if (app.id == id) updated else app,
    ];
  }

  Future<void> updateAppointmentStatus(String id, String newStatus) async {
    final updated = await _ref
        .read(updateAppointmentStatusUseCaseProvider)
        .call(id, newStatus);
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
