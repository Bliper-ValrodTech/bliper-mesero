import 'media.dart';

class Category {
  String id = "";
  String name = "";
  String description = "";
  String Todas = "";
  String imagen_url = "";
  bool seleccionado = false;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      name = jsonMap['name'];
      description = jsonMap['description'];
      Todas = jsonMap['Todas'];
      imagen_url = jsonMap['imagen_url'];
    } catch (e) {
      print("Error category modelo $e");
    }
  }
}
