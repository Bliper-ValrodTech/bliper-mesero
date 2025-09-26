import 'package:state_extended/state_extended.dart';

import '../models/order.dart';
import '../repository/orden_repository.dart';
class OrdenesMesasController extends StateXController {
  OrdenesMesasController();

  List<Order> ordenes = <Order>[];
  Future<void> obtener_ordenes({required String mesa,required id_sesion}) async{
    ordenes.clear();
    List<Order> aux = await obtenerOrdenes(id_sesion: id_sesion);
    for(int i = 0; i < aux.length; i++){
      if(aux[i].Mesa.toString() == mesa){

        ordenes.add(aux[i]);
      }
    }
    setState(() {
      ordenes;
    });
  }
}