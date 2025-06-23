// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';

class AuthService {
  final String baseUrl = 'https://inherent-steffi-hydrolink-531626a5.koyeb.app/api/v1';

  Future<String?> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/auth/log-in');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(jsonResponse);

      if (loginResponse.status) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', loginResponse.jwt);
        await prefs.setString('username', request.username);
        return null;
      } else {
        return loginResponse.message;
      }
    } else {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['message'] ?? 'Error: ${response.statusCode}';
    }
  }

  Future<String?> signup(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/auth/sign-up');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // Success
    } else {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['message'] ?? 'Error: ${response.statusCode}';
    }
  }
}