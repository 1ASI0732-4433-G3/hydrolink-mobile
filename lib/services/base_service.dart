import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/loading_provider.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class BaseService<T> {
  final BuildContext context;
  final String baseUrl = 'https://inherent-steffi-hydrolink-531626a5.koyeb.app/api/v1';
  final String resourceEndpoint;
  final FromJson<T> fromJson;

  BaseService(this.context, {
    required this.resourceEndpoint,
    required this.fromJson,
  });

  /// Construye la ruta completa al recurso
  String get resourcePath => '$baseUrl$resourceEndpoint';

  /// Agrega headers con token JWT
  @protected
  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt') ?? '';
    return {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
  }

  /// Obtiene una lista del recurso
  Future<List<T>> getAll() async {
    final loading = getLoadingProvider();

    loading.start();
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse(resourcePath), headers: headers);
      handleErrors(response);
      final List<dynamic> body = json.decode(response.body);
      return body.map((item) => fromJson(item)).toList();
    } finally {
      loading.stop();
    }
  }

  /// Obtiene un solo recurso por ID
  Future<T> getById(dynamic id) async {
    final loading = getLoadingProvider();
    loading.start();
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse('$resourcePath/$id'), headers: headers);
      handleErrors(response);
      return fromJson(json.decode(response.body));
    } finally {
      loading.stop();
    }
  }

  /// Actualiza un recurso
  Future<void> update(dynamic id, Map<String, dynamic> body) async {
    final loading = getLoadingProvider();
    loading.start();
    try {
      final headers = await getHeaders();
      final response = await http.put(
        Uri.parse('$resourcePath/$id'),
        headers: headers,
        body: json.encode(body),
      );
      handleErrors(response);
    } finally {
      loading.stop();
    }
  }

  /// Crea un nuevo recurso
  Future<void> create(Map<String, dynamic> body) async {
    final loading = getLoadingProvider();
    loading.start();
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse(resourcePath),
        headers: headers,
        body: json.encode(body),
      );
      handleErrors(response);
    } finally {
      loading.stop();
    }
  }

  /// Elimina un recurso
  Future<void> delete(dynamic id) async {
    final loading = getLoadingProvider();
    loading.start();
    try {
      final headers = await getHeaders();
      final response = await http.delete(
        Uri.parse('$resourcePath/$id'),
        headers: headers,
      );
      handleErrors(response);
    } finally {
      loading.stop();
    }
  }

  @protected
  LoadingProvider getLoadingProvider() {
    return Provider.of<LoadingProvider>(context, listen: false);
  }


  @protected
  void handleErrors(http.Response response) {
    if (response.statusCode >= 400) {
      String errorMessage = 'Error del servidor';
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Datos inválidos. Verifica los campos.';
          break;
        case 401:
        case 403:
          errorMessage = 'No autorizado. Inicia sesión nuevamente.';
          break;
        case 404:
          errorMessage = 'Recurso no encontrado.';
          break;
        case 500:
          errorMessage = 'Error interno del servidor.';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );

      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
