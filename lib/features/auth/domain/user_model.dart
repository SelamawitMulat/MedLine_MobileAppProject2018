class User {
  final String id;
  final String username;
  final String password;
  final String role;
  final String? name;
  final String? email;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      name: json['name'],
      email: json['email'],
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

  User copyWith({
    String? id,
    String? username,
    String? password,
    String? role,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
