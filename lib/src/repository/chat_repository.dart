import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../models/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/configuracion.dart' as config;
import '../controllers/global.dart' as global;

Future<void> popupError(String error,context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.red,
        child: Container(
          margin: const EdgeInsets.all(50),
          child: Text(
              error,
            style: Theme.of(context).textTheme.labelMedium!.merge(const TextStyle(fontSize: 20)),
          ),
        ),
      );
    },
  );
}

Future<void> sendMensajeAudio({Remitente_ID,Orden_ID,Restaurante_ID,tipo,Mensaje,Audio}) async {
  Uri uri =  Uri.parse('${config.apiBaseUrl}mensajeChat/${global.user.id}/$Orden_ID/$Restaurante_ID/$tipo/audio');
  print(uri);
  try
  {
    var request = http.MultipartRequest('post', uri);
    request.files.add(
        http.MultipartFile(
            'Audio',
            File(Audio).readAsBytes().asStream(),
            File(Audio).lengthSync(),
            filename: Audio.split("/").last
        )
    );
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    print(respStr);
  }catch(e)
  {
    print("Error sendMensajeAudio repository $e");
  }
}
Future<List<Chat>> obtener_Mensaje({required String chat_code, required String id_restaurante,required String mesa}) async{
  try{
    Uri uri = Uri.parse("${config.apiBaseUrl}chat/obtener_chat.php");
    print(uri);
    Map map = {};
    map["device_token"] = global.token;
    map["chat_code"] = chat_code;
    map["id_restaurante"] = id_restaurante;
    map["mesa"] = mesa;
    print(chat_code);
    final response = await http.post(
      uri,
      body: map,
    );
    log(jsonDecode(response.body).toString());
    if(jsonDecode(response.body)["success"] == "true"){
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      return parsed.map<Chat>((json) => Chat.fromJSON(json)).toList();
    }
    else{
      List<Chat> chat =<Chat>[];
      Chat aux = Chat();
      aux.id = "0";
      chat.add(aux);
      return chat;
    }
  }catch(e){
    print("Error obtener_Mensaje Chat_repository");
    print(e.toString());
    List<Chat> chat =<Chat>[];
    Chat aux = Chat();
    aux.id = "0";
    chat.add(aux);
    return chat;
  }

}

Future<bool> enviar_Mensaje({required String id_unico,required String mensaje, required String tipo, required String mesa, required String rutaAudio, required String codigo_chat, required String id_restaurante}) async{
  try{
    Uri uri = Uri.parse("${config.apiBaseUrl}chat/chatMySQL.php");
    print(uri);
    Map map = {};
    map["device_token"] = global.token;
    map["id_enviado"] = global.user.id;
    map["mensaje"] = mensaje;
    map["tipo"] = tipo;
    map["mesa"] = mesa;
    map["rutaAudio"] = rutaAudio;
    map["nombre"] = global.user.name;
    map["codigo_chat"] = codigo_chat;
    map["id_restaurante"] = id_restaurante;
    map["id_unico"] = id_unico;
    final response = await http.post(
      uri,
      body: map,
    );
    log(jsonDecode(response.body).toString());
    if(jsonDecode(response.body)["success"] == "true"){
      return true;
    }
    else{
      return false;
    }
  }catch(e){
    return false;
  }
}
Future<List<String>> guardar_audio({required String nombre,required String audio, required String codigo_chat, required String id_restaurante}) async{
  try{
    Uri uri = Uri.parse("${config.apiBaseUrl}chat/guardar_audio.php");

    var request = http.MultipartRequest('POST', uri);
    request.files.add(
        http.MultipartFile(
            'Audio',
            File(audio).readAsBytes().asStream(),
            File(audio).lengthSync(),
            filename: "$nombre.acc"
        )
    );
    print(uri);
    Map<String, String> map = {};
    map["device_token"] = global.token;
    map["codigo_chat"] = codigo_chat;
    map["id_restaurante"] = global.user.restaurante_id;
    request.fields.addAll(map);
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    log("$respStr  Audio");

    if(jsonDecode(respStr)["success"] == "true"){
      return ["true", jsonDecode(respStr)["data"]];
    }
    else{
      return ["false", jsonDecode(respStr)["message"]];
    }
  }catch(e){
    return ["false", e.toString()];
  }
}