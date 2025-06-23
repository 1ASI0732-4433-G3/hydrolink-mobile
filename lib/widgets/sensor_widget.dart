import 'package:flutter/material.dart';

class SensorWidget extends StatelessWidget {
  final String title;
  final String status;
  final String imagePath;
  final VoidCallback onTap;

  const SensorWidget({super.key,
    required this.title,
    required this.status,
    required this.imagePath,
    required this.onTap, // Callback para manejar eventos de clic
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Llama a la función pasada desde el HomeScreen
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Alinear textos a la izquierda
            children: [
              // Imagen del sensor, con tamaño más grande
              Image.asset(
                height: 200,
                imagePath, // Aumentar tamaño de la imagen
                width: double.infinity, // Ocupar todo el ancho disponible
                fit: BoxFit.contain, // Ajustar la imagen para que no pierda proporción
              ),
              const Divider(color: Colors.grey), // Línea divisoria
              // Título del sensor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Estado del sensor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 9.0),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    color: status == "ACTIVE"
                        ? Colors.green // Cambiar color del texto y colocar en bold
                        : status == "Requiere Atención"
                        ? Colors.orange
                        : Colors.red, // Colores para diferentes estados
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
