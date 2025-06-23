import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grow_easy_mobile_application/screens/initial_screen.dart';
import 'package:grow_easy_mobile_application/screens/login_screen.dart';
import 'package:grow_easy_mobile_application/screens/profile_screen.dart';
import 'package:grow_easy_mobile_application/providers/loading_provider.dart';
import 'package:grow_easy_mobile_application/widgets/loader_overlay.dart'; // <-- asegúrate de importar esto

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoadingProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HidroLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
      initialRoute: '/initial',
      routes: {
        '/initial': (context) => const LoaderOverlay(child: InitialScreen()),
        '/login': (context) => const LoaderOverlay(child: LoginScreen()),
        '/profile': (context) => const LoaderOverlay(child: ProfileScreen()),
      },
    );
  }
}
