import 'dart:convert';
import 'dart:developer';
import 'package:bliper_mesero/src/models/order.dart';
import 'package:bliper_mesero/src/models/payment.dart';
import 'package:http/http.dart' as http;
import 'package:bliper_mesero/src/models/configuracion.dart' as config;
import '../controllers/global.dart' as global;

Future<int> agregarOrden(Order order,Payment payment,{intentos})async {
  Uri uri = Uri.parse("${config.apiBaseUrl}ordenes/crear_orden.php");
  order.payment = payment;
  final client = http.Client();
  var map = <String, dynamic>{};

  map["user_id"] = global.user.id;
  map["order_status_id"] = "1";
  map["tax"] = order.tax.toString();
  map["delivery_fee"] = order.deliveryFee.toString();
  map["delivery_address_id"] = "0";
  map["Mesa"] = order.Mesa.toString();
  map["codigo_chat"] = '"0"';
  map["restaurant_id"] = order.restaurant_id.toString();
  map["tipo_orden"] = "comer aqui";
  String foods = "";
  for(int i = 0; i < order.foodOrders!.length; i++){
    foods = foods + order.foodOrders![i].toJson().toString();
    if((i+1) != order.foodOrders!.length){
      foods = "$foods|";
    }
  }
  map['foods'] = foods;
  map['device_token'] = global.token;
  print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  print(foods);
  print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  print(uri);


  print(map);
  final response = await client.post(
    uri,
    body: map
  );
  print("Crear orden =========================================================");
  print(response.body);
  if (response.statusCode == 200) {
    int respuesta = 0;
    try{
      respuesta = int.parse(jsonDecode(response.body)['data']['order_status_id'].toString());
      print("=====================================================================");
      //print(respuesta);
      return respuesta;
    }
    catch(e) {
      print("=====================================================================");
      print(e.toString());
      return 0;
    }
  }
  else {
    return 0;
  }
}
Future<List<Order>> obtenerOrdenes({intentos,required id_sesion})async {
  //getOrdersMesero/{id_restaurant}/{mesa}/{device_token}
  Uri uri = Uri.parse("${config.apiBaseUrl}ordenes/obtener_ordenes.php");
  print(uri);
  int cont = 0;
  http.Response? response;
  var map = <String, dynamic>{};
  map["restaurant_id"] = global.user.restaurante_id;
  map["device_token"] = global.token;
  map["sesion_id"] = id_sesion;
  while(cont < 3){
    response = await http.post(
      uri,
      body: map,
    );
    if(response.statusCode == 200) {
      break;
    }
    else{
      cont++;
      print("obtenerOrdenes intento $cont");
    }
  }
  print("=========== obtenerOrdenes =================");
  log(response!.body);
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Order>((json) => Order.fromJSON(json)).toList();
  } else {
    throw Exception('Failed to load body obtenerOrdenes repository');
  }
}