import 'package:bliper_mesero/src/models/order.dart';
import 'package:bliper_mesero/src/repository/orden_repository.dart';
import 'package:state_extended/state_extended.dart';
import '../models/sesiones_mesas.dart';
import '../repository/mesas_repository.dart';

class HomeController extends StateXController{
  HomeController();
  List<Order> ordenes = <Order>[];
  List<SesionesMesas> sesionesMesas = <SesionesMesas>[];

  Future<void> getOrdenes({required id_sesion}) async {
    try{
      ordenes = await obtenerOrdenes(id_sesion: id_sesion);
    }catch(e)
    {
      print("error HomeController: $e");
    }
    finally{
      setState(() {ordenes;});
    }
  }
  Future<void> obtener_sesiones() async{
    sesionesMesas = await obtener_Sesiones();
    setState(() {
      sesionesMesas;
    });
  }
}