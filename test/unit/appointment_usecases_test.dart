import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/domain/repositories/auth_repository.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/usecases/book_appointment.dart';

class FakeHomeRepository implements IHomeRepository {
  Appointment? created;

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    created = appointment.copyWith(id: 'created-id');
    return created!;
  }

  @override
  Future<List<Appointment>> fetchAllAppointments() async => [];

  @override
  Future<List<Appointment>> getCachedAppointments() async => [];

  @override
  Future<void> cacheAppointments(List<Appointment> apps) async {}

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async =>
      appointment;

  @override
  Future<void> deleteAppointment(String id) async {}

  @override
  Future<Appointment?> getCachedAppointmentById(String id) async => null;
}

class FakeAuthRepository implements IAuthRepository {
  User? currentUser;

  @override
  Future<void> cacheUsers(List<User> users) async {}

  @override
  Future<void> clearAuth() async {}

  @override
  Future<User> createRemoteUser(User user) async => user;

  @override
  Future<List<User>> fetchUsers() async => [];

  @override
  Future<User?> fetchCurrentUser(String token) async => null;

  @override
  Future<List<User>> getCachedUsers() async => [];

  @override
  Future<User?> getCurrentUser() async => currentUser;

  @override
  Future<void> saveCurrentUser(User user) async {}

  @override
  Future<User?> login(String email, String password) async => null;

  @override
  Future<User> signup(
          {required String name,
          required String email,
          required String password}) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteUser(String id) async {}
}

void main() {
  group('BookAppointmentUseCase', () {
    test('throws when no user logged in', () async {
      final repo = FakeHomeRepository();
      final auth = FakeAuthRepository();
      final usecase =
          BookAppointmentUseCase(repository: repo, authRepository: auth);

      expect(
          () => usecase.call(
              date: DateTime.now().add(Duration(days: 1)),
              timeSlot: '09:00',
              reason: 'r',
              existingAppointments: []),
          throwsA(isA<Exception>()));
    });

    test('throws when booking in the past', () async {
      final repo = FakeHomeRepository();
      final auth = FakeAuthRepository();
      auth.currentUser = const User(
          id: 'u1',
          username: 'u',
          role: 'patient',
          name: 'U',
          email: 'u@example.com',
          passwordHash: 'h');
      final usecase =
          BookAppointmentUseCase(repository: repo, authRepository: auth);

      expect(
          () => usecase.call(
              date: DateTime.now().subtract(Duration(days: 1)),
              timeSlot: '09:00',
              reason: 'r',
              existingAppointments: []),
          throwsA(isA<Exception>()));
    });

    test('throws on conflict with existing appointment', () async {
      final repo = FakeHomeRepository();
      final auth = FakeAuthRepository();
      auth.currentUser = const User(
          id: 'u1',
          username: 'u',
          role: 'patient',
          name: 'U',
          email: 'u@example.com',
          passwordHash: 'h');
      final usecase =
          BookAppointmentUseCase(repository: repo, authRepository: auth);

      final existing = Appointment(
          id: 'e1',
          patientName: 'p',
          date: DateTime(2025, 1, 1),
          timeSlot: '09:00',
          doctorName: 'Dr. Selam',
          status: 'pending');

      expect(
          () => usecase.call(
              date: DateTime(2025, 1, 1),
              timeSlot: '09:00',
              reason: 'r',
              existingAppointments: [existing]),
          throwsA(isA<Exception>()));
    });

    test('creates appointment when valid', () async {
      final repo = FakeHomeRepository();
      final auth = FakeAuthRepository();
      auth.currentUser = const User(
          id: 'u1',
          username: 'u',
          role: 'patient',
          name: 'U',
          email: 'u@example.com',
          passwordHash: 'h');
      final usecase =
          BookAppointmentUseCase(repository: repo, authRepository: auth);

      final date = DateTime.now().add(Duration(days: 1));
      final result = await usecase.call(
          date: date, timeSlot: '09:00', reason: 'r', existingAppointments: []);

      expect(result.id, 'created-id');
      expect(result.patientId, 'u1');
      expect(repo.created, isNotNull);
    });
  });
}
