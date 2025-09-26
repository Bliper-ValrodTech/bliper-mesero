import 'dart:developer';
import 'dart:io';
import 'package:state_extended/state_extended.dart';
import '../models/chat.dart';
import '../repository/chat_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/configuracion.dart' as config;
import '../models/user_login.dart' as user;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../controllers/global.dart' as global;
class ChatController extends StateXController{

  ChatController();
  bool cargando_mensajes = true;
  TextEditingController tec = TextEditingController();
  GlobalKey record = GlobalKey();
  late AnimationController controllerAni;
  ScrollController? ScrollMensaje;
  List<Chat> Mensajes = <Chat>[];
  bool tiempo = true;
  bool aunAqui = true;
  String? Order_ID;
  List<Chat> mensajes = <Chat>[];
  String mensaje = "";
  String filepath = "";
  AudioRecorder r = AudioRecorder();
  String nombre = "";
  bool _obtenerMensajes = false;
  bool _mensajeNuevo = false;

  void init({required String codigo, required String mesa}) {
    ScrollMensaje = ScrollController();
    global.sesion = codigo;
    global.codigo = codigo;
    global.pantalla = "chat";
    mensajeNuevo(codigo: codigo,mesa: mesa);
    obtenerMensajes(codigo: codigo,mesa: mesa);
  }
  void mensajeNuevo({required String mesa, required String codigo}){
    if(!_mensajeNuevo){
      global.nuevoMensaje.addListener(() {
        setState(() {
          global.inicioListener = true;
          obtener_mensaje(chat_code: codigo,id_restaurante: global.user.restaurante_id ,mesa: mesa);
          print("=============================================================================");
          print("nuevo mensaje");
        });
      });
      _mensajeNuevo = true;
    }
  }
  void obtenerMensajes({required String codigo, required String mesa}) {
    if(!_obtenerMensajes){
      obtener_mensaje(chat_code: codigo, id_restaurante: global.user.restaurante_id, mesa: mesa.toString()).then((value){
        setState(() {
          cargando_mensajes = false;
        });
      });
      _obtenerMensajes = true;
    }
  }
  // ignore: non_constant_identifier_names
  Future<void> visto_llamnado({required String id, required String nombre,required String codigo}) async{
    Uri uri = Uri.parse("${config.apiBaseUrl}chat/mensaje_visto_audio_llamado.php");
    final client = http.Client();
    Map map = {};
    map["device_token"] = global.token;
    map["id_mensaje"] = id;
    map["codigo"] = codigo;

    final response = await client.post(
      uri,
      body: map,
    );
    print("=====================================================================");
    log(response.body);
    if(response.statusCode == 200){
      print("exito");
    }
  }
  Future<void> obtener_mensaje({required String id_restaurante,required String chat_code, required String mesa}) async{
    List<Chat> aux = await obtener_Mensaje(id_restaurante: id_restaurante,chat_code: chat_code,mesa: mesa);
    if(mensajes.isNotEmpty){
      for(int i = 0; i < aux.length; i++){
        bool encontrado = false;
        for(int b = 0; b < mensajes.length; b++){
          print("${mensajes[b].id_unico} == ${aux[i].id_unico} ${mensajes[b].id_unico.toString() == aux[i].id_unico.toString()}");
          if(mensajes[b].id_unico.toString() == aux[i].id_unico.toString()){
            mensajes[b] = aux[i];
            encontrado = true;
          }
        }
        if(encontrado == false){
          mensajes.add(aux[i]);
        }
      }
    }else{
      mensajes = aux;
    }
    setState(() {
      mensajes;
      scrollEnd();
    });
  }
  Future<void> guardar_mensaje({required String Mensaje, required String tipo, required String mesa, required String rutaAudio, required String codigo_chat, required String id_restaurante}) async{
    String mensaje = Mensaje;
    setState(() {
      mensaje.trim();
      if(mensaje != ""){
        Chat nuevo = Chat();
        nuevo.id_enviado = global.user.id;
        nuevo.mensaje = mensaje;
        nuevo.tipo = tipo;
        nuevo.mesa = mesa;
        nuevo.hora = "enviando";
        mensajes.add(nuevo);
        tec.text = "";
        scrollEnd();
      }
    });
    enviar_mensaje(index: mensajes.length,mensaje: mensaje, tipo: tipo,id_restaurante: id_restaurante, mesa: mesa,codigo_chat: codigo_chat,rutaAudio: rutaAudio);
  }
  Future<void> enviar_mensaje({required int index,required String mensaje, required String tipo, required String mesa, required String rutaAudio, required String codigo_chat, required String id_restaurante}) async{
    String id_unico = await hora_id();
    mensajes[index-1].id_unico = id_unico;
    await enviar_Mensaje(id_unico: id_unico,mensaje: mensaje, tipo: tipo, mesa: mesa, rutaAudio: rutaAudio, codigo_chat: codigo_chat, id_restaurante: id_restaurante);
    obtener_mensaje(id_restaurante: id_restaurante,chat_code: codigo_chat,mesa: mesa);
  }
  Future<void> scrollEnd() async {
    Future.delayed(const Duration(milliseconds: 50),(){
      try{
        if(ScrollMensaje!.hasClients){
          ScrollMensaje!.animateTo(
            ScrollMensaje!.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 200),
          );
        }
        else
        {
          print("==========================");
          print("no tiene cliente");
          print("==========================");
        }
      }catch(e){
        print("Error scrollEnd restaurante_controller");
        print(e.toString());
      }
    });
  }
  Future<String> hora_id() async {
    Uri uri = Uri.parse("https://www.bliper.com.mx/api/horaid.php");
    final client = http.Client();
    final response = await client.get(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if(response.statusCode == 200){
      print("exito");
      String id = response.body;
      return id;
    }else{
      return "error";
    }
  }
  Future<List<String>> stopSend({required hora,ordenId,mensajeId,required mesa,required String codigo, required String id_restaurante, required int id, required codigoChat}) async {
    await r.stop();
    File audio = File(filepath);
    int id = int.parse(await hora_id());
    List<String> respuesta = await guardar_audio(nombre: id.toString(),audio: audio.path,codigo_chat: codigoChat,id_restaurante: id_restaurante);
    return respuesta;
  }
  Future<void> startRecording() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      Permission.microphone.request();
    }
    else{
      nombre = DateTime.now().millisecondsSinceEpoch.toString();
      filepath = '${directory.path}/$nombre.acc';

      RecordConfig rc = RecordConfig(
        sampleRate: 44100,
        encoder: AudioEncoder.wav,
        bitRate: 128000
      );
      await r.start(
        rc,
        path: filepath, // required
      );
    }
  }
}