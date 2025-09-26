import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bliper_mesero/src/models/configuracion.dart' as config;
import 'package:bliper_mesero/src/models/cupon.dart';
import 'package:bliper_mesero/src/models/food.dart';
import 'package:bliper_mesero/src/models/orden_voz.dart';
import 'package:http/http.dart' as http;
import '../controllers/global.dart' as global;
import '../models/restaurant.dart';

Future<String> ocrImg({required File img}) async{
  var map = <String, dynamic>{};
  map['device_token'] = global.token;
  map['restaurant_id'] = global.user.restaurante_id;

  final request = http.MultipartRequest("POST", Uri.parse('${config.apiBaseUrl}ocr/subir_imagen_ocr.php'),);
  request.fields['device_token'] = global.token;
  request.files.add(
      http.MultipartFile(
          'imagen',
          img.readAsBytes().asStream(),
          img.lengthSync(),
          filename: img.path.split("/").last
      )
  );
  final respuesta = await request.send();
  var response = await http.Response.fromStream(respuesta);
  print("============= ocrImg ==========");
  log(jsonDecode(response.body)["message"]);
  return jsonDecode(response.body)["message"];
}
Future<List<Food>> GetFoods({intentos})async {
  var map = <String, dynamic>{};
  map['device_token'] = global.token;
  map['restaurant_id'] = global.user.restaurante_id;
  final response = await http.post(
      Uri.parse('${config.apiBaseUrl}comidas/obtener_comidas.php'),
      body: map
  );
  //print("============= getfoods ==========");
  //log(response.body);
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Food>((json) => Food.fromJSON(json)).toList();
  } else {

    throw Exception('Failed to load body GetFoods');
  }
}
Future<OrdenVoz> SendAudio(Audio,{required mesa}) async {

  Uri uri = Uri.parse('${config.apiBaseUrl}voz/recivir_audio.php?device_token=${global.token}&restaurantID=${global.user.restaurante_id}');
  var request = http.MultipartRequest('POST', uri);
  request.files.add(
      http.MultipartFile(
          'Audio',
          File(Audio).readAsBytes().asStream(),
          File(Audio).lengthSync(),
          filename: Audio.split("/").last
      )
  );
  var res = await request.send();

  final respStr = await res.stream.bytesToString();
  log(respStr);
  OrdenVoz orden = OrdenVoz();
  String guardado = json.decode(respStr)["success"].toString();
  try{
    orden.total = json.decode(respStr)["data"]["total"].toString();
    orden.impuesto = json.decode(respStr)["data"]["iva"].toString();
    orden.subTotal = json.decode(respStr)["data"]["subtotal"].toString();
    orden.iva = global.user.porcentaje_iva;
    for(int i = 0; i < json.decode(respStr)["data"]["productos"].length; i++){
      Food comida = Food();
      Restaurant restaurant = Restaurant();
      comida.id = json.decode(respStr)["data"]["productos"][i]["id"].toString();
      comida.name = json.decode(respStr)["data"]["productos"][i]["nombre"].toString();
      comida.price = double.parse(json.decode(respStr)["data"]["productos"][i]["precio"].toString());
      comida.imagen_url = json.decode(respStr)["data"]["productos"][i]["imagen"].toString();
      comida.cantidad = json.decode(respStr)["data"]["productos"][i]["cantidad"].toString();
      comida.nota = json.decode(respStr)["data"]["productos"][i]["nota"].toString();
      restaurant.id = global.user.restaurante_id;
      restaurant.name = global.user.restaurant_name;
      restaurant.defaultTax = double.parse(global.user.porcentaje_iva);
      comida.restaurant = restaurant;
      orden.comidas.add(comida);
    }
  }catch(e){
    guardado = "false";
    print("error $e");
  }
  if(guardado == "true")
  {
    orden.respuesta = 1;
    return orden;
  }
  else {
      orden.respuesta = 0;
      return orden;
    }
}
// ignore: non_constant_identifier_names
Future<OrdenVoz> voz_comida({required String audio}) async {
  var map = <String, dynamic>{};
  map['device_token'] = global.token;
  map['audio'] = audio;

  Uri uri = Uri.parse('${config.apiBaseUrl}comidas/voz_comidas.php');
  var request = http.MultipartRequest('POST', uri);
  request.files.add(
      http.MultipartFile(
          'audio',
          File(audio).readAsBytes().asStream(),
          File(audio).lengthSync(),
          filename: "audio"
      ),
  );
  request.fields['device_token'] = global.token;

  var res = await request.send();
  final respStr = await res.stream.bytesToString();
  log(respStr);
  OrdenVoz orden = OrdenVoz();
  if(jsonDecode(respStr)["success"].toString() == "true"){
    orden.total = json.decode(respStr)["data"]["total"].toString();
    orden.impuesto = json.decode(respStr)["data"]["iva"].toString();
    orden.subTotal = json.decode(respStr)["data"]["subtotal"].toString();
    orden.iva = global.user.porcentaje_iva;
    for(int i = 0; i < json.decode(respStr)["data"]["foods"].length; i++){
      Food comida = Food();
      Restaurant restaurant = Restaurant();
      comida.id = json.decode(respStr)["data"]["foods"][i]["id"].toString();
      comida.name = json.decode(respStr)["data"]["foods"][i]["name"].toString();
      comida.price = double.parse(json.decode(respStr)["data"]["foods"][i]["price"].toString());
      comida.imagen_url = json.decode(respStr)["data"]["foods"][i]["imagen_url"].toString();
      comida.cantidad = json.decode(respStr)["data"]["foods"][i]["cantidad"].toString();
      comida.nota = json.decode(respStr)["data"]["foods"][i]["nota"].toString();
      restaurant.id = global.user.restaurante_id;
      restaurant.name = global.user.restaurant_name;
      restaurant.defaultTax = double.parse(global.user.porcentaje_iva);
      comida.restaurant = restaurant;
      orden.comidas.add(comida);
    }
    orden.respuesta = 1;
    return orden;
  }else{
    orden.respuesta = 0;
    return orden;
  }
}
Future<List<Object>> VerificarCupon({required String codigo_cupon, required String device_token}) async {
  //http://192.168.100.199/bliper/backend/public/index.php/api/aplicarCupon/codigo/device_token
  var map = <String, dynamic>{};
  map['device_token'] = global.token.toString();
  map['restaurant_id'] = global.user.restaurante_id;
  map['client_deviceToken'] = device_token;
  map['codigo_cupon'] = codigo_cupon;

  final response = await http.post(
    Uri.parse('${config.apiBaseUrl}cupones/verificar_cupon.php'),
    body: map,
  );
  print(Uri.parse('${config.apiBaseUrl}cupones/verificar_cupon.php'));
  log(response.body);

  if(jsonDecode(response.body)['success'].toString() == "true") {
      List<Object> respuesta = <Object>[];
      final parsed = jsonDecode(response.body)['data'];
      Cupon cupon = Cupon();
      cupon = Cupon.fromJSON(parsed);
      respuesta.add(jsonDecode(response.body)['success'].toString());
      respuesta.add(cupon);
      return respuesta;
    }
    else {
      List<Object> respuesta = <Object>[];
      respuesta.add(jsonDecode(response.body)['success'].toString());
      respuesta.add(jsonDecode(response.body)['message'].toString());
      return respuesta;
    }
}
Future<List<String>> ordenar_cupon({required String client_deviceToken,required String codigo_chat,required String codigo_cupon,required String mesa,intentos}) async{
  var map = <String, dynamic>{};
  map["device_token"] = global.token;
  map["codigo_cupon"] = codigo_cupon;
  map["client_deviceToken"] = client_deviceToken;
  map["codigo_chat"] = codigo_chat;
  map["mesa"]  = mesa;
  final response = await http.post(
    Uri.parse('${config.apiBaseUrl}cupones/crear_orden_cupon.php'),
    body: map,
  );
  log(jsonDecode(response.body).toString());
  if (response.statusCode == 200) {
    List<String> respuesta = <String>[];
    if(jsonDecode(response.body)['success'].toString() == "true")
    {
      respuesta.add(jsonDecode(response.body)['success'].toString());
      respuesta.add(jsonDecode(response.body)['message'].toString());
      return respuesta;
    }else
    {
      respuesta.add(jsonDecode(response.body)['success'].toString());
      respuesta.add(jsonDecode(response.body)['message'].toString());
      return respuesta;
    }
  } else {
    throw Exception('Failed to load body ordenar_cupon');
  }
}
Future<String> GetCategorias() async{
  var map = <String, dynamic>{};
  map['device_token'] = global.token;
  final response = await http.post(
      Uri.parse('${config.apiBaseUrl}comidas/obtener_categorias.php'),
      body: map
  );
  //print("============= GetCategorias ==========");
  //log(response.body);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return '{"success":"false", "message":"Error ${response.statusCode}"}';
  }
}