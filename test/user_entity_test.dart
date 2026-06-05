import 'package:flutter_test/flutter_test.dart';
import 'package:med_line/features/auth/domain/entities/user.dart';

void main() {
  group('User entity', () {
    test('hashPassword returns a 64-character hex string', () {
      final hash = User.hashPassword('password123');

      expect(hash, hasLength(64));
      expect(hash, matches(RegExp(r'^[a-f0-9]{64}$')));
    });

    test('fromJson uses raw password when raw password hash is missing', () {
      final json = {
        'id': '9',
        'name': 'Test User',
        'email': 'test@example.com',
        'password': 'secret',
      };

      final user = User.fromJson(json);

      expect(user.id, '9');
      expect(user.username, 'test@example.com');
      expect(user.email, 'test@example.com');
      expect(user.passwordHash, 'secret');
    });

    test('fromJson preserves valid sha256 passwordHash and uses email as fallback username', () {
      final sha256hash = User.hashPassword('password');
      final json = {
        'id': '10',
        'email': 'fallback@example.com',
        'passwordHash': sha256hash,
      };

      final user = User.fromJson(json);

      expect(user.username, 'fallback@example.com');
      expect(user.passwordHash, sha256hash);
    });

    test('toJson includes token when present', () {
      final user = const User(
        id: '11',
        username: 'u11',
        role: 'patient',
        name: 'User Eleven',
        email: 'u11@example.com',
        passwordHash: 'hash',
        token: 'token-123',
      );

      final json = user.toJson();

      expect(json['id'], '11');
      expect(json['token'], 'token-123');
      expect(json['email'], 'u11@example.com');
    });
  });
}
