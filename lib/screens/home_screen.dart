import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/device.dart';
import '../model/sensor.dart';
import '../services/device_service.dart';
import '../widgets/sensor_configuration.dart';
import '../widgets/sensor_widget.dart';
import '../providers/loading_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DeviceService _deviceService;
  List<Device> devices = [];
  List<Sensor> sensors = [];
  String? selectedDeviceName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deviceService = DeviceService(context);
      fetchDevices();
    });
  }

  Future<void> fetchDevices() async {
    try {
      final result = await _deviceService.getAll();
      debugPrint(result.map((d) => d.toJson()).toList().toString());
      setState(() {
        devices = result;
      });
    } catch (e) {
      showError('Error al obtener dispositivos');
    } finally {
      debugPrint('Dispositivos obtenidos: ${devices.length}');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String getSensorImage(String sensorType) {
    switch (sensorType.toUpperCase()) {
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

  void selectDevice(Device device) {
    setState(() {
      selectedDeviceName = device.location;
      sensors = device.sensors;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<LoadingProvider>(context).isLoading;
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
                title: Text(device.location),
                subtitle: Text('MAC: ${device.macAddress}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => selectDevice(device),
              ),
            );
          },
        )
            : ListView.builder(
          itemCount: sensors.length,
          itemBuilder: (context, index) {
            final sensor = sensors[index];
            return SensorWidget(
              title: sensor.type,
              status: sensor.status,
              imagePath: getSensorImage(sensor.type),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SensorConfigurationDialog(
                    sensorName: sensor.type,
                    sensorId: sensor.id,
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
