import 'dart:convert';
import '../../config/config.dart';
import 'package:http/http.dart' as http;
import '../../config/global/global.dart' as global;
import 'models/models.dart';

Future<HttpsModel> get({required String endpoint, Map<String, String>? headers}) async {
  final uri = Uri.parse('$apiBaseUrl$endpoint');
  try {
    final response = await http.get(uri, headers: headers);
    return _processResponse(response);
  } catch (e) {
    throw Exception('Error en GET: $e');
  }
}

// POST request
Future<HttpsModel> post({required String endpoint, Map<String, String>? headers, Map<String, dynamic>? body}) async {
  final uri = Uri.parse('$apiBaseUrl$endpoint');
  try {
    final response = await http.post(
      uri,
      headers: headers ?? {"Content-Type": "application/x-www-form-urlencoded"},
      body: body,
    );
    return _processResponse(response);
  } catch (e) {
    print(endpoint);
    throw Exception('Error en POST: $e');
  }
}

// Procesa la respuesta y maneja errores
HttpsModel _processResponse(http.Response response) {
  final status = response.statusCode;
  HttpsModel data = response.body.isNotEmpty ? HttpsModel.fromJson(jsonDecode(response.body)) : HttpsModel();
  if (status >= 200 && status < 300) {
    return data;
  } else {
    global.snackBar(mensaje: "Error al obtener los datos.");
    return data;
  }
}