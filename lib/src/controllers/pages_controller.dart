import 'package:bliper_mesero/src/models/audios.dart';
import 'package:bliper_mesero/src/models/food.dart';
import 'package:bliper_mesero/src/models/mensajes.dart';
import 'package:bliper_mesero/src/models/order.dart';
import 'package:bliper_mesero/src/models/sesiones_mesas.dart';
import 'package:bliper_mesero/src/repository/audios_repository.dart';
import 'package:bliper_mesero/src/repository/menu_repository.dart';
import 'package:bliper_mesero/src/repository/orden_repository.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bliper_mesero/src/models/configuracion.dart' as config;
import 'package:bliper_mesero/src/models/ordenes_globales.dart' as ordenesGlobales;
import 'package:bliper_mesero/src/controllers/notificaciones_controller.dart' as noti;
import 'package:state_extended/state_extended.dart';
import '../models/notificaciones.dart';
import '../repository/mesas_repository.dart';
import '../controllers/global.dart' as global;

class PagesController extends StateXController{
  PagesController();
  List<Order> ordenes = <Order>[];
  List<Order> ordenesPendientes = <Order>[];
  List<Order> ordenesListas = <Order>[];
  List<Order> ordenesCanceladas = <Order>[];
  List<int> mesas = <int>[];
  List<int> mesasListas = <int>[];
  List<Food> food = <Food>[];
  String Broker = config.ip;
  int TCP_Port = 1883;

  List<Audio> Audios = <Audio>[];
  int? unreadAudios;
  String? deviceToken = global.token;
  bool sonar = true;
  List<String> chats = <String>[];
  List<bool> chatsAbiertos = <bool>[];
  bool llamadoMesero = false;
  int misma = 0;
  var player = AudioPlayer();
  List<SesionesMesas> sesionesMesas = <SesionesMesas>[];


