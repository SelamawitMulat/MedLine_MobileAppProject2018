import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String role;
  final String name;
  final String email;
  final String passwordHash;

  const User({
    required this.id,
    required this.username,
    required this.role,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static bool _looksLikeSha256(String value) {
    final sha256RegExp = RegExp(r'^[a-f0-9]{64}$');
    return sha256RegExp.hasMatch(value);
  }

  factory User.fromJson(Map<String, dynamic> json) {
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

    return User(
      id: json['id']?.toString() ?? '',
      username: username,
      role: json['role']?.toString().trim() ?? '',
      name: json['name']?.toString().trim() ?? '',
      email: email,
      passwordHash: passwordHash,
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
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        role,
        name,
        email,
        passwordHash,
      ];
}
