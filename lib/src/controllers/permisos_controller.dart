import 'package:permission_handler/permission_handler.dart';

class PermisosController{
  Future<void> permisoMicrofono() async{
    var statusMic = await Permission.microphone.request();
    if (statusMic != PermissionStatus.granted) {
      Permission.microphone.request();
    }
  }
  Future<void> permisoCamara() async {
    var statusCamaera = await Permission.camera.request();
    if (statusCamaera != PermissionStatus.granted) {
      Permission.camera.request();
    }
  }
  Future<void> permisoNotificar() async {
    var statusNotificar = await Permission.notification.request();
    if (statusNotificar != PermissionStatus.granted) {
      Permission.notification.request();
    }
  }
}