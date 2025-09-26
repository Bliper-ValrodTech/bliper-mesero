import 'dart:convert';
import 'package:bliper_mesero/src/models/audios.dart';
import 'package:http/http.dart' as http;
import 'package:bliper_mesero/src/models/configuracion.dart' as config;
import '../controllers/global.dart' as global;


Future<List<Audio>> GetAudios(numero_mesa,restaurant_id,{intentos}) async {
  String token = global.token.toString();
  Uri uri = Uri.parse('${config.apiBaseUrl}getAudios/$numero_mesa/$restaurant_id/$token');
  print(uri);
  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      return parsed.map<Audio>((json) => Audio.fromJSON(json)).toList();
    } else {
      throw Exception('Failed to load body');
    }
  } catch (e) {
    print("Error en GetAudios repository");
    print(e.toString());

    return Stream.value(Audio.fromJSON({})).toList();
  }
}