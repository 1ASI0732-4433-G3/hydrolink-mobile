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

class SensorConfig {
  final int id;
  final int min;
  final int max;
  final int threshold;

  SensorConfig({
    required this.id,
    required this.min,
    required this.max,
    required this.threshold,
  });

  factory SensorConfig.fromJson(Map<String, dynamic> json) {
    return SensorConfig(
      id: json['id'],
      min: json['min'],
      max: json['max'],
      threshold: json['threshold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'min': min,
      'max': max,
      'threshold': threshold,
    };
  }
}
