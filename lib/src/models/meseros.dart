class Meseros{
  Meseros();
  String? id;
  String? name;
  String? device_token;

  Meseros.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap["id"];
      name = jsonMap["nombre"];
      device_token = jsonMap["device_token"];
    }
    catch(e){
      id = "";
      name = "";
      device_token = "";
      print("Error en Meseros Model");
    }
  }
}