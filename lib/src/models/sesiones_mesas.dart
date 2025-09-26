class SesionesMesas{
  SesionesMesas();
  String? id;
  String? id_restaurante;
  String? mesa;
  String? codigo_chat;
  String? id_mesero;
  String? abierto;
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;
  String? no_vistos;

  SesionesMesas.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap["id"];
      id_restaurante = jsonMap["id_restaurante"];
      mesa = jsonMap["mesa"];
      codigo_chat = jsonMap["codigo_chat"];
      id_mesero = jsonMap["id_mesero"];
      abierto = jsonMap["abierto"];
      created_at = jsonMap["created_at"];
      updated_at = jsonMap["updated_at"];
      no_vistos = jsonMap["no_vistos"];
    }catch(e){
      print(e);
      print("error SessionesMesas models");
    }
  }
}