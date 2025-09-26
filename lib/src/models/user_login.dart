class UserLogin{
  UserLogin();
  String id = "";
  String name = "";
  String email = "";
  String deviceToken = "";
  String phone = "";
  String address = "";
  String bio = "";
  String restaurante_id = "";
  String restaurant_name = "";
  String logo = "";
  String tcp_port = "";
  String username_mqtt = "";
  String password_mqtt = "";
  String broker = "";
  String OrderID = "";
  String banner = "";
  String porcentaje_iva = "";

  UserLogin.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id_ud'] ?? '';
      name = jsonMap['nombre'] ?? '';
      email = jsonMap['email'] ?? '';
      deviceToken = jsonMap['device_token'] ?? '';
      phone = jsonMap['phone'] ?? '';
      address = jsonMap['address'] ?? '';
      bio = jsonMap['bio'] ?? '';
      restaurante_id = jsonMap['id_restaurante'] ?? '';
      restaurant_name = jsonMap['restaurant_name'] ?? '';
      logo = jsonMap['logo'] ?? '';
      tcp_port = jsonMap['tcp_port'] ?? '';
      username_mqtt = jsonMap['username_mqtt'] ?? '';
      password_mqtt = jsonMap['password_mqtt'] ?? '';
      broker = jsonMap['broker'] ?? '';
      banner = jsonMap['banner'] ?? '';
      porcentaje_iva = jsonMap['porcentaje_iva'] ?? '';
    } catch (e) {
      print("Error en modelo UserLogin: $e");
    }
  }
}