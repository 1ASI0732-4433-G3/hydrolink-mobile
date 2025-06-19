import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/sensor.dart';

class SensorService {
  static const String _sensorsEndpoint = 'https://inherent-steffi-hydrolink-531626a5.koyeb.app/api/v1/sensors';

  /// Obtiene la lista de sensores
  static Future<List<Sensor>> fetchSensors(String jwt) async {
    final response = await http.get(
      Uri.parse(_sensorsEndpoint),
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((sensor) => Sensor.fromJson(sensor)).toList();
    } else {
      throw Exception('Failed to fetch sensors: ${response.statusCode}');
    }
  }

  /// Actualiza un sensor
  static Future<void> updateSensor(String jwt, Sensor sensor) async {
    final response = await http.put(
      Uri.parse('$_sensorsEndpoint/${sensor.id}'),
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
      body: json.encode(sensor.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sensor: ${response.statusCode}');
    }
  }
}
