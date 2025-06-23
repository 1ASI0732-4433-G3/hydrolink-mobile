class SensorConfig {
  final int id;
  final double min;
  final double max;
  final double threshold;

  SensorConfig({
    required this.id,
    required this.min,
    required this.max,
    required this.threshold,
  });

  factory SensorConfig.fromJson(Map<String, dynamic> json) {
    return SensorConfig(
      id: json['id'],
      min: (json['min']).toDouble(),
      max: (json['max']).toDouble(),
      threshold: (json['threshold']).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'min': min,
    'max': max,
    'threshold': threshold,
  };
}