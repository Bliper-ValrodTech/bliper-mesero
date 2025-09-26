import 'dart:convert';

import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../repository/login_repository.dart';

class SplashScreenController extends StateXController{

  Future<void> permisosTodos() async{
    await global.permisos.permisoMicrofono();
    await global.permisos.permisoNotificar();
  }

  Future<void> init({required context}) async{
    await permisosTodos();
    await global.initFirebase();
    login(context);
  }
  Future<void> login(context) async{
    final token = await global.obtenerToken();
    final respuesta = await login_automatico(deviceToken: token);
    final jsonData = jsonDecode(respuesta);
    if(jsonData["success"]){
      print("login exitoso");
      global.setUser(userLogin: jsonData["data"]);
      global.paginas.pagesRoute(page: 1, context: context, deviceToken: token);
    }else{
      print("login fallido");
      global.paginas.loginRoute(devicetoken: token,context: context);
    }
  }
}