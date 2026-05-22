import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  final String role;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'name': name,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [id, username, password, role, name, email];
}