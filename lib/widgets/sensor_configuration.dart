import 'package:flutter/material.dart';
import '../model/sensor.dart';
import '../model/sensor_config.dart';
import '../services/sensor_service.dart';

class SensorConfigurationDialog extends StatefulWidget {
  final String sensorName;
  final int sensorId;

  const SensorConfigurationDialog({
    super.key,
    required this.sensorName,
    required this.sensorId,
  });

  @override
  State<SensorConfigurationDialog> createState() =>
      _SensorConfigurationDialogState();
}

class _SensorConfigurationDialogState extends State<SensorConfigurationDialog> {
  late RangeValues rangeValues;
  late double thresholdValue;
  bool isLoading = true;

  double rangeMin = 0;
  double rangeMax = 50;

  late Sensor _currentSensor;

  @override
  void initState() {
    super.initState();
    setInitialRange();
    fetchSensorData();
  }

  void setInitialRange() {
    if (widget.sensorName == "LUMINOSITY") {
      rangeMin = 0.1;
      rangeMax = 100000;
    } else if (widget.sensorName == "TEMPERATURE") {
      rangeMin = 10;
      rangeMax = 80;
    } else if (widget.sensorName == "HUMIDITY") {
      rangeMin = 0;
      rangeMax = 100;
    }
    rangeValues = RangeValues(rangeMin, rangeMax);
    thresholdValue = (rangeMax + rangeMin) / 2;
  }

  Future<void> fetchSensorData() async {
    try {
      final sensorService = SensorService(context);
      final sensor = await sensorService.getSensorById(widget.sensorId);

      double min = sensor.config.min.toDouble();
      double max = sensor.config.max.toDouble();
      double threshold = sensor.config.threshold.toDouble();

      // Validación
      if (min < rangeMin) min = rangeMin;
      if (max > rangeMax) max = rangeMax;
      if (min >= max) {
        min = rangeMin;
        max = rangeMax;
      }
      if (threshold < min) threshold = min;
      if (threshold > max) threshold = max;

      if (!mounted) return; // Evita usar context si el widget fue desmontado

      setState(() {
        _currentSensor = sensor;
        rangeValues = RangeValues(min, max);
        thresholdValue = threshold;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> updateSensorData() async {
    try {
      final sensorService = SensorService(context);

      final updatedConfig = SensorConfig(
        id: _currentSensor.config.id,
        min: rangeValues.start.round().toDouble(),
        max: rangeValues.end.round().toDouble(),
        threshold: thresholdValue.round().toDouble(),
      );

      final updatedSensor = Sensor(
        id: _currentSensor.id,
        type: _currentSensor.type,
        status: _currentSensor.status,
        deviceId: _currentSensor.deviceId,
        config: updatedConfig,
      );

      await sensorService.updateSensorById(updatedSensor.id, updatedSensor.toUpdatePayload());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuración actualizada con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
      title: Text(widget.sensorName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rango de valores',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min: ${rangeValues.start.toStringAsFixed(2)}'),
              Text('Max: ${rangeValues.end.toStringAsFixed(2)}'),
            ],
          ),
          RangeSlider(
            values: rangeValues,
            min: rangeMin,
            max: rangeMax,
            divisions: 10,
            labels: RangeLabels(
              rangeValues.start.toStringAsFixed(2),
              rangeValues.end.toStringAsFixed(2),
            ),
            onChanged: (values) {
              setState(() {
                rangeValues = values;

                if (thresholdValue < rangeValues.start) {
                  thresholdValue = rangeValues.start;
                } else if (thresholdValue > rangeValues.end) {
                  thresholdValue = rangeValues.end;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Umbral',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Umbral: ${thresholdValue.toStringAsFixed(2)}'),
            ],
          ),
          Slider(
            value: thresholdValue,
            min: rangeValues.start,
            max: rangeValues.end,
            divisions: 10,
            label: thresholdValue.toStringAsFixed(2),
            onChanged: (value) {
              setState(() {
                thresholdValue = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: updateSensorData,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
