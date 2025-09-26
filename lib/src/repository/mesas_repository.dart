import 'dart:convert';
import 'dart:developer';
import 'package:bliper_mesero/src/models/sesiones_mesas.dart';
import '../controllers/global.dart' as global;
import '../models/configuracion.dart' as config;
import '../models/mesas.dart';
import 'package:http/http.dart' as http;
import '../models/meseros.dart';

Future<List<Meseros>> obtener_Meseros() async{
  //http://192.168.100.199/bliper/backend/public/index.php/api/getMeseros
  Uri uri = Uri.parse('${config.apiBaseUrl}meseros/obtener_meseros.php');
  print(uri);
  try {
    var map = <String, dynamic>{};
    map['device_token'] = global.token;
    map['restaurant_id'] = global.user.restaurante_id;
    final response = await http.post(
      uri,
      body: map,
    );
    log(response.body);
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      return parsed.map<Meseros>((json) => Meseros.fromJSON(json)).toList();
    } else {
      print('Failed to load body obtener_Meseros repository');

      throw Exception('Failed to load body obtener_Meseros repository');
    }
  } catch (e) {
    print("Error en obtener_Meseros repository");
    print(e.toString());
    return Stream.value(Meseros.fromJSON({})).toList();
  }
}
Future<List<Mesas>> obtener_Mesas() async{
  Uri uri = Uri.parse('${config.apiBaseUrl}mesas/obtener_mesas.php');
  print(uri);

  var map = <String, dynamic>{};
  map['restaurant_id'] = global.user.restaurante_id;
  map['device_token'] = global.token;
  print("ID ${global.user.id}");
  try {
    http.Response? response;
    int cont = 0;
    while(cont < 3){
      response = await http.post(
          uri,
          body: map
      );
      if(response.statusCode == 200){
        break;
      }
      else{
        cont++;
        print("obtener_Mesas Centros_repository intento $cont");
      }
    }
    print("========== obtener_mesas ===========");
    print(response!.body);
    String success = jsonDecode(response.body)["success"];
    print(success);
    if (success == "true") {
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      return parsed.map<Mesas>((json) => Mesas.fromJSON(json)).toList();
    } else {
      print("Error en obtener_Mesas repository");
      print('Failed to load body obtener_Mesas repository');
      throw Exception('Failed to load body obtener_Mesas repository');
    }
  } catch (e) {
    print("Error en obtener_Mesas repository");
    print(e.toString());
    print("Error en obtener_Mesas repository");
    print('Failed to load body obtener_Mesas repository');
    return Stream.value(Mesas.fromJSON({})).toList();
  }
}
Future<String> pasar_Mesa({required String mesa, required String mesero}) async{
  Uri uri = Uri.parse('${config.apiBaseUrl}mesas/peticion_mesas.php');
  print(uri);
  var map = <String, dynamic>{};
  map['restaurant_id'] = global.user.restaurante_id;
  map['device_token'] = global.token;
  map['mesa'] = mesa;
  map['id_mesero_a_pasar'] = mesero;

  print("ID ${global.user.id}");
  try {
    http.Response? response;
    int cont = 0;
    while(cont < 3){
      response = await http.post(
          uri,
          body: map
      );
      if(response.statusCode == 200){
        break;
      }
      else{
        cont++;
        print("pasar_Mesa Centros_repository intento $cont");
      }
    }
    print("========== pasar_Mesa ===========");
    print(response!.body);
    String success = jsonDecode(response.body)["success"];
    print(success);
    if (success == "true") {
      return jsonDecode(response.body)['message'];
    } else {
      print("Error en pasar_Mesa repository");
      print('Failed to load body pasar_Mesa repository');
      return "Error al enviar la peticion";
      //throw Exception('Failed to load body pasar_Mesa repository');
    }
  } catch (e) {
    print("Error en pasar_Mesa repository");
    print(e.toString());
    print("Error en pasar_Mesa repository");
    print('Failed to load body pasar_Mesa repository');
    return "Error al enviar la peticion";
  }
}

Future<List<SesionesMesas>> obtener_Sesiones() async{
  Uri uri = Uri.parse('${config.apiBaseUrl}ordenes/sesiones_mesas.php');
  print(uri);
  var map = <String, dynamic>{};
  map['device_token'] = global.token;
  map['dispositivo'] = "mesero";
  try {
    http.Response? response;
    int cont = 0;
    while(cont < 3){
      response = await http.post(
          uri,
          body: map
      );
      if(response.statusCode == 200){
        break;
      }
      else{
        cont++;
        print("obtener_Sesiones intento $cont");
      }
    }
    print("========== pasar_Mesa ===========");
    print(response!.body);
    String success = jsonDecode(response.body)["success"];
    print(success);
    if (success == "true") {
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      return parsed.map<SesionesMesas>((json) => SesionesMesas.fromJSON(json)).toList();
    } else {
      print("Error en obtener_Sesiones repository");
      print('Failed to load body obtener_Sesiones repository');
      throw Exception('Failed to load body obtener_Sesiones repository');
    }
  } catch (e) {
    print("Error en obtener_Sesiones repository");
    print('Failed to load body obtener_Sesiones repository');
    throw Exception('Error obtener_Sesiones mesas_repository$e');
  }
}