import 'package:bliper_mesero/servicio_notificacion.dart';
import 'package:bliper_mesero/src/controllers/permisos_controller.dart';
import 'package:bliper_mesero/src/controllers/routs_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bliper_mesero/src/models/notificaciones_ordenes.dart';
import '../models/notificaciones_chat.dart';
import '../models/sesiones_mesas.dart';
import '../models/user_login.dart';
import '../repository/login_repository.dart';
import '../repository/mesas_repository.dart';

// =================  instancias  ====================
ServicioNotificacion notificacion = ServicioNotificacion();
RoutsController paginas = RoutsController();
AudioPlayer player = AudioPlayer();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
FlutterTts flutterTts = FlutterTts();
late FirebaseMessaging firebaseMessaging;
PermisosController permisos = PermisosController();
UserLogin user = UserLogin();

// ================= notificadores ====================
ValueNotifier<bool> nuevoMensaje = ValueNotifier<bool>(true);
ValueNotifier<bool> ordenes = ValueNotifier<bool>(true);
ValueNotifier<bool> refresh = ValueNotifier<bool>(true);
ValueNotifier<bool> refresh_chat = ValueNotifier<bool>(true);
ValueNotifier<int> pageNoti = ValueNotifier<int>(0);

// ================= variables =======================
List<NotificacionesOrdenes> noti_ordenes = <NotificacionesOrdenes>[];
List<NotificacionesChat> noti_chat = <NotificacionesChat>[];
String pantalla = "";
String codigo = "";
bool inicioListener = false;
bool carrito = false;
get onDidReceiveLocalNotification => null;
String sesion = "";
int page = 0;
String mensajes_no_leidos = "0";
double volume = 1.0;
double pitch = 1.0;
double speechRate = 0.5;
var buttonColor = const Color.fromRGBO(45,204,211,1.0);
var bottomAppBarColor = const Color.fromRGBO(0, 31, 36, 1.0);
bool _intTts = false;
bool _initFirebase = false;
String token = "";

Future<void> cargando({required context}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
// =================  iniciar y cerrar sesion ========================
Future<void> cerrarSesion({required context}) async {
  cargando(context: context);
  final success = await logOut(deviceToken: user.deviceToken);
  if(success){
    if(_initFirebase){
      await deleteToken();
    }
    user = UserLogin();
    final token = await obtenerToken();
    Navigator.pop(context);
    paginas.loginRoute(context: context,devicetoken: token);
    snackBar(context: context, mensaje: "Sesión cerrada!");
  }else{
    Navigator.pop(context);
    snackBar(context: context, mensaje: "Error al cerrar sesión!");
  }
}
Future<void> setUser({required Map<String, dynamic> userLogin}) async{
  final Map<String, dynamic> parsed = userLogin;
  user = UserLogin.fromJSON(parsed);
}

// =================== iniciar =======================
Future<void> initFirebase() async{
  if(!_initFirebase){
    await notificacion.initNotificacion();
    firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(segundoPlano);
    FirebaseMessaging.onMessage.listen(primerPlano);
    _initFirebase = true;
  }
}
Future<void> initFlutterTts() async {
  await flutterTts.setVolume(volume);
  await flutterTts.setPitch(pitch);
  await flutterTts.setSpeechRate(speechRate);
  await flutterTts.setLanguage("es-MX");
  _intTts = true;
}

// ============= notificaciones =====================
void _speak({required String texto}) async {
  if(!_intTts){
    await initFlutterTts();
  }
  await flutterTts.speak(texto);
}
Future<void> agregar_notificacion_orden({required String mesa, required String id_orden}) async{
  print("se agrego notificacion");
  if(noti_ordenes.isEmpty){
    NotificacionesOrdenes nueva = NotificacionesOrdenes();
    nueva.contador = 1;
    nueva.mesa = mesa;
    nueva.id_ordenes = id_orden;
    noti_ordenes.add(nueva);
  }else{
    bool encontrado = false;
    for(int i = 0; i < noti_ordenes.length; i++){
      if(noti_ordenes[i].id_ordenes == id_orden){
        noti_ordenes[i].contador++;
        encontrado = true;
        break;
      }
    }
    if(encontrado == false){
      NotificacionesOrdenes nueva = NotificacionesOrdenes();
      nueva.contador = 1;
      nueva.mesa = mesa;
      nueva.id_ordenes = id_orden;
      noti_ordenes.add(nueva);
    }
  }
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  refresh.notifyListeners();
}
int mostrar_notificaciones_ordenes_todas() {
  int auxContador = 0;
  for(int i = 0; i < noti_ordenes.length; i++){
    auxContador = auxContador + noti_ordenes[i].contador;
  }
  print("mostrar_notificaciones_ordenes_todas $auxContador");
  return auxContador;
}
int mostrar_notificaciones_ordenes_mesas({required String mesa}) {
  int auxContador = 0;
  for(int i = 0; i < noti_ordenes.length; i++){
    if(noti_ordenes[i].mesa == mesa){
      auxContador = noti_ordenes[i].contador;
    }
  }
  return auxContador;
}
int mostrar_notificaiones_ordenes_orden({required String id_orden}) {
  int auxContador = 0;
  for(int i = 0; i < noti_ordenes.length; i++){
    if(noti_ordenes[i].id_ordenes == id_orden){
      auxContador = noti_ordenes[i].contador;
    }
  }
  return auxContador;
}
void quitar_notificaiones_mesa({required String mesa}) {
  for(int i = 0; i < noti_ordenes.length; i++){
    if(noti_ordenes[i].mesa == mesa){
      noti_ordenes.removeAt(i);
    }
  }
}
List<SesionesMesas> sesionesMesas = <SesionesMesas>[];
Future<void> obtener_mesas() async{
  sesionesMesas = await obtener_Sesiones();
  mostrar_notificaciones_mensajes();
}
void mostrar_notificaciones_mensajes() {
  int int_auxContador = 0;
  for(int i = 0; i < sesionesMesas.length; i++){
    int_auxContador = int_auxContador + int.parse(sesionesMesas[i].no_vistos.toString());
  }
  mensajes_no_leidos = int_auxContador.toString();
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  refresh_chat.notifyListeners();
}

void snackBar({required context, required String mensaje}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje,
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: StadiumBorder(),
    ),
  );
}

