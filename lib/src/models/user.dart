import '../models/media.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? apiToken;
  String? deviceToken;
  String? phone;
  String? address;
  String? bio;
  Media? image;
  String? restaurante_id;


  // used for indicate if client logged in or not
  bool? auth;

//  String role;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] ?? '';
      email = jsonMap['email'] ?? '';
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      restaurante_id =jsonMap['restaurante_id'];
      try {
        phone = jsonMap['custom_fields']['phone']['view'];
      } catch (e) {
        phone = "";
      }
      try {
        address = jsonMap['custom_fields']['address']['view'];
      } catch (e) {
        address = "";
      }
      try {
        bio = jsonMap['custom_fields']['bio']['view'];
      } catch (e) {
        bio = "";
      }
      image = jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty ? Media.fromJSON(jsonMap['media'][0]) : Media();
    } catch (e) {
      print("Error en user modelo: $e");
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["restaurante_id"] =restaurante_id;
    map["password"] = password;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone"] = phone;
    map["address"] = address;
    map["bio"] = bio;
    map["media"] = image?.toMap();
    return map;
  }

  @override
  String toString() {
    var map = toMap();
    map["auth"] = auth;
    return map.toString();
  }

  bool profileCompleted() {
    return address != null && address != '' && phone != null && phone != '';
  }
}
