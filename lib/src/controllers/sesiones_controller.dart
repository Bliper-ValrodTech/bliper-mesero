import 'package:state_extended/state_extended.dart';

import '../models/sesiones_mesas.dart';
import '../repository/mesas_repository.dart';

class SesionesController extends StateXController{
  SesionesController();

  List<SesionesMesas> sesionesMesas = <SesionesMesas>[];

  Future<void> obtener_mesas() async{
    sesionesMesas = await obtener_Sesiones();
    setState(() {
      sesionesMesas;
    });
  }
}