  Future<void> getOrdenes(token,{intentos, required id_sesion}) async {
    ordenesPendientes.clear();
    ordenesListas.clear();
    ordenesCanceladas.clear();
    List<Order> ordenes2 = <Order>[];
    try{
      ordenes2 = await obtenerOrdenes(id_sesion: id_sesion);
    }catch(e)
    {
      print("error getOrdenes PagesController: $e");
    }
    finally{

    }
    if(ordenes != ordenes2)
    {

      mesas.clear();
      mesasListas.clear();
      for(int i = 0; i < ordenes2.length; i++)
      {
        bool encontrado = false;
        bool listasEncontrados = false;
        for(int m = 0; m < mesas.length; m++)
        {
          if(mesas[m] == ordenes2[i].Mesa)
          {
            encontrado = true;
          }
        }
        for(int m = 0; m < mesasListas.length; m++)
        {
          if(mesasListas[m] == ordenes2[i].Mesa)
          {
            listasEncontrados = true;
          }
        }
        if(listasEncontrados == false)
        {
          if(ordenes2[i].status.toString() == "Entregada" || ordenes2[i].status.toString() == "Pagada")
          {
            mesasListas.add(ordenes2[i].Mesa!);
          }
        }
        if(encontrado == false)
        {
          mesas.add(ordenes2[i].Mesa!);
        }
      }
      for(int i = 0; i < ordenes2.length; i++){
        if(ordenes2[i].status.toString() == "Entregada" || ordenes2[i].status.toString() == "Pagada"){
          print("Entregada orden #${ordenes2[i].id} ${ordenes2[i].status}");
          ordenesListas.add(ordenes2[i]);
        }
        else if(ordenes2[i].status.toString() == "Cancelada"){
          print("Cancelada orden #${ordenes2[i].id} ${ordenes2[i].status}");
          ordenesCanceladas.add(ordenes2[i]);
        }else{
          print("Pendientes orden #${ordenes2[i].id} ${ordenes2[i].status}");
          ordenesPendientes.add(ordenes2[i]);
        }
      }
      setState(() {
        ordenes = ordenes2;
        ordenesGlobales.ordenes = ordenesPendientes;
        ordenesGlobales.ordenesEntregadas = ordenesListas;
        ordenesGlobales.ordenesCanceladas = ordenesCanceladas;
        ordenesCanceladas;
        ordenesPendientes;
        //ordenesGlobales.ordenes = ordenes2;
        ordenesGlobales.a.setstate();
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        ordenesGlobales.a.notifyListeners();
        mesas;
        misma = 10;
      });
    }
  }
  Future<void> getMenu() async {
    try{
      food = await GetFoods();
    }catch(e)
    {
      print("error getMenu PagesController: $e");
    }
    finally{
      /*print("====================================");
      print("Length: "+ordenes.length.toString());
      for(int i = 0; i < ordenes.length; i++){
        print("Length: "+ordenes[i].foodOrders!.length.toString());
        for(int o = 0; o < ordenes[i].foodOrders!.length; o++){
          print("Nombre: "+ordenes[i].foodOrders![o].name.toString());
          print("thumb: ${ordenes[i].foodOrders?[o].food?.image?.thumb ?? "no hay"}");
        }
      }*/
      setState(() {ordenes;});
    }
  }
  Future<void> getAudios(numero_mesa, restaurant_id) async {
    print("Entro al getAudios");
    Audios = await GetAudios(numero_mesa, restaurant_id);
    try{
      setState(() {Audios;});
    }catch(e)
    {
      print("Error getAudios pages_controller: ");
      print(e.toString());
    }
    finally
        {
          getAudiosCount();
        }
  }
  Future<void> getAudiosCount() async {
    unreadAudios = 0;
    if(Audios.isNotEmpty)
    {
      Audios.forEach((element) {
        if(element.visto == "0")
        {
          setState(() {
            unreadAudios = unreadAudios!+1;
          });
        }
      });
    }
  }
  int chatsSize = 0;
  List<Mensajes> mensajes = <Mensajes>[];
  List<String> codigos = <String>[];
 /* Future<void> getMensajes({required String code}) async{
    if(!codigos.contains(code)){
      codigos.add(code);
      Stream<QuerySnapshot>  streamMensajes = FirebaseFirestore.instance.collection('Chat').doc("Sushiko").collection("code").orderBy("id",descending: false).snapshots();
      streamMensajes.listen((event) {
        try{
          if(event.docs.last.get("id_enviado").toString() != user.id.toString()){
            _showNotification(
                titulo: "Mesa ${event.docs.last.get("mesa")}",
                cuerpo: "${event.docs.last.get("nombre")}: ${event.docs.last.get("mensaje")}",
                payload: "Chat/$code"
            );
          }
        }catch(e){
          print(e);
        }

      });
    }
  }
  Future<void> getChats() async{
    streamChats!.listen((event) {
      print(event.docs.length);
      if(chatsSize < event.docs.length){
        if(player.playing)
        {
          player.stop();
        }
        player = AudioPlayer();
        player.setAsset("assets/audio/audio.mp3",preload: true);
        player.play();
        Vibration.vibrate(pattern: [0,500,250,500],intensities: [255]);
        _showNotification(
            titulo: "Super Chat",
            cuerpo: "Nuevo chat de la mesa ${event.docs.last.get("mesa")}",
            payload: "Chat/${event.docs.last.get("chat")}/${event.docs.last.get("mesa")}"
        );
        event.docs.forEach((element) {
          getMensajes(code: element.get("chat"));
        });
        chatsSize = event.docs.length;
      }
      else if(chatsSize > event.docs.length){
        chatsSize = event.docs.length;
      }
    });
  }
*/
  List<Notificaciones> notifi = <Notificaciones>[];
  GlobalKey key = GlobalKey();
  bool alerta = false;
  Future<void> agregarNotificacion({required String titulo,required String tipo, required String mensaje,required String pagina}) async{
    Notificaciones nueva = Notificaciones();
    nueva.titulo = titulo;
    nueva.mensaje = mensaje;
    nueva.tipo = tipo;
    nueva.fecha = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}";
    nueva.pagina = pagina;
    int ids = 0;
    if(notifi.isNotEmpty){
      bool encontrado = false;
      ids = int.parse(notifi.last.id.toString());
      ids++;
      nueva.id = ids.toString();
      for(int i = 0; i < notifi.length; i++){
        if(notifi[i].tipo == nueva.tipo){
          notifi[i] == nueva;
          encontrado = true;
        }
      }
      if(encontrado == false){
        notifi.add(nueva);
      }
    }
    else{
      ids = 1;
      nueva.id = ids.toString();
      notifi.add(nueva);
    }
    alerta = true;
    setState(() {
      notifi;
      noti.size = notifi.length;
      try{
        // ignore: invalid_use_of_protected_member
        key.currentState!.setState(() {
          notifi;
          noti.size = notifi.length;
        });
      }
      catch(e) {
        print(e.toString());
      }
    });
  }
  Future<void> eliminarNotificacion({required Notificaciones notif}) async {
    if(notifi.contains(notif)){
      for(int i = 0; i < notifi.length; i++){
        if(notifi[i].id.toString() == notif.id.toString()){
          notifi.removeAt(i);
        }
      }
      setState(() {
        notifi;
        noti.size = notifi.length;
        try{
          // ignore: invalid_use_of_protected_member
          key.currentState!.setState(() {
            notifi;
            noti.size = notifi.length;
          });
        }
        catch(e) {
          print(e.toString());
        }
      });
    }
  }
  Future<void> obtener_sesiones() async{
    sesionesMesas = await obtener_Sesiones();
    setState(() {
      sesionesMesas;
    });
  }
}