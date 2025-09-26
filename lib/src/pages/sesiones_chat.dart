import 'dart:ui';
import 'package:bliper_mesero/src/controllers/sesiones_controller.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/controllers/global.dart' as global;
import 'package:state_extended/state_extended.dart';
import '../elements/side_menu.dart';
import 'chat_nuevo.dart';

class SesionesChatWidget extends StatefulWidget{
  SesionesChatWidget();
  @override
  _SesionesChatWidgetState createState() => _SesionesChatWidgetState();
}
class _SesionesChatWidgetState extends StateX<SesionesChatWidget> {
  late SesionesController con;

  _SesionesChatWidgetState() : super(controller: SesionesController()) {
    con = controller as SesionesController;
  }

  @override
  void initState() {
    con.obtener_mesas();
    global.nuevoMensaje.addListener(messageListeners);
    super.initState();
  }

  void messageListeners() {
    setState(() {
      print("llego un mensaje sesion _chat");
      con.obtener_mesas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/app/fondo_dark.jpg'),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: NavDrawer(
          onTapcCancelar: (value) {
            if (value == 1) {
              //widget.onTapcCancelar(value);
            }
          },
        ),
        appBar: AppBar(
          title: Text(
            "SuperChat".toUpperCase(),
            style: const TextStyle(
              fontFamily: 'alteHaasGrotesk',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: List.generate(con.sesionesMesas.length, (index){
                return SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width*0.43,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: global.buttonColor.withOpacity(0.7),
                     child: ElevatedButton(
                       onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatNuevo(
                           mesa: con.sesionesMesas[index].mesa.toString(),
                           codigo: con.sesionesMesas[index].codigo_chat.toString(),
                           id_restaurante: con.sesionesMesas[index].id_restaurante.toString(),
                           ordenes: true,
                           refresh: (value){
                             con.obtener_mesas();
                           },
                         )));
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.transparent,//global.buttonColor.withOpacity(0.7),
                         shadowColor: Colors.transparent,
                         padding: const EdgeInsets.all(0),
                       ),
                       child: Stack(
                         children: [
                           Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Container(
                                 height: 120,
                                 width: MediaQuery.of(context).size.width*0.42,
                                 decoration: BoxDecoration(
                                   color: global.buttonColor,
                                   shape: BoxShape.circle,
                                 ),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text(
                                       con.sesionesMesas[index].mesa.toString(),
                                       style: TextStyle(
                                         fontFamily: 'alteHaasGrotesk',
                                         fontWeight: FontWeight.bold,
                                         fontSize: 20,
                                         color: Theme.of(context).appBarTheme.backgroundColor,
                                       ),
                                     ),
                                     const SizedBox(height: 10),
                                     Text(
                                       "Mesa",
                                       style: TextStyle(
                                         fontFamily: 'alteHaasGrotesk',
                                         fontWeight: FontWeight.bold,
                                         fontSize: 20,
                                         color: Theme.of(context).appBarTheme.backgroundColor,
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ],
                           ),

                           con.sesionesMesas[index].no_vistos.toString() != "0" ?
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               Container(
                                 width: 30,
                                 height: 30,
                                 margin: const EdgeInsets.all(5),
                                 decoration: const BoxDecoration(
                                   color: Colors.red,
                                   shape: BoxShape.circle,
                                 ),
                                 alignment: Alignment.center,
                                 child: Text(
                                   con.sesionesMesas[index].no_vistos.toString(),
                                 ),
                               ),
                             ],
                           ) : const SizedBox(),
                         ],
                       ),
                     ),
                    ),

                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
