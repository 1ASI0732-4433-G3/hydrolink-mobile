import '../model/sensor.dart';
import 'base_service.dart';

class SensorService extends BaseService<Sensor> {
  SensorService(super.context)
      : super(
    resourceEndpoint: '/sensors',
    fromJson: (json) => Sensor.fromJson(json),
  );

  // Usa los métodos heredados directamente:
  Future<List<Sensor>> fetchSensors() => getAll();

  Future<Sensor> getSensorById(int id) => getById(id);

  Future<void> updateSensorById(int id, Map<String, dynamic> body) => update(id, body);
}
