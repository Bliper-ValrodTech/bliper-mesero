
class Audio{
  String? id;
  // ignore: non_constant_identifier_names
  String? user_id;
  String? numero_mesa;
  String? direccion_audio;
  String? hora_envio;
  String? visto;
  String? restaurant_id;

  Audio.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      user_id = jsonMap['user_id'];
      numero_mesa = jsonMap['numero_mesa'];
      direccion_audio = jsonMap['direccion_audio'];
      hora_envio = jsonMap['hora_envio'];
      visto = jsonMap['visto'];
      restaurant_id = jsonMap['restaurant_id'];
    } catch (e) {
      print("Error Audio Model: ");
      print(e.toString());
    }
  }
}