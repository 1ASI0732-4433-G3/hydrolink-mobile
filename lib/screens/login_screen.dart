import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grow_easy_mobile_application/screens/main_screen.dart';
import 'package:grow_easy_mobile_application/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_request.dart';
import '../model/login_response.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final url = Uri.parse('https://groweasy.azurewebsites.net/api/v1/auth/log-in');
    final loginRequest = LoginRequest(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);

        if (loginResponse.status) {
          // Guardar el JWT y el nombre de usuario localmente usando SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', loginResponse.jwt);
          await prefs.setString('username', _usernameController.text);

          // Navegar a MainScreen si el login es exitoso
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const MainScreen();
              },
            ),
          );
        } else {
          _showError(loginResponse.message);
        }
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Error: ${response.statusCode}';
        _showError(errorMessage);
      }
    } catch (error) {
      _showError('Error: No se pudo conectar al servidor');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.account_circle_outlined,
                  size: 90,
                ),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                    endIndent: 20, indent: 20, height: 60, thickness: 3),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre de usuario',
                    hintText: 'Ingrese su nombre de usuario',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña',
                  ),
                ),
                const Divider(
                    endIndent: 20, indent: 20, height: 60, thickness: 3),
                RichText(
                  text: TextSpan(
                    text: '¿Aún no tienes una cuenta? ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Regístrate aquí!',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return SignupScreen();
                                },
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
