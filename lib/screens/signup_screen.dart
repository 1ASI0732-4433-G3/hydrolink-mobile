import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _signup() async {
    const String signupEndpoint = 'https://inherent-steffi-hydrolink-531626a5.koyeb.app/api/v1/auth/sign-up';

    // Verificar si las contraseñas coinciden
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Las contraseñas no coinciden');
      return;
    }

    // Construir la solicitud
    final Map<String, dynamic> signupData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
      'role': 'AMATEUR', // Ajustar según sea necesario
    };

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse(signupEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(signupData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registro exitoso, mostrar mensaje y redirigir al login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso. Por favor, inicia sesión.')),
        );

        // Redirigir a la pantalla de inicio de sesión
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        // Manejar errores
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Error: ${response.statusCode}';
        _showError(errorMessage);
      }
    } catch (error) {
      _showError('Error al conectar con el servidor: $error');
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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 60,
                  thickness: 3,
                ),
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                    hintText: 'Ingrese su nombre',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Apellido',
                    hintText: 'Ingrese su apellido',
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirmar Contraseña',
                    hintText: 'Confirme su contraseña',
                  ),
                ),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 60,
                  thickness: 3,
                ),
                RichText(
                  text: TextSpan(
                    text: '¿Ya tienes una cuenta? ',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Inicia sesión aquí',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FilledButton(
                      onPressed: _signup,
                      child: const Text('Registrarse'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
