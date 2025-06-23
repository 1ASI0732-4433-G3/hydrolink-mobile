class NotificationModel {
  final String type;
  final String message;
  final String timestamp;

  NotificationModel({
    required this.type,
    required this.message,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      type: json['type'] ?? 'N/A',
      message: json['message'] ?? 'N/A',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
