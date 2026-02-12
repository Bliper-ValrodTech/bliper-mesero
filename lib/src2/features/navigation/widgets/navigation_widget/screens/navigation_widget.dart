import 'package:bliper_mesero/src2/features/navigation/widgets/navigation_widget/controller/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../../../../../config/theme/theme.dart';

class NavigationWidget extends StatefulWidget {
  final int page;
  final ValueChanged<int>? currentPage;
  NavigationWidget({required this.page, this.currentPage});

  _NavigationWidgetState createState() => _NavigationWidgetState();
}
class _NavigationWidgetState extends StateX<NavigationWidget>{
  late NavigationController con;

  _NavigationWidgetState() : super(controller: NavigationController()) {
    con = controller as NavigationController;
  }

  @override
  void initState() {
    //notif();
    con.page = widget.page;
    super.initState();
  }
  /*Future<void> notif() async{
    // ignore: invalid_use_of_protected_member
    if(global.pageNoti.hasListeners == false){
      global.pageNoti.addListener(() {
        setState((){
          page=global.page;
          widget.currentPage!(global.page);
        });
      });
    }
  }*/
  @override
  Widget build(BuildContext context) {
    //print(Theme.of(context).brightness);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65,
      decoration: BoxDecoration(
        // borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight:Radius.circular(15)),
        color: cardBackground,
        boxShadow: [
          BoxShadow(
            color: colorBtnGuardar,
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
            height: con.seleccionado,
            width: con.seleccionado,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      con.page = 0;
                    });
                    cambiarPage(0);
                  },
                  child: SizedBox(
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          height: con.page == 0 ? con.seleccionado : con.normal,
                          width: con.page == 0 ? con.seleccionado : con.normal,
                          decoration: BoxDecoration(
                              color: colorBtnGuardar,
                              shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Icon(Icons.fastfood,size: con.page == 0 ? con.seleccionadoIcono : con.normalIcono,color: con.page == 0 ? Colors.white : Colors.black),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /*global.mostrar_notificaciones_ordenes_todas().toString() != "0"*/ true ?
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  "0",//global.mostrar_notificaciones_ordenes_todas().toString(),
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
            height: con.seleccionado,
            width: con.seleccionado,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          con.page = 1;
                        });
                        cambiarPage(1);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        height: con.page == 1 ? con.seleccionado : con.normal,
                        width: con.page == 1 ? con.seleccionado : con.normal,
                        decoration: BoxDecoration(
                            color: colorBtnGuardar,
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(Icons.home,size: con.page == 1 ? con.seleccionadoIcono : con.normalIcono,color: con.page == 1 ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: con.seleccionado,
            width: con.seleccionado,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          con.page = 2;
                        });
                        cambiarPage(2);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        height: con.page == 2 ? con.seleccionado : con.normal,
                        width: con.page == 2 ? con.seleccionado : con.normal,
                        decoration: BoxDecoration(
                            color: colorBtnGuardar,
                            shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(CupertinoIcons.bolt_horizontal_circle_fill,size: con.page == 2 ? con.seleccionadoIcono : con.normalIcono,color: con.page == 2 ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                /*global.mensajes_no_leidos.toString() != "0"*/ true ?
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
                          "0",//global.mensajes_no_leidos.toString(),
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