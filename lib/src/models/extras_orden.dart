class ExtrasOrden {
  ExtrasOrden();

  String id = "";
  String extra_id = "";
  String foodorder_id = "";
  String nombre = "";
  String precio = "";
  String cantidad = "0";
  String? create_at = "";

  ExtrasOrden.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      extra_id = jsonMap['extra_id'].toString();
      nombre = jsonMap['nombre'].toString();
      foodorder_id = jsonMap['foodorder_id'].toString();
      precio = jsonMap['precio'].toString();
      cantidad = jsonMap['cantidad'].toString();
      create_at = jsonMap['create_at'].toString();
    } catch (e) {
      print("Error Extras model");
    }
  }
}
