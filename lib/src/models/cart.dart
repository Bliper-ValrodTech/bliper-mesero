import '../models/food.dart';

class Cart {
  String? id;
  Food? food;
  int? quantity;
  //List<Extra> extras;
  String? userId;
  String? Fecha;
  DateTime? Hora;
  bool? Futuro;
  String? nota;
  int? id_restaurante;
  int? en_restaurante;
  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      nota = jsonMap['nota'] != null &&  jsonMap['nota'] != "" ?  jsonMap['nota'] : " ";
      Fecha = jsonMap['fecha'] != null && jsonMap['fecha'] != "" ?  jsonMap['fecha'] : " ";
      Hora = jsonMap['hora'] != null && jsonMap['hora'] != "" ?  DateTime(jsonMap['hora']) : null;
      quantity = jsonMap['quantity'] != null ? int.parse(jsonMap['quantity'].toString()) : 0;
      food = jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : Food.fromJSON({});
      //extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toList() : [];
      id_restaurante = jsonMap['id_restaurante'];
      en_restaurante = jsonMap['en_restaurante'];
    } catch (e) {
      id = '';
      nota = '';
      Fecha = '';
      Hora = null;
      quantity = 0;
      food = Food.fromJSON({});
      //extras = [];
      id_restaurante = 0;
      en_restaurante = 0;
      print("Error cart modelo $e");
      //print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["nota"] = nota != null && nota != "" ? nota : " ";
    map["fecha"] = Fecha;
    map["hora"] = Hora;
    map["quantity"] = quantity;
    map["food_id"] = food?.id;
    map["user_id"] = userId;
    //map["extras"] = extras.map((element) => element.id).toList();
    map["id_restaurante"] = id_restaurante;
    map["en_restaurante"] = en_restaurante;

    return map;
  }

  Cart.clone(Cart cart)
      : id = cart.id,
        nota = cart.nota,
        Fecha = cart.Fecha,
        Hora = cart.Hora,
        quantity = cart.quantity,
        food = cart.food,
        id_restaurante = cart.id_restaurante,
        en_restaurante = cart.en_restaurante;

}
