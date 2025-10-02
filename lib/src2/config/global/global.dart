import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../firebase_options.dart';
import '../../helpers/helpers.dart';
import '../config.dart';
import 'models/models.dart';

Permissions permisos = Permissions();
late FirebaseMessaging firebaseMessaging;
UserLogin user = UserLogin();
RestauranteModel restaurante = RestauranteModel();
Routs routs = Routs();
late BuildContext context;
bool _initFirebase = false;
String token = "";
var buttonColor = const Color.fromRGBO(45,204,211,1.0);

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
                      height: 100,
                      width: 100,
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
void snackBar({required String mensaje}){
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
Future<void> initFirebase() async{
  if(!_initFirebase){
    WidgetsFlutterBinding.ensureInitialized(); // necesario para async
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // tu archivo firebase_options.dart
    );
    firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getInitialMessage();
    //FirebaseMessaging.onBackgroundMessage(segundoPlano);
    //FirebaseMessaging.onMessage.listen(primerPlano);
    _initFirebase = true;
  }
}
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
Future<void> cerrarSesion({required context}) async {
  cargando(context: context);
  Map<String, dynamic>? body = {
    "deviceToken": user.deviceToken
  };
  final respuesta = await post(endpoint: "log_out",body: body);
  if(respuesta.success){
    if(_initFirebase){
      await deleteToken();
    }
    user = UserLogin();
    final token = await obtenerToken();
    Navigator.pop(context);
    routs.loginRoute(context: context,devicetoken: token);
    snackBar(mensaje: "Sesión cerrada!");
  }else{
    Navigator.pop(context);
    snackBar(mensaje: "Error al cerrar sesión!");
  }
}
Future<void> setUser({required Map<String, dynamic> userLogin}) async{
  final Map<String, dynamic> parsed = userLogin;
  user = UserLogin.fromJSON(parsed);
}
Future<void> setRestaurant({required Map<String, dynamic> restauranteModel}) async{
  final Map<String, dynamic> parsed = restauranteModel;
  restaurante = RestauranteModel.fromJson(parsed);
}