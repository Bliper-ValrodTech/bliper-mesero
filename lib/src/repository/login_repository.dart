import 'dart:convert';
import 'dart:developer';
import 'package:bliper_mesero/src/models/configuracion.dart' as config;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import 'package:bliper_mesero/src/controllers/global.dart' as global;

Future<String> login_automatico({required String deviceToken}) async {
    http.Response? response;
    var map = <String, dynamic>{};
    map['device_token'] = deviceToken;
    map['tipo_user'] = "2";
    response = await http.post(
        Uri.parse('${config.apiBaseUrl}login/login_automatico.php'),
        body: map
    );
    if(response.statusCode == 200){
      return response.body;
    }else{
      return '{"success":false}';
    }
}
Future<String> loginRepo({required String usuario,required String password,required String deviceToken,required context}) async {
  var map = <String, dynamic>{};
  map['user'] = usuario.trim();
  map['password'] = password.trim();
  map['device_token'] = deviceToken;
  map['tipo_user'] = "2";

  final response = await http.post(
      Uri.parse('${config.apiBaseUrl}login/mesero_login.php'),
      body: map
  );
  if(response.statusCode == 200){
    return response.body;
  }else{
    return '{"success":false}';
  }
}
Future<bool> logOut({required String deviceToken}) async {
  var map = <String, dynamic>{};
  map['device_token'] = deviceToken;
  final response = await http.post(
      Uri.parse('${config.apiBaseUrl}login/logout.php'),
      body: map
  );
  if(response.statusCode == 200){
    return jsonDecode(response.body)["success"];
  }else{
    return false;
  }
}