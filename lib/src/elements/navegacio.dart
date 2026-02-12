import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/controllers/global.dart' as global;

class NavegacionWidget extends StatefulWidget {

  final int page;
  final ValueChanged<int>? currentPage;
  NavegacionWidget({required this.page, this.currentPage});

  _NavegacionWidgetState createState() => _NavegacionWidgetState();
}
class _NavegacionWidgetState extends State<NavegacionWidget>{
  double normal = 48;
  double seleccionado = 60;
  double normalIcono = 25;
  double seleccionadoIcono  = 35;
  late int page = 0;
  String noti_contador = "0";
  String auxContador = "0";
  @override
  void initState() {
    page = widget.page;
    notif();
    super.initState();
  }
  Future<void> notif() async{
    // ignore: invalid_use_of_protected_member
    if(global.pageNoti.hasListeners == false){
      global.pageNoti.addListener(() {
        setState((){
          page=global.page;
          widget.currentPage!(global.page);
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    //print(Theme.of(context).brightness);
   return Container(
       width: MediaQuery.of(context).size.width,
       height: 65,
       decoration: BoxDecoration(
        // borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight:Radius.circular(15)),
         color: global.bottomAppBarColor,
         boxShadow: [
           BoxShadow(
             color: global.buttonColor,
             spreadRadius: 5,
             blurRadius: 6,
             offset: const Offset(0, 3), // changes position of shadow
           ),
         ],
       ),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           SizedBox(
             height: seleccionado,
             width: seleccionado,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 GestureDetector(
                   onTap: (){
                     setState(() {
                       page = 0;
                     });
                     cambiarPage(0);
                   },
                   child: SizedBox(
                     child: Stack(
                       children: [
                         AnimatedContainer(
                           duration: const Duration(milliseconds: 200),
                           curve: Curves.easeIn,
                           height: page == 0 ? seleccionado : normal,
                           width: page == 0 ? seleccionado : normal,
                           decoration: BoxDecoration(
                               color: global.buttonColor,
                               shape: BoxShape.circle
                           ),
                           child: Center(
                             child: Icon(Icons.fastfood,size: page == 0 ? seleccionadoIcono : normalIcono,color: page == 0 ? Colors.white : Colors.black),
                           ),
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             global.mostrar_notificaciones_ordenes_todas().toString() != "0" ?
                             Container(
                               width: 25,
                               height: 25,
                               decoration: const BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.red,
                               ),
                               child: Center(
                                 child: Text(
                                   global.mostrar_notificaciones_ordenes_todas().toString(),
                                   style: const TextStyle(
                                     fontFamily: 'alteHaasGrotesk',
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                             ) : SizedBox(),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
           SizedBox(
             height: seleccionado,
             width: seleccionado,
             child: Stack(
               children: [
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           page = 1;
                         });
                         cambiarPage(1);
                       },
                       child: AnimatedContainer(
                         duration: const Duration(milliseconds: 200),
                         curve: Curves.easeIn,
                         height: page == 1 ? seleccionado : normal,
                         width: page == 1 ? seleccionado : normal,
                         decoration: BoxDecoration(
                             color: global.buttonColor,
                             shape: BoxShape.circle
                         ),
                         child: Center(
                           child: Icon(Icons.home,size: page == 1 ? seleccionadoIcono : normalIcono,color: page == 1 ? Colors.white : Colors.black),
                         ),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
           SizedBox(
             height: seleccionado,
             width: seleccionado,
             child: Stack(
               children: [
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           page = 2;
                         });
                         cambiarPage(2);
                       },
                       child: AnimatedContainer(
                         duration: const Duration(milliseconds: 200),
                         curve: Curves.easeIn,
                         height: page == 2 ? seleccionado : normal,
                         width: page == 2 ? seleccionado : normal,
                         decoration: BoxDecoration(
                             color: global.buttonColor,
                             shape: BoxShape.circle
                         ),
                         child: Center(
                           child: Icon(CupertinoIcons.bolt_horizontal_circle_fill,size: page == 2 ? seleccionadoIcono : normalIcono,color: page == 2 ? Colors.white : Colors.black),
                         ),
                       ),
                     ),
                   ],
                 ),
                 global.mensajes_no_leidos.toString() != "0" ?
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Container(
                       width: 25,
                       height: 25,
                       decoration: const BoxDecoration(
                         shape: BoxShape.circle,
                         color: Colors.red,
                       ),
                       child: Center(
                         child: Text(
                           global.mensajes_no_leidos.toString(),
                           style: const TextStyle(
                             fontFamily: 'alteHaasGrotesk',
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                     )
                   ],
                 ) : SizedBox(),
               ],
             ),
           ),
         ],
       ),
   );
  }
  void cambiarPage(int page)
  {
    setState(() {
      widget.currentPage!(page);
    });
  }
}

