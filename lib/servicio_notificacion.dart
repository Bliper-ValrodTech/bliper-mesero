import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

class ServicioNotificacion{
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotificacion() async{
    if(_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await notificationPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  NotificationDetails notificacionDetalles(){
    Vibration.vibrate(duration: 500,repeat: 2);
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "canal_diario_id",
        "notificacion_diaria",
        importance: Importance.max,
        priority: Priority.max,
        icon: "@mipmap/ic_launcher",
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotificacion({int id = 0, String? titulo, String? body}) async{
    return notificationPlugin.show(id, titulo, body, notificacionDetalles());
  }
}