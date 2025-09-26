class Extras{
  Extras();
  String id = "";
  String food_id = "";
  String nombre = "";
  String precio = "";
  String cantidad = "0";
  Extras.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      food_id = jsonMap['food_id'].toString();
      nombre = jsonMap['nombre'].toString();
      precio = jsonMap['precio'].toString();
    } catch (e) {
      print("Error Extras model");
    }
  }

  Map<String, dynamic> toJson(){
    return {
      '"id"' : id,
      '"food_id"': food_id,
      '"nombre"': '"$nombre"',
      '"precio"': precio,
      '"cantidad"': '"$cantidad"',
    };
  }


  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["food_id"] = food_id;
    map["nombre"] = '"$nombre"';
    map["precio"] = precio;
    map["cantidad"] = cantidad;
    return map;
  }

  Extras.clone(Extras extra)
      : nombre = extra.nombre,
        precio = extra.precio,
        cantidad = extra.cantidad;
}