// ============== Firebase =============================
Future<String> obtenerToken() async {
  if(token.isNotEmpty){
    return token;
  }else{
    if(!_initFirebase){
      await initFirebase();
    }
    token = (await firebaseMessaging.getToken())!;
    return token;
  }
}
Future<void> deleteToken() async{
  await firebaseMessaging.deleteToken();
  token = "";
}
Future<void> primerPlano(RemoteMessage message)async{
  print("----------------------- ${message.notification?.title.toString().split(" ")[0]} ---------------------------");
  print("----------------------- ${message.notification?.title} ---------------------------");
  final notification = message.notification;
  if (notification != null) {
    String cuerpo = notification.body.toString();
    String json= '{';
    for(int i = 0; i < message.data.keys.toList().length; i++){
      json = '$json"${message.data.keys.toList()[i]}"';
      json = '$json:';
      // ignore: prefer_interpolation_to_compose_strings
      json = '$json"'+message.data.values.toList()[i]+'"';
      if((i+1) != message.data.keys.toList().length){
        json = '$json,';
      }
    }
    json += '}';
    print(message.data.keys.toList()[0]);
    if(message.data["type"] == "orden"){
      agregar_notificacion_orden(mesa: message.data["mesa"],id_orden: message.data["id_orden"]);
      print(message.data["lista"]);
      if(message.data["lista"] == "1"){
        _speak(texto: cuerpo);
      }
    }

    if(message.data["type"] == "cocina"){
      notificacion.showNotificacion(titulo: notification.title.toString(), body: notification.body);
      _speak(texto: cuerpo);
    }

    if(message.data["type"] == "chat"){
      if(player.playing)
      {
        player.stop();
      }
      player = AudioPlayer();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      nuevoMensaje.notifyListeners();
      player.setAsset("assets/audio/mesnajellegada.mp3",preload: true);
      player.play();
      obtener_mesas();
      if(sesion != message.data["codigoChat"]){
        print("============== ${notification.title.toString().split(" ")[0]} ====================");
        if(message.notification?.title.toString().split(" ")[0] != "Haz") {
          notificacion.showNotificacion(titulo: notification.title.toString(), body: cuerpo);
        }
      }
    }else{
      if(message.notification?.title.toString().split(" ")[0] != "Haz") {
        notificacion.showNotificacion(titulo: notification.title.toString(), body: cuerpo);
      }
    }

    if(message.data["type"] == "chat_centro"){
      if(player.playing)
      {
        player.stop();
      }
      player = AudioPlayer();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      nuevoMensaje.notifyListeners();
      player.setAsset("assets/audio/mesnajellegada.mp3",preload: true);
      player.play();
      obtener_mesas();
      if(sesion != message.data["codigoChat"]){
        if(message.notification?.title.toString().split(" ")[0] != "Haz") {
          notificacion.showNotificacion(titulo: notification.title.toString(), body: cuerpo);
          _speak(texto: cuerpo);
        }
      }
    }else{
      if(message.notification?.title.toString().split(" ")[0] != "Haz") {
        notificacion.showNotificacion(titulo: notification.title.toString(), body: cuerpo);
      }
    }
    if(message.data["type"] == "cocina"){
      _speak(texto: cuerpo);
    }
  }
}
@pragma('vm:entry-point')
Future<void> segundoPlano(RemoteMessage message)async{
  print("Handling a background message: ${message.messageId}");
  final notification = message.notification;
  String cuerpo = notification!.body.toString();
  if(message.data["type"] == "chat_centro"){
    _speak(texto: cuerpo);
  }
  if(message.data["type"] == "chat"){
    page = 2;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pageNoti.notifyListeners();
  }
  if(message.data["type"]  == "orden"){
    agregar_notificacion_orden(mesa: message.data["mesa"],id_orden: message.data["id_orden"]);
    page = 0;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pageNoti.notifyListeners();
    if(message.data["lista"] == "1"){
      _speak(texto: cuerpo);
    }
  }
}
