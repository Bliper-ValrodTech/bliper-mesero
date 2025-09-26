class Chat{
  Chat();

  String? id;
  String? id_fecha;
  String? id_unico;
  String? id_enviado;
  String? mensaje;
  String? hora;
  String? tipo;
  String? mesa;
  String? rutaAudio;
  String? nombre;
  String? codigo_chat;
  String? id_restaurante;
  String? tipo_usuario;
  String? visto;
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;

  Chat.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap["id"];
      id_fecha = jsonMap["id_fecha"];
      id_unico = jsonMap["id_unico"];
      id_enviado = jsonMap["id_enviado"];
      mensaje = jsonMap["mensaje"];
      hora = jsonMap["hora"];
      tipo = jsonMap["tipo"];
      mesa = jsonMap["mesa"];
      rutaAudio = jsonMap["rutaAudio"];
      nombre = jsonMap["nombre"];
      codigo_chat = jsonMap["codigo_chat"];
      id_restaurante = jsonMap["id_restaurante"];
      visto = jsonMap["visto"].toString();
      created_at = jsonMap["created_at"];
      updated_at = jsonMap["updated_at"];
      tipo_usuario = jsonMap["tipo_usuario"];
    }catch(e){
      print("error en Chat models");
      print(e.toString());
    }
  }
}