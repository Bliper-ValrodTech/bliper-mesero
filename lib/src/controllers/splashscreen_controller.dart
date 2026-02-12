import 'dart:convert';

import 'package:state_extended/state_extended.dart';
import '../../src2/helpers/https/https.dart';
import '../controllers/global.dart' as global;

import '../../src2/config/global/global.dart' as global2;

class SplashScreenController extends StateXController{

  Future<void> permisosTodos() async{
    await global.permisos.permisoMicrofono();
    await global.permisos.permisoNotificar();
  }

  Future<void> init({required context}) async{
    await permisosTodos();
    global2.context = context;
    await global2.initFirebase();
    login_automatico(context);
  }
  Future<void> login_automatico(context) async{
    final token = await global2.obtenerToken();
    print(token);

    final respuesta = await post(endpoint: "login_automatico",body: {"deviceToken":token});

    if(respuesta.success){
      global2.setUser(userLogin: respuesta.data);
      global2.snackBar(mensaje: respuesta.message);
      global2.routs.navigationRoute(context: context);
    }else{
      global2.snackBar(mensaje: respuesta.message);
      global2.routs.loginRoute(devicetoken: token, context: context);
    }
  }
}