import 'dart:convert';
import 'dart:developer';

import '../models/centro_mesa.dart';
import 'package:http/http.dart' as http;
import 'package:bliper_mesero/src/models/configuracion.dart' as config;
import '../controllers/global.dart' as global;
import '../models/mesas.dart';
import '../models/meseros.dart';

Future<List<Mesas>> obtener_Mesas() async{
  Uri uri = Uri.parse('${config.apiBaseUrl}mesas/obtener_mesas.php');
  print(uri);

  var map = <String, dynamic>{};
  map['restaurant_id'] = global.user.restaurante_id;
  map['device_token'] = global.token;
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
Future<String> cambiar_Mesas({required String numero_mesa, required String codigo}) async{
  Uri uri = Uri.parse('${config.apiBaseUrl}mesas/cambiar_numeroMesa_alQR.php');
  print(uri);
  try {
    var map = <String, dynamic>{};
    map['numero_mesa'] = numero_mesa;
    map['device_token'] = global.token;
    map['codigo'] = codigo;
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['success'].toString();
    } else {
      print("Error en cambiar_Mesas repository");
      print("Error en obtener_Mesas repository");
      print('Failed to load body obtener_Mesas repository');
      return "false";
    }
  } catch (e) {
    print("Error en cambiar_Mesas repository");
    print(e.toString());
    print('Failed to load body obtener_Mesas repository');
    return "false";
  }
}
Future<List<Centro_Mesa>> obtener_Centros() async{
  Uri uri = Uri.parse('${config.apiBaseUrl}mesas/obtener_todosLosCentrosMesas.php');
  print(uri);
  try {
    var map = <String, dynamic>{};
    map['device_token'] = global.token;
    final response = await http.post(
      uri,
      body: map,
    );
    log(response.body);
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      return parsed.map<Centro_Mesa>((json) => Centro_Mesa.fromJSON(json)).toList();
    } else {
      print("Error en obtener_Centros repository");

      throw Exception('Failed to load body obtener_Centros repository');
    }
  } catch (e) {
    print("Error en obtener_Centros repository");
    print(e.toString());
    print("Error en obtener_Centros repository");
    print("Error en obtener_Centros repository");
    print('Failed to load body obtener_Centros repository');
    return Stream.value(Centro_Mesa.fromJSON({})).toList();
  }
}
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
Future<String> cambiar_Mesero({required String mesero_id,required String codigo}) async{
  Uri uri = Uri.parse('${config.apiBaseUrl}mesas/cambiar_mesero_QRMesa.php');
  print(uri);
  try {
    var map = <String, dynamic>{};
    map['mesero_id'] = mesero_id;
    map['codigo'] = codigo;
    map['device_token'] = global.token;
    final response = await http.post(
      uri,
      body: map,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['success'].toString();
    } else {
      print("Error en cambiar_Mesero repository");
      print('Failed to load body cambiar_Mesero repository');
      return "false";
    }
  } catch (e) {
    print("Error en cambiar_Mesero repository");
    print(e.toString());
    print('Failed to load body cambiar_Mesero repository');
    return "false";
  }
}
Future<Centro_Mesa> obtener_CentroMesa({required String codigo}) async{
  Uri uri = Uri.parse('${config.apiBaseUrl}mesas/obtener_qrMesa.php');
  print(uri);
  try {
    var map = <String, dynamic>{};
    map['restaurant_id'] = global.user.restaurante_id;
    map['device_token'] = global.token;
    map['codigo'] = codigo;
    final response = await http.post(
      uri,
      body: map,
    );
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      List<Centro_Mesa> centros = parsed.map<Centro_Mesa>((json) => Centro_Mesa.fromJSON(json)).toList();
      return centros[0];
    } else {
      Centro_Mesa vacio = Centro_Mesa();
      vacio.id="0";
      print("Error en obtener_CentroMesa repository");
      print('Failed to load body obtener_CentroMesa repository');
      return vacio;
    }
  } catch (e) {
    print("Error en obtener_CentroMesa repository");
    print(e.toString());
    Centro_Mesa vacio = Centro_Mesa();
    vacio.id="0";
    print('Failed to load body obtener_CentroMesa repository');
    return vacio;
  }
}