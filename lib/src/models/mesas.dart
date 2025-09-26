class Mesas{
  Mesas();
  String? id;
  String? mesa_number;
  String? id_mesero;
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;
  Mesas.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap["id"];
      mesa_number = jsonMap["numero_mesa"];
      id_mesero = jsonMap["id_mesero"];
      created_at = jsonMap["created_at"];
      updated_at = jsonMap["updated_at"];
    }
    catch(e){
      id = "";
      mesa_number = "";
      id_mesero = "";
      created_at = "";
      updated_at = "";
      print("Error en Mesas Model");
    }
  }
}