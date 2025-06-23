class UserModel {
  final String fullName;
  final String username;
  final List<String> roles;

  UserModel({
    required this.fullName,
    required this.username,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? 'N/A',
      username: json['username'] ?? 'N/A',
      roles: List<String>.from(json['role'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'role': roles,
    };
  }

  String get roleAsString => roles.join(', ');
}
