import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/sensor_configuration.dart';
import '../widgets/sensor_widget.dart';

const String devicesEndpoint = 'https://groweasy.azurewebsites.net/api/v1/devices';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> devices = [];
  List<dynamic> sensors = [];
  String? selectedDeviceName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('jwt');

      if (jwt == null) {
        showError('No se encontró el token JWT. Por favor, inicia sesión nuevamente.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(devicesEndpoint),
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          devices = json.decode(response.body);
          isLoading = false;
        });
      } else {
        showError('Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showError('Error: No se pudo conectar al servidor');
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String getSensorImage(String sensorType) {
    switch (sensorType) {
      case 'TEMPERATURE':
        return 'assets/images/sensor_temperatura.png';
      case 'HUMIDITY':
        return 'assets/images/sensor_humedad.webp';
      case 'LUMINOSITY':
        return 'assets/images/sensor_luminosidad.webp';
      default:
        return 'assets/images/default_sensor.png';
    }
  }

  void selectDevice(String deviceName, List<dynamic> deviceSensors) {
    setState(() {
      selectedDeviceName = deviceName;
      sensors = deviceSensors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          selectedDeviceName ?? 'GrowEasy',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        leading: selectedDeviceName != null
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            setState(() {
              selectedDeviceName = null;
              sensors = [];
            });
          },
        )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : selectedDeviceName == null
            ? ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ListTile(
                title: Text(device['location']),
                subtitle: Text('MAC: ${device['macAddress']}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  selectDevice(device['location'], device['sensors']);
                },
              ),
            );
          },
        )
            : ListView.builder(
          itemCount: sensors.length,
          itemBuilder: (context, index) {
            final sensor = sensors[index];
            return SensorWidget(
              title: sensor['type'],
              status: sensor['status'],
              imagePath: getSensorImage(sensor['type']),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SensorConfigurationDialog(
                    sensorName: sensor['type'],
                    sensorId: sensor['id'],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
