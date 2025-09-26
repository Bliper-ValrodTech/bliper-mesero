import 'package:bliper_mesero/src/models/food.dart';

class Cupon{
  Cupon();
  String? id;
  String? code;
  String? discount;
  String? discount_type;
  String? promocion;
  String? expires_at_fecha;
  String? cantidad_disponibles;
  String? ilimitado;
  // ignore: non_constant_identifier_names
  String? valid_day;
  String? enabled;
  String? client_deviceToken;
  List<Detalle>? detalle;
  // ignore: non_constant_identifier_names
  String? total_sin_descuento;
  String? total_con_descuento;

  Cupon.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap["id"];
      code = jsonMap["code"];
      discount = jsonMap["discount"];
      discount_type = jsonMap["discount_type"];
      promocion = jsonMap["promocion"];
      expires_at_fecha = jsonMap["expires_at_fecha"];
      cantidad_disponibles = jsonMap["cantidad_disponibles"];
      ilimitado = jsonMap["ilimitado"];
      valid_day = jsonMap["valid_day"];
      enabled = jsonMap["enabled"];
      detalle = jsonMap['detalle'] != null ? List.from(jsonMap['detalle']).map((element) => Detalle.fromJSON(element)).toList() : [];
      client_deviceToken = jsonMap["client_deviceToken"];
      total_sin_descuento = jsonMap["total_sin_descuento"];
      total_con_descuento = jsonMap["total_con_descuento"];
    }catch(e){
      print("Error cupon model");
      print(e.toString());
    }
  }
}

class Detalle{
  Detalle();
  String? id;
  String? food_id;
  String? cantidad;
  String? restaurant_id;
  String? category_id;
  String? cupon_id;
  Food? food;
  Detalle.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap["id"];
      food_id = jsonMap["food_id"];
      cantidad = jsonMap["cantidad"];
      restaurant_id = jsonMap["restaurant_id"];
      category_id = jsonMap["category_id"];
      cupon_id = jsonMap["cupon_id"];
      food = Food.fromJSON(jsonMap["food"]);
    }catch(e){
      print("Error cupon detalle model");
      print(e.toString());
    }
  }
}
/*class Cupon {
  String? success;
  String? descuento;
  String? porcentaje;
  String? arreglado;
  String? total_sinDescuento;
  String? total_conDescuento;
  String? tokenDevice;
  String? codigo;
  List<CuponDetalle>? cuponDetalle;
  Cupon();

  Cupon.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      descuento = jsonMap["descuento"].toString();
      porcentaje = jsonMap["porcentaje"].toString();
      arreglado = jsonMap["arreglado"].toString();
      total_sinDescuento = jsonMap["total_sinDescuento"].toString();
      total_conDescuento = jsonMap["total_conDescuento"].toString();
      cuponDetalle = List.from(jsonMap['productos']).map((element) => CuponDetalle.fromJSON(element)).toList();
    }
    catch(e){
      descuento = "";
      porcentaje = "";
      arreglado = "";
      total_sinDescuento = "";
      total_conDescuento = "";
      print("error en cupon, Cupon:");
      print(e.toString());
    }
  }
}

class CuponDetalle
{
  String? id;
  String? name;
  String? price;
  String? discount_price;
  String? description;
  String? ingredients;
  String? package_items_count;
  String? weight;
  String? featured;
  String? deliverable;
  String? restaurant_id;
  String? category_id;
  String? imagen_url;
  String? created_at;
  String? quantity;
  CuponDetalle();

  CuponDetalle.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap["id"].toString();
      name = jsonMap["name"].toString();
      price = jsonMap["price"].toString();
      discount_price = jsonMap["discount_price"].toString();
      description = jsonMap["description"].toString();
      ingredients = jsonMap["ingredients"].toString();
      package_items_count = jsonMap["package_items_count"].toString();
      weight = jsonMap["weight"].toString();
      featured = jsonMap["featured"].toString();
      deliverable = jsonMap["deliverable"].toString();
      restaurant_id = jsonMap["restaurant_id"].toString();
      category_id = jsonMap["category_id"].toString();
      imagen_url = jsonMap["imagen_url"].toString();
      created_at = jsonMap["created_at"].toString();
      quantity = jsonMap["cantidad"].toString();
    }
    catch(e)
    {
      id = "";
      name = "";
      price = "";
      discount_price = "";
      description = "";
      ingredients = "";
      package_items_count = "";
      weight = "";
      featured = "";
      deliverable = "";
      restaurant_id = "";
      category_id = "";
      imagen_url = "";
      created_at = "";
      quantity = "";
      print("error en cupon, CuponDetalle:");
      print(e.toString());
    }
  }
}
*/
