import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> profileData = {
    'fullName': '',
    'username': '',
    'role': '',
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    const String profileEndpoint = 'https://inherent-steffi-hydrolink-531626a5.koyeb.app/api/v1/users/';
    try {
      // Obtener JWT y username desde SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('jwt');
      final username = prefs.getString('username');

      if (jwt == null || username == null) {
        showError('No se encontró el token JWT o el nombre de usuario.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Construir la URL para el endpoint
      final url = Uri.parse('$profileEndpoint$username');
      print('URL: $url');

      // Realizar la petición GET
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map) {
          // Convertir el campo "role" de lista a string
          final role = (data['role'] as List<dynamic>).join(', ');
          setState(() {
            profileData = {
              'fullName': data['fullName'] ?? 'N/A',
              'username': data['username'] ?? 'N/A',
              'role': role, // Convertido a string
            };
            isLoading = false;
          });
        } else {
          // Si no es un mapa, mostrar un error
          showError('Respuesta inesperada del servidor.');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        showError('Error al obtener los datos del perfil: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showError('Error al conectar con el servidor: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logOut() async {
    try {
      // Obtener SharedPreferences y eliminar el JWT
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt');
      await prefs.remove('username');

      // Redirigir al login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      showError('Error al cerrar sesión: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nombre completo:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              profileData['fullName'] ?? 'N/A',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nombre de usuario:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              profileData['username'] ?? 'N/A',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: logOut,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text('Cerrar Sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
