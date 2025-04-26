import 'package:flutter/material.dart';
import 'package:grow_easy_mobile_application/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/subscription_card_widget.dart';
import 'home_screen.dart'; // Asegúrate de importar la pantalla de Home

class SubscriptionsScreen extends StatefulWidget {
  @override
  _SubscriptionsScreenState createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  String? selectedPlan; // Variable para almacenar el plan seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('SUSCRIPCIONES'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona tu plan',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlan = 'Plan Básico';
                      });
                    },
                    child: SubscriptionCard(
                      title: 'Plan Básico',
                      price: 's/. 10 mes',
                      imagePath: 'assets/images/plans/basic.jpg',
                      isSelected: selectedPlan == 'Plan Básico', // Marcar como seleccionado
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlan = 'Plan Standard';
                      });
                    },
                    child: SubscriptionCard(
                      title: 'Plan Standard',
                      price: 's/. 30 mes',
                      imagePath: 'assets/images/plans/standar.jpg',
                      isSelected: selectedPlan == 'Plan Standard',
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlan = 'Plan Premium';
                      });
                    },
                    child: SubscriptionCard(
                      title: 'Plan Premium',
                      price: 's/. 80 mes',
                      imagePath: 'assets/images/plans/premiun.jpg',
                      isSelected: selectedPlan == 'Plan Premium',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedPlan != null) {
            // Guardar la selección de plan en SharedPreferences (opcional)
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('selectedPlan', selectedPlan!);

            // Mostrar el SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Has seleccionado el $selectedPlan'),
              ),
            );

            // Redirigir a la pantalla de Home después de seleccionar el plan
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(), // Pantalla de Home
                ),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Por favor selecciona un plan.'),
              ),
            );
          }
        },
        child: Icon(Icons.check), // Icono de confirmación
      ),

    );
  }
}
