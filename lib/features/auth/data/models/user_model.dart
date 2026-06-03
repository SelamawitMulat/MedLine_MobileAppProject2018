import 'package:med_line/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String username,
    required String role,
    required String name,
    required String email,
    required String passwordHash,
    String? token,
  }) : super(
          id: id,
          username: username,
          role: role,
          name: name,
          email: email,
          passwordHash: passwordHash,
          token: token,
        );

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      role: user.role,
      name: user.name,
      email: user.email,
      passwordHash: user.passwordHash,
      token: user.token,
    );
  }

  static bool _looksLikeSha256(String value) {
    final sha256RegExp = RegExp(r'^[a-f0-9]{64}$');
    return sha256RegExp.hasMatch(value);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawPasswordHash = json['passwordHash']?.toString().trim();
    final rawPassword = json['password']?.toString().trim();
    final email = json['email']?.toString().trim() ?? '';
    final usernameValue = json['username']?.toString().trim();
    final username = (usernameValue != null && usernameValue.isNotEmpty)
        ? usernameValue
        : email;

    final passwordHash = (rawPasswordHash != null &&
            rawPasswordHash.isNotEmpty &&
            _looksLikeSha256(rawPasswordHash))
        ? rawPasswordHash
        : rawPassword ?? rawPasswordHash ?? '';

    return UserModel(
      id: json['id']?.toString() ?? '',
      username: username,
      role: json['role']?.toString().trim() ?? '',
      name: json['name']?.toString().trim() ?? '',
      email: email,
      passwordHash: passwordHash,
      token: json['token']?.toString().trim(),
    );
  }

  factory UserModel.fromCredentials({
    required String username,
    required String role,
    required String name,
    required String email,
    required String password,
  }) {
    return UserModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      username: username,
      role: role,
      name: name,
      email: email,
      passwordHash: User.hashPassword(password),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'token': token,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'token': token,
    };
  }
}
