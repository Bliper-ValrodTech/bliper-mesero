import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../models/mesas.dart';
import '../models/meseros.dart';
import '../repository/mesas_repository.dart';
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import '../controllers/global.dart' as global;

class MesasController extends StateXController{
  MesasController();
  late BuildContext context;
  List<Mesas> mesas = <Mesas>[];
  List<Mesas> misMesas = <Mesas>[];
  List<Meseros> meseros = <Meseros>[];
  Future<void> obtener_mesas() async {
    mesas = await obtener_Mesas();
    for(int i = 0; i < mesas.length; i++){
      if(mesas[i].id_mesero == global.user.id){
        misMesas.add(mesas[i]);
      }
    }
    setState(() {
      mesas;
      misMesas;
    });
  }
  Future<void> obtener_meseros() async {
    List<Meseros> aux = await obtener_Meseros();
    for(int i = 0; i < aux.length; i++){
      //if(aux[i].id.toString() != user.id.toString()){
        meseros.add(aux[i]);
      //}
    }
    setState(() {
      meseros;
    });
  }
  Future<void> pasar_mesa({required String mesa, required String mesero}) async {
   String respuesta = await pasar_Mesa(mesa: mesa, mesero: mesero);
   Navigator.pop(context);
   return showDialog(
     context: context,
     builder: (context){
       return Scaffold(
         backgroundColor: Colors.transparent,
         body: SafeArea(
           child: SizedBox(
             width: MediaQuery.of(context).size.width,
             height: MediaQuery.of(context).size.height,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 ClipRRect(
                   borderRadius: BorderRadius.circular(15),
                   child: SizedBox(
                     width: MediaQuery.of(context).size.width*0.8,
                     height: 100,
                     child: ElevatedButton(
                       onPressed: (){
                         Navigator.of(context).pop();
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                         shadowColor: Colors.transparent,
                       ),
                       child: Center(
                         child: Text(
                           respuesta,
                           style: TextStyle(
                             fontFamily: 'alteHaasGrotesk',
                             fontWeight: FontWeight.bold,
                             color: global.buttonColor,
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
       );
     },
   );
  }
}