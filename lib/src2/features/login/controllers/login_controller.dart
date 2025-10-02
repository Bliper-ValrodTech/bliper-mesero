import 'package:flutter/cupertino.dart';
import 'package:state_extended/state_extended.dart';
import '../../../config/global/global.dart' as global;
import '../../../helpers/helpers.dart';
import '../../../helpers/https/models/https_model.dart';
import '../models/models.dart';

class LoginController extends StateXController{
  LoginController();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool visible = true;
  double opacidad = 0.0;
  String error = "";
  bool obscurePassword = true;
  final formKey = GlobalKey<FormState>();


  void trySubmit(dynamic widget,BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      print("se preciono");
      userController.text.trim();
      passController.text.trim();
      login(context: context);
    }
  }

  Future<void> login({required BuildContext context}) async {
    global.cargando(context: context);

    var body = LoginModel(deviceToken: global.token, usuario: userController.text, password: passController.text).toMap();

    HttpsModel respuesta = await post(endpoint: "login",body: body);
    print(body);
    print(respuesta.success);
    print(respuesta.message);
    if(respuesta.success){
      global.setUser(userLogin: respuesta.data);
      respuesta = await post(endpoint: "obtener_restaurante",body: body);
      if(respuesta.success){
        print(respuesta.data);
        global.setRestaurant(restauranteModel: respuesta.data);
        global.routs.homeRoute(context: context);
      }else{
        global.snackBar(mensaje: respuesta.message);
        errorLogin(mensaje: respuesta.message);
      }
    }else{
      errorLogin(mensaje: respuesta.message);
    }
  }

  void errorLogin({required String mensaje}){
    setState((){
      visible = true;
      opacidad = 1.0;
      error = mensaje;
    });
  }
}