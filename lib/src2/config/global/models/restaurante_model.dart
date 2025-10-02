class RestauranteModel {
  final int id;
  final String name;
  final String whatsapp;
  final String city;
  final String address;
  final String latitude;
  final String longitude;
  final String logoURL;
  final String bannerURL;
  final String btnGuardar;
  final String btnCancelar;
  final String btnAccion;
  final String colorFondo;

  // 🔹 Factory para crear un objeto desde JSON

  RestauranteModel({
    this.id = 0,
    this.name = "",
    this.whatsapp = "",
    this.city = "",
    this.address = "",
    this.latitude = "",
    this.longitude = "",
    this.logoURL = "",
    this.bannerURL = "",
    this.btnGuardar = "",
    this.btnCancelar = "",
    this.btnAccion = "",
    this.colorFondo = "",
  });
  factory RestauranteModel.fromJson(Map<String, dynamic> json) {
    return RestauranteModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      logoURL: json['logoURL'] ?? '',
      bannerURL: json['bannerURL'] ?? '',
      btnGuardar: json['btn_guardar'] ?? '',
      btnCancelar: json['btn_cancelar'] ?? '',
      btnAccion: json['btn_accion'] ?? '',
      colorFondo: json['color_fondo'] ?? '',
    );
  }

  // 🔹 Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'whatsapp': whatsapp,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'logoURL': logoURL,
      'bannerURL': bannerURL,
      'btn_guardar': btnGuardar,
      'btn_cancelar': btnCancelar,
      'btn_accion': btnAccion,
      'color_fondo': colorFondo,
    };
  }
}