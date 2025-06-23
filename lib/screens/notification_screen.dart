import 'package:flutter/material.dart';
import '../model/notification_model.dart';
import '../services/notification_service.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<List<NotificationModel>> _loadNotifications(BuildContext context) async {
    try {
      final service = NotificationService(context);
      return await service.fetchNotifications();
    } catch (e) {
      debugPrint('Error al cargar notificaciones: $e');

      // Retorna notificaciones ficticias si ocurre un error
      return [
        NotificationModel(type: 'Temperatura', message: 'Cambio de temperatura detectado.', timestamp: DateTime.now().toString()),
        NotificationModel(type: 'Humedad', message: 'Cambio de humedad detectado.', timestamp: DateTime.now().toString()),
        NotificationModel(type: 'PH', message: 'Cambio de PH detectado.', timestamp: DateTime.now().toString()),
        NotificationModel(type: 'Luminosidad', message: 'Cambio de luminosidad detectado.', timestamp: DateTime.now().toString()),
        NotificationModel(type: 'Sistema', message: 'Actualización del sistema aplicada.', timestamp: DateTime.now().toString()),
      ];
    }
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
      body: FutureBuilder<List<NotificationModel>>(
        future: _loadNotifications(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar notificaciones'));
          }

          final notifications = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return NotificationCard(
                  title: 'Notificación: ${notif.type}',
                  description: notif.message,
                  imagePath: 'assets/images/logo.png',
                );
              },
            ),
          );
        },
      ),
    );
  }
}
