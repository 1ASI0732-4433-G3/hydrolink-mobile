import 'package:flutter/material.dart';
import 'package:grow_easy_mobile_application/screens/initial_screen.dart';
import 'package:grow_easy_mobile_application/screens/login_screen.dart';
import 'package:grow_easy_mobile_application/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrowEasy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
      initialRoute: '/initial', // Ruta inicial
      routes: {
        '/initial': (context) => const InitialScreen(),
        '/login': (context) => const LoginScreen(), // Ruta para la pantalla de login
        '/profile': (context) => const ProfileScreen(), // Ruta para la pantalla de perfil
      },
    );
  }
}
