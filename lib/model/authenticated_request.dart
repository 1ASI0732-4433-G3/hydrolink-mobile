import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> authenticatedRequest(
    String url,
    String method, {
      Map<String, dynamic>? body,
    }) async {
  final prefs = await SharedPreferences.getInstance();
  final jwt = prefs.getString('jwt');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwt',
  };

  switch (method.toUpperCase()) {
    case 'GET':
      return await http.get(Uri.parse(url), headers: headers);
    case 'POST':
      return await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
    case 'PUT':
      return await http.put(Uri.parse(url), headers: headers, body: json.encode(body));
    case 'DELETE':
      return await http.delete(Uri.parse(url), headers: headers);
    default:
      throw UnsupportedError('Método HTTP no soportado: $method');
  }
}
