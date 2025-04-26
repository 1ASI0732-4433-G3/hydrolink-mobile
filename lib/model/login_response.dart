class LoginResponse {
  final String username;
  final String message;
  final bool status;
  final String jwt;

  LoginResponse({
    required this.username,
    required this.message,
    required this.status,
    required this.jwt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      username: json['username'],
      message: json['message'],
      status: json['status'],
      jwt: json['jwt'],
    );
  }
}
