import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  final String notificationsEndpoint =
      'https://groweasy.azurewebsites.net/api/notifications';

  Future<List<Map<String, String>>> fetchNotifications() async {
    try {
      // Llamada al endpoint de notificaciones
      final response = await http.get(Uri.parse(notificationsEndpoint));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          return data.map((notification) {
            return {
              'title': 'Notificación: ${notification['type']?.toString() ?? 'N/A'}',
              'description': notification['message']?.toString() ?? 'N/A',
              'timestamp': notification['timestamp']?.toString() ?? 'N/A',
              'imagePath': 'assets/images/logo.png',
            };
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Error al conectar con el servidor: $e');
    }

    // Si no hay datos, generar 5 notificaciones ficticias
    return [
      {
        'title': 'Sensor de Temperatura',
        'description': 'El sensor de temperatura detectó un cambio de valor.',
        'timestamp': DateTime.now().toString(),
        'imagePath': 'assets/images/logo.png',
      },
      {
        'title': 'Sensor de Humedad',
        'description': 'El sensor de humedad detectó un cambio de valor.',
        'timestamp': DateTime.now().toString(),
        'imagePath': 'assets/images/logo.png',
      },
      {
        'title': 'Sensor de PH',
        'description': 'El sensor de PH detectó un cambio de valor.',
        'timestamp': DateTime.now().toString(),
        'imagePath': 'assets/images/logo.png',
      },
      {
        'title': 'Sensor de Luminosidad',
        'description': 'El sensor de luminosidad detectó un cambio de valor.',
        'timestamp': DateTime.now().toString(),
        'imagePath': 'assets/images/logo.png',
      },
      {
        'title': 'Actualización del sistema',
        'description': 'Se implementó una nueva actualización en el sistema.',
        'timestamp': DateTime.now().toString(),
        'imagePath': 'assets/images/logo.png',
      },
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar notificaciones'),
            );
          }

          final notifications = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  title: notification['title']!,
                  description: notification['description']!,
                  imagePath: notification['imagePath']!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
