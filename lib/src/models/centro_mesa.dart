import 'dart:core';

class Centro_Mesa{
  Centro_Mesa();
  String? id;
  String? mesa_number;
  String? qr;
  String? qr_name;
  String? business_id;
  String? business_name;
  String? mesero_id;
  String? mesero_name;
  String? code;
  String? verify;
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;

  Centro_Mesa.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      id = jsonMap['id'].toString();
      mesa_number = jsonMap['mesa_number'].toString();
      qr = jsonMap['qr'].toString();
      qr_name = jsonMap['qr_name'].toString();
      business_id = jsonMap['business_id'].toString();
      business_name = jsonMap['business_name'].toString();
      mesero_id = jsonMap['mesero_id'].toString();
      mesero_name = jsonMap['mesero_name'].toString();
      code = jsonMap['code'].toString();
      verify = jsonMap['verify'].toString();
      created_at = jsonMap['created_at'].toString();
      updated_at = jsonMap['updated_at'].toString();
    }catch(e){
      print(e);
      print("Error Centro_Mesa Modelo");
    }
  }
}