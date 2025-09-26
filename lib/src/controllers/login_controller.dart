import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../repository/login_repository.dart';

class LoginController extends StateXController{

  String password = "";
  String usuario = "";
  bool visible = true;
  double opacidad = 0.0;
  String error = "";
  
  Future<void> login({required BuildContext context}) async {
    global.cargando(context: context);
    final respuesta = await loginRepo(deviceToken: global.token, password: password, usuario: usuario, context: context);
    if(respuesta == false){
      errorLogin(context: context);
    }else{
      final jsonData = jsonDecode(respuesta);
      bool pass = jsonData['success'];
      if(pass){
        await global.setUser(userLogin: jsonData["data"]);
        Navigator.pop(context);
        global.paginas.pagesRoute(page: 1, context: context, deviceToken: global.token);
      }else{
        errorLogin(context: context);
      }
    }
  }
  void errorLogin({required BuildContext context}){
    Navigator.pop(context);
    global.snackBar(context: context, mensaje: "Error al iniciar sesión!");
  }
}