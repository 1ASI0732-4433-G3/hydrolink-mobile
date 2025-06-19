import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SensorConfigurationDialog extends StatefulWidget {
  final String sensorName;
  final int sensorId;

  const SensorConfigurationDialog({
    super.key,
    required this.sensorName,
    required this.sensorId,
  });

  @override
  _SensorConfigurationDialogState createState() =>
      _SensorConfigurationDialogState();
}

class _SensorConfigurationDialogState extends State<SensorConfigurationDialog> {
  late RangeValues rangeValues;
  late double thresholdValue;
  bool isLoading = true;

  double rangeMin = 0;
  double rangeMax = 50; // Default range

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
    thresholdValue = (rangeMax + rangeMin) / 2; // Default threshold
  }

  Future<void> fetchSensorData() async {
    final url = Uri.parse(
        'https://inherent-steffi-hydrolink-531626a5.koyeb.app/api/v1/sensors/${widget.sensorId}');
    try {
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('jwt');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final sensorData = json.decode(response.body);

        // Extract sensor configuration
        double min = sensorData['config']['min'].toDouble();
        double max = sensorData['config']['max'].toDouble();
        double threshold = sensorData['config']['threshold'].toDouble();

        // Validate and adjust values
        if (min < rangeMin) min = rangeMin;
        if (max > rangeMax) max = rangeMax;
        if (min >= max) {
          min = rangeMin;
          max = rangeMax;
        }
        if (threshold < min) threshold = min;
        if (threshold > max) threshold = max;

        setState(() {
          rangeValues = RangeValues(min, max);
          thresholdValue = threshold;
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener los datos del sensor');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> updateSensorData() async {
    final url =
    Uri.parse('https://inherent-steffi-hydrolink-531626a5.koyeb.app/api/v1/sensors/${widget.sensorId}');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    final updatedConfig = {
      'min': rangeValues.start,
      'max': rangeValues.end,
      'threshold': thresholdValue,
      'type': widget.sensorName,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedConfig),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Configuración actualizada con éxito')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Error al actualizar los datos del sensor');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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

                // Adjust threshold if it goes out of the range
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
