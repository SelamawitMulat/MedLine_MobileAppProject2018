import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';
import 'package:med_line/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromEntity creates model from entity', () {
      const user = User(
        id: 'u1',
        username: 'john',
        role: 'patient',
        name: 'John Doe',
        email: 'john@example.com',
        passwordHash: 'abc123',
      );

      final model = UserModel.fromEntity(user);

      expect(model.id, 'u1');
      expect(model.username, 'john');
      expect(model.name, 'John Doe');
    });

    test('fromJson parses JSON with all fields', () {
      final json = {
        'id': 'u2',
        'username': 'jane',
        'role': 'doctor',
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'passwordHash': 'def456',
        'token': 'token-xyz',
      };

      final model = UserModel.fromJson(json);

      expect(model.id, 'u2');
      expect(model.username, 'jane');
      expect(model.token, 'token-xyz');
    });

    test('fromJson uses email as fallback username', () {
      final json = {
        'id': 'u3',
        'role': 'patient',
        'name': 'Bob',
        'email': 'bob@example.com',
        'passwordHash': 'ghi789',
      };

      final model = UserModel.fromJson(json);

      expect(model.username, 'bob@example.com');
    });

    test('fromJson recognizes SHA256 hash', () {
      final sha256 =
          'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
      final json = {
        'id': 'u4',
        'email': 'alice@example.com',
        'passwordHash': sha256,
      };

      final model = UserModel.fromJson(json);

      expect(model.passwordHash, sha256);
    });

    test('fromJson uses password when passwordHash is not a valid hash', () {
      final json = {
        'id': 'u5',
        'email': 'charlie@example.com',
        'passwordHash': 'not-sha256',
        'password': 'plain',
      };

      final model = UserModel.fromJson(json);

      expect(model.passwordHash, 'plain');
    });

    test('fromCredentials creates user with hashed password', () {
      final model = UserModel.fromCredentials(
        username: 'testuser',
        role: 'patient',
        name: 'Test User',
        email: 'test@example.com',
        password: 'testpass123',
      );

      expect(model.username, 'testuser');
      expect(model.role, 'patient');
      expect(model.passwordHash.length, 64);
      expect(model.id, isNotEmpty);
    });

    test('toJson serializes all fields', () {
      const model = UserModel(
        id: 'u6',
        username: 'david',
        role: 'doctor',
        name: 'David Johnson',
        email: 'david@example.com',
        passwordHash: 'xyz789',
        token: 'token-abc',
      );

      final json = model.toJson();

      expect(json['id'], 'u6');
      expect(json['username'], 'david');
      expect(json['token'], 'token-abc');
    });

    test('User.hashPassword generates valid SHA256', () {
      final hash = User.hashPassword('password123');

      expect(hash.length, 64);
      expect(hash, matches(RegExp(r'^[a-f0-9]{64}$')));
    });

    test('Same password produces same hash', () {
      final hash1 = User.hashPassword('mypassword');
      final hash2 = User.hashPassword('mypassword');

      expect(hash1, hash2);
    });

    test('Different passwords produce different hashes', () {
      final hash1 = User.hashPassword('password1');
      final hash2 = User.hashPassword('password2');

      expect(hash1, isNot(hash2));
    });
  });

  group('User entity', () {
    test('User creates with defaults', () {
      const user = User(
        id: 'u7',
        username: 'user7',
        role: 'patient',
        name: 'User7',
        email: 'user7@example.com',
        passwordHash: 'hash',
      );

      expect(user.token, isNull);
    });

    test('User with token stores it', () {
      const user = User(
        id: 'u8',
        username: 'user8',
        role: 'patient',
        name: 'User8',
        email: 'user8@example.com',
        passwordHash: 'hash',
        token: 'mytoken',
      );

      expect(user.token, 'mytoken');
    });
  });
}
