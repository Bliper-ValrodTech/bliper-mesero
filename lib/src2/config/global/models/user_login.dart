class UserLogin {
  int id;
  String name;
  String email;
  String deviceToken;
  String phone;
  String address;
  String bio;
  String restauranteId;
  String restaurantName;
  String logo;
  String tcpPort;
  String usernameMqtt;
  String passwordMqtt;
  String broker;
  String orderId;
  String banner;
  String porcentajeIva;

  UserLogin({
    this.id = 0,
    this.name = "",
    this.email = "",
    this.deviceToken = "",
    this.phone = "",
    this.address = "",
    this.bio = "",
    this.restauranteId = "",
    this.restaurantName = "",
    this.logo = "",
    this.tcpPort = "",
    this.usernameMqtt = "",
    this.passwordMqtt = "",
    this.broker = "",
    this.orderId = "",
    this.banner = "",
    this.porcentajeIva = "",
  });

  factory UserLogin.fromJSON(Map<String, dynamic> json) {
    try {
      return UserLogin(
        id: int.tryParse(json['id_ud']?.toString() ?? "0") ?? 0,
        name: json['nombre'] ?? "",
        email: json['email'] ?? "",
        deviceToken: json['device_token'] ?? "",
        phone: json['phone'] ?? "",
        address: json['address'] ?? "",
        bio: json['bio'] ?? "",
        restauranteId: json['id_restaurante']?.toString() ?? "",
        restaurantName: json['restaurant_name'] ?? "",
        logo: json['logo'] ?? "",
        tcpPort: json['tcp_port']?.toString() ?? "",
        usernameMqtt: json['username_mqtt'] ?? "",
        passwordMqtt: json['password_mqtt'] ?? "",
        broker: json['broker'] ?? "",
        orderId: json['order_id']?.toString() ?? "",
        banner: json['banner'] ?? "",
        porcentajeIva: json['porcentaje_iva']?.toString() ?? "",
      );
    } catch (e) {
      print("Error en modelo UserLogin: $e");
      return UserLogin();
    }
  }
}