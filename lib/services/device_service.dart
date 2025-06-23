import '../model/device.dart';
import 'base_service.dart';

class DeviceService extends BaseService<Device> {
  DeviceService(super.context)
      : super(
    resourceEndpoint: '/devices',
    fromJson: (json) => Device.fromJson(json),
  );
}
