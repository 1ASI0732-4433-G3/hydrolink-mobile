import 'sensor_config.dart';

class Sensor {
  final int id;
  final String type;
  final String status;
  final int deviceId;
  final SensorConfig config;

  Sensor({
    required this.id,
    required this.type,
    required this.status,
    required this.deviceId,
    required this.config,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      deviceId: json['deviceId'],
      config: SensorConfig.fromJson(json['config']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'deviceId': deviceId,
      'config': config.toJson(),
    };
  }

}

extension SensorUpdatePayload on Sensor {
  Map<String, dynamic> toUpdatePayload() {
    return {
      'min': config.min,
      'max': config.max,
      'threshold': config.threshold,
      'type': type,
    };
  }
}

