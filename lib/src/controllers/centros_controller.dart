import 'package:state_extended/state_extended.dart';

import '../models/centro_mesa.dart';
import '../models/mesas.dart';
import '../models/meseros.dart';
import '../repository/centros_repository.dart';

class CentrosControlller extends StateXController{
  CentrosControlller();
  List<Mesas> mesas = <Mesas>[];
  List<Centro_Mesa> centros = <Centro_Mesa>[];
  List<Meseros> meseros = <Meseros>[];
  Centro_Mesa? centro;
  Future<void> obtenerMesas() async{
    print("Entro obtenerMesas");
    mesas = await obtener_Mesas();
    setState(() {
      mesas;
      print(mesas.length);
    });
  }
  Future<void> obtenerCentros() async{
    print("Entro obtenerCentros");
    centros = await obtener_Centros();
    setState(() {
      centros;
      print(centros.length);
    });
  }
  Future<String> cambiarMesas({required String codigo,required String numero_mesa}) async{
    print("numero_mesa $numero_mesa");
    print("codigo $codigo");
    String respuesta = await cambiar_Mesas(codigo: codigo, numero_mesa: numero_mesa);
    return respuesta;
  }
  Future<void> obtenerMesero() async{
    meseros = await obtener_Meseros();
    setState(() {
      meseros;
    });
  }
  Future<String> cambiarMesero({required String mesero_id,required String codigo}) async{
    String respuesta = await cambiar_Mesero(mesero_id: mesero_id,codigo: codigo);
    return respuesta;
  }
  Future<void> obtenerCentroMesa({required String codigo}) async{
    centro = Centro_Mesa();
    centro = await obtener_CentroMesa(codigo: codigo);
  }
}