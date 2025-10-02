class HttpsModel{
  int status = 0;
  bool success = false;
  String message = "";
  dynamic data = {};
  String error = "";
  String ubicacion = "";

  // 🔹 Constructor predeterminado (opcional si no necesitas inicializar)
  HttpsModel({
    this.status = 0,
    this.success = false,
    this.message = "",
    this.data = const {}, // Usar const {} para un mapa vacío inmutable por defecto
    this.error = "",
    this.ubicacion = "",
  });


  // 🔹 Factory para crear un objeto desde JSON
  factory HttpsModel.fromJson(Map<String, dynamic> json) {
    return HttpsModel(
      status: json['status'] as int? ?? 0, // Especificar el tipo esperado
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] ?? const {}, // Asegurar que data sea un Map si es nulo
      error: json['error'] as String? ?? '',
      ubicacion: json['ubicacion'] as String? ?? '', // Corregido: usar 'ubicacion'
    );
  }


  // 🔹 Metodo para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': data,
      'error': error,
      'ubicacion': ubicacion,
    };
  }
}