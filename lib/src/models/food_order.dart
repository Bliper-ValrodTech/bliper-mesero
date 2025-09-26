import 'package:bliper_mesero/src/models/extras_orden.dart';
import '../models/food.dart';

class FoodOrder {
  String? id;
  String? name;
  double? price;
  String? discount_price;
  String? description;
  String? affiliate_or_unaffiliate;
  String? ingredients;
  String? weight;
  String? unit;
  int? quantity;
  Food? food;
  DateTime? dateTime;
  String? nota;
  String? Fecha;
  DateTime? Hora;
  String? imagen_url;
  List<ExtrasOrden>? extras;

  FoodOrder();

  Map<String, dynamic> toJson(){
    return {
      '"id"' : '"$id"',
     '"name"' : '"$name"',
     '"price"' : price,
     '"discount_price"' : '"$discount_price"',
     '"description"' : '"$description"',
     '"affiliate_or_unaffiliate"' : '"$affiliate_or_unaffiliate"',
     '"ingredients"' : '"$ingredients"',
     '"weight"':'"$weight"',
     '"unit"': '"$unit"',
     '"quantity"':quantity,
     '"food"': food!.toJson(),
     '"nota"':'"$nota"',
     '"Fecha"': '"$Fecha"',
     '"imagen_url"':imagen_url,
    };
  }

  FoodOrder.fromJSON(Map<String, dynamic> jsonMap) {
    try {

      name = jsonMap['name'];
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? double.parse(jsonMap['price'].toString()) : 0.0;
      description = jsonMap["description"] == null ? "" :  jsonMap["description"] == "" ? "" : jsonMap["description"];
      if(jsonMap['nota'] == null || jsonMap['nota'] == 'null')
      {
        nota = '';
      }
      else
      {
        nota = jsonMap['nota'];
      }
      if(jsonMap['Fecha'] == null || jsonMap['Fecha'] == 'null')
      {
        Fecha = '';
      }
      else
      {
        Fecha = jsonMap['Fecha'];
      }
      extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => ExtrasOrden.fromJSON(element)).toList() : [];
      Fecha = jsonMap['Fecha'] == null ? '' : jsonMap['Fecha'] == 'null' ? '' : jsonMap['Fecha'];
      Hora = (jsonMap['created_at'] == null ? '' : jsonMap['created_at'] == 'null' ? null : DateTime.parse(jsonMap['created_at'])) as DateTime?;
      quantity = jsonMap['quantity'] != null ? int.parse(jsonMap['quantity'].toString()) : 0;
      food = jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : Food.fromJSON({});
      dateTime = DateTime.parse(jsonMap['created_at'].toString());
      imagen_url = jsonMap['imagen_url'] ?? "";
      // extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      price = 0.0;
      nota = '';
      Fecha ='';
      Hora = null;
      quantity = 0;
      food = Food.fromJSON({});
      imagen_url = "";
      // dateTime = DateTime(0);
      // extras = [];
      // print(CustomTrace(StackTrace.current, message: e));
      print("food_order error: $e");
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    if(nota != null && nota != '')
    {
      map["nota"] = nota;
    }
    map["fecha"] = Fecha;
    map["hora"] = Hora?.toIso8601String();
    map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;
    map["food_id"] = food?.id;
    // map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
