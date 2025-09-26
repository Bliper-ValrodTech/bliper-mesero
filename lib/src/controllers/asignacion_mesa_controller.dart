import 'package:bliper_mesero/src/repository/centros_repository.dart';
import 'package:state_extended/state_extended.dart';
import '../models/mesas.dart';
import '../controllers/global.dart' as global;

class AsignacionMesaController extends StateXController{
  List<Mesas> mesas = <Mesas>[];
  List<Mesas> misMesas = <Mesas>[];
  Future<void> obtenerMesas() async{
    mesas.clear();
    List<Mesas> aux = await obtener_Mesas();
    for(int i = 0; i < aux.length; i++){
      if(aux[i].id_mesero.toString() == global.user.id){
        mesas.add(aux[i]);
      }
    }
    setState(() {
      mesas;
    });
  }
}