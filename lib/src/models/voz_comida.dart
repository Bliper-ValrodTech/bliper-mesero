class VozComida {
  VozComida();
  String subtotal = "0.00";
  String total = "0.00";
  String iva = "0.00";
  String impuesto = "0.00";
  List<comida> comidas = [];

  VozComida.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      subtotal = jsonMap['subtotal'].toString();
      total = jsonMap['total'].toString();
      comidas = (jsonMap['foods'] as List)
          .map((item) => comida.fromJSON(item))
          .toList();
      iva = jsonMap['iva'].toString();
      impuesto = jsonMap['impuesto'].toString();
    } catch (e) {
      subtotal = '';
      total = '';
      comidas = [];
      print("error en VozComida modelo: $e");
    }
  }
}

class comida {
  String? id;
  String? name;
  double? price;
  String? discount_price;
  String? imagen_url;
  String? points;
  String? nota;
  String? cantidad;
  comida();

  comida.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      price = double.parse(jsonMap['price']);
      discount_price = jsonMap['discount_price'].toString();
      imagen_url = jsonMap['imagen_url'].toString();
      points = jsonMap['points'].toString();
      nota = jsonMap['nota'].toString();
      cantidad = jsonMap['cantidad'].toString();
    } catch (e) {
      id = '';
      name = '';
      price = 0.00;
      discount_price = '';
      imagen_url = '';
      points = '';
      print("error en comida modelo: $e");
    }
  }
}
