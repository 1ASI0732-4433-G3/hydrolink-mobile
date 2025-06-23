import '../model/notification_model.dart';
import 'base_service.dart';

class NotificationService extends BaseService<NotificationModel> {
  NotificationService(super.context)
      : super(
    resourceEndpoint: '/notifications',
    fromJson: (json) => NotificationModel.fromJson(json),
  );

  Future<List<NotificationModel>> fetchNotifications() => getAll();
}
