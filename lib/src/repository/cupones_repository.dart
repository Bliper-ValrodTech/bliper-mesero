import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bliper_mesero/src/models/configuracion.dart' as config;
import '../models/cupones_chat.dart';
import '../controllers/global.dart' as global;
Future<List<CuponesChat>> getCupones() async {
  Uri uri = Uri.parse('${config.apiBaseUrl}cupones/obtener_cupones.php');
  try {
    var map = <String, dynamic>{};
    map['device_token'] = global.token;
    map['restaurant_id'] = global.user.id;
    final response = await http.post(
        uri,
        body: map,
    );
    final parsed = jsonDecode(response.body.toString())['data'].cast<Map<String, dynamic>>();
    return parsed.map<CuponesChat>((json) => CuponesChat.fromJSON(json)).toList();
  } catch (e) {
    print("=======================================================");
    print("Error en getCupones repository: Cupones_repository");
    print("=======================================================");
    print(e.toString());
    print("=======================================================");
    List<CuponesChat> Cupones = <CuponesChat>[];
    return Cupones;
  }
}