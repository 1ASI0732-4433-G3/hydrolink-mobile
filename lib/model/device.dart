import 'sensor.dart';

class Device {
  final int id;
  final String location;
  final String macAddress;
  final String status;
  final List<Sensor> sensors;

  Device({
    required this.id,
    required this.location,
    required this.macAddress,
    required this.status,
    required this.sensors,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      location: json['location'],
      macAddress: json['macAddress'],
      status: json['status'],
      sensors: (json['sensors'] as List<dynamic>)
          .map((sensorJson) => Sensor.fromJson(sensorJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'macAddress': macAddress,
      'status': status,
      'sensors': sensors.map((s) => s.toJson()).toList(),
    };
  }
}


