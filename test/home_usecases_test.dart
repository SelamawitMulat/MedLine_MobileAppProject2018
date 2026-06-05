import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/usecases/book_appointment.dart';

class FakeHomeRepository implements IHomeRepository {
  Appointment? createdAppointment;
  bool createAppointmentCalled = false;

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    createAppointmentCalled = true;
    createdAppointment = appointment.copyWith(id: 'created-id');
    return createdAppointment!;
  }

  @override
  Future<List<Appointment>> fetchAllAppointments() {
    throw UnimplementedError();
  }

  @override
  Future<List<Appointment>> getCachedAppointments() {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheAppointments(List<Appointment> apps) {
    throw UnimplementedError();
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAppointment(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Appointment?> getCachedAppointmentById(String id) {
    throw UnimplementedError();
  }
}

class FakeAuthRepository implements IAuthRepository {
  User? currentUser;

  @override
  Future<List<User>> fetchUsers() async => [];

  @override
  Future<List<User>> getCachedUsers() async => [];

  @override
  Future<void> cacheUsers(List<User> users) async {}

  @override
  Future<User?> getCurrentUser() async => currentUser;

  @override
  Future<void> saveCurrentUser(User user) async {
    currentUser = user;
  }

  @override
  Future<void> clearAuth() async {
    currentUser = null;
  }

  @override
  Future<void> deleteUser(String id) async {}

  @override
  Future<User> createRemoteUser(User user) async => throw UnimplementedError();

  @override
  Future<User?> login(String email, String password) async => throw UnimplementedError();

  @override
  Future<User> signup({required String name, required String email, required String password}) async => throw UnimplementedError();

  @override
  Future<User?> fetchCurrentUser(String token) async => throw UnimplementedError();
}

void main() {
  group('BookAppointmentUseCase', () {
    test('books appointment when user is logged in and time slot is free', () async {
      final homeRepository = FakeHomeRepository();
      final authRepository = FakeAuthRepository();
      authRepository.currentUser = const User(
        id: 'user-1',
        username: 'patient1',
        role: 'patient',
        name: 'Patient One',
        email: 'patient1@example.com',
        passwordHash: 'hash',
      );
      final useCase = BookAppointmentUseCase(
        repository: homeRepository,
        authRepository: authRepository,
      );

      final result = await useCase.call(
        date: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '09:00',
        reason: 'General checkup',
        existingAppointments: const [],
      );

      expect(result.id, 'created-id');
      expect(result.patientId, 'user-1');
      expect(result.patientName, 'Patient One');
      expect(result.status, 'pending');
      expect(homeRepository.createAppointmentCalled, isTrue);
    });

    test('throws when no user is logged in', () async {
      final homeRepository = FakeHomeRepository();
      final authRepository = FakeAuthRepository();
      final useCase = BookAppointmentUseCase(
        repository: homeRepository,
        authRepository: authRepository,
      );

      expect(
        () => useCase.call(
          date: DateTime.now().add(const Duration(days: 1)),
          timeSlot: '10:00',
          reason: 'Checkup',
          existingAppointments: const [],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when selected appointment is in the past', () async {
      final homeRepository = FakeHomeRepository();
      final authRepository = FakeAuthRepository();
      authRepository.currentUser = const User(
        id: 'user-2',
        username: 'patient2',
        role: 'patient',
        name: 'Patient Two',
        email: 'patient2@example.com',
        passwordHash: 'hash',
      );
      final useCase = BookAppointmentUseCase(
        repository: homeRepository,
        authRepository: authRepository,
      );

      expect(
        () => useCase.call(
          date: DateTime.now().subtract(const Duration(days: 1)),
          timeSlot: '09:00',
          reason: 'Follow-up',
          existingAppointments: const [],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when there is a conflict with an existing appointment', () async {
      final homeRepository = FakeHomeRepository();
      final authRepository = FakeAuthRepository();
      authRepository.currentUser = const User(
        id: 'user-3',
        username: 'patient3',
        role: 'patient',
        name: 'Patient Three',
        email: 'patient3@example.com',
        passwordHash: 'hash',
      );
      final useCase = BookAppointmentUseCase(
        repository: homeRepository,
        authRepository: authRepository,
      );

      final existingAppointments = [
        Appointment(
          id: 'existing-1',
          patientName: 'Other Patient',
          date: DateTime.now().add(const Duration(days: 2)),
          timeSlot: '14:00',
          status: 'pending',
          patientId: 'other',
          doctorId: '1',
          reason: 'Consultation',
        ),
      ];

      expect(
        () => useCase.call(
          date: DateTime.now().add(const Duration(days: 2)),
          timeSlot: '14:00',
          reason: 'Follow-up',
          existingAppointments: existingAppointments,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
