import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/global/global.dart' as global;
class Permissions{
  Permissions();

  bool camara = false;
  bool mic = false;
  bool notificar = false;

  Future<void> permisoMicrofono({required BuildContext context}) async{
    var statusMic = await Permission.microphone.request();
    if (statusMic != PermissionStatus.granted) {
      statusMic = await Permission.microphone.request();
      if(statusMic.isGranted){
        mic = true;
      }else{
        mic = false;
        global.snackBar(mensaje: "Porfavor dar permiso a la camara");
      }
    }else{
      mic = true;
    }
  }
  Future<void> permisoCamara({required BuildContext context}) async {
    var statusCamaera = await Permission.camera.request();
    if (statusCamaera != PermissionStatus.granted) {
      statusCamaera = await Permission.camera.request();
      if(statusCamaera.isGranted){
        camara = true;
      }else{
        camara = false;
        global.snackBar(mensaje: "Porfavor dar permiso a la camara");
      }
    }else{
      camara = true;
    }
  }
  Future<void> permisoNotificar({required BuildContext context}) async {
    var statusNotificar = await Permission.notification.request();
    if (statusNotificar != PermissionStatus.granted) {
      statusNotificar = await Permission.notification.request();
      if (statusNotificar.isGranted) {
        notificar = true;
      } else {
        notificar = false;
        global.snackBar(mensaje: "Porfavor dar permiso de notificacion");
      }
    } else {
      notificar = true;
    }
  }
}