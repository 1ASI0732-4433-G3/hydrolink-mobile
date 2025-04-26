import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;
  final bool isSelected; // Para destacar si la tarjeta está seleccionada

  const SubscriptionCard({
    required this.title,
    required this.price,
    required this.imagePath,
    this.isSelected = false, // Valor predeterminado: no seleccionado
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.transparent, // Borde verde si está seleccionado
          width: 2,
        ),
      ),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Color verde para el precio
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
