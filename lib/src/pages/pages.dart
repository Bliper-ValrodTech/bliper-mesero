import 'dart:async';
import 'package:bliper_mesero/src/controllers/pages_controller.dart';
import 'package:bliper_mesero/src/models/order.dart';
import 'package:bliper_mesero/src/pages/login.dart';
import 'package:bliper_mesero/src/pages/sesiones_chat.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../elements/navegacio.dart';
import 'asignacion_mesa.dart';
import 'home.dart';
import 'package:bliper_mesero/src/models/firebase_streams.dart' as firestreams;
import 'package:bliper_mesero/src/controllers/global.dart' as global;

class PagesWidget extends StatefulWidget with WidgetsBindingObserver{
  final int page;
  final String? deviceToken;
  const PagesWidget({Key? key, required this.page, this.deviceToken}) : super(key: key);

  @override
  _PagesWidgetState createState() => _PagesWidgetState();
}

class _PagesWidgetState extends StateX<PagesWidget> {
  late PagesController con;

  _PagesWidgetState() : super(controller: PagesController()) {
    con = controller as PagesController;
  }
  Widget? currentPage;
  bool showNav = false;
  int page = 1;

  void onSelectNotification() async{

  }
  get onDidReceiveLocalNotification => null;

 
  void change_page(int tabItem) {
    if(widget.page != 3)
      {
        if(firestreams.iniciado == false)
          {
            setState(() {
              firestreams.iniciado = true;
            });
            inciarTodo();
          }
      }
    switch (tabItem) {
      case 0 :
        if(con.misma != tabItem)
          {
            setState(() {
              currentPage = HomeWidget(
                sesionMesas: con.sesionesMesas,
                llamadoMesa: con.llamadoMesero,
                ordenes: con.ordenesPendientes,
                Mesas: con.mesas,
                onTapcCancelar: (value) {
                },
                atender: (value){
                  setState(() {
                    con.llamadoMesero = false;
                    con.misma = 10;
                  });
                },
              );
              tab=0;
              showNav = true;
              con.misma = tabItem;
            });
          }
        break;
      case 1:
        if(con.misma != tabItem)
          {
            setState(() {
              currentPage =  AsiganacionMesaWidget(
                food: con.food,
                onTapcCancelar: (value) {

                },
              );
              showNav = true;
              tab=1;
              con.misma = tabItem;
            });
          }
        break;
      case 2:
        if(con.misma != tabItem)
        {
          setState(() {
            currentPage = SesionesChatWidget();
            tab=2;
            showNav = true;
            con.misma = tabItem;
          });
        }
        break;
      case 3:
        setState(() {
          showNav = false;
          tab=3;
          currentPage = LoginWidget(
            deviceToken: widget.deviceToken,
          );
        });
        break;
    }
  }
  int? tab;
  void mostrarOrdenes() {
    if(tab ==1 )
    {
      change_page(1);
    }
    if(tab == 0)
    {
      change_page(0);
    }
    if(tab == 2)
      {
        change_page(2);
      }
    Future.delayed(const Duration(seconds: 3),(){
      mostrarOrdenes();
    });
  }
  @override
  initState() {
    con.deviceToken = widget.deviceToken;
    change_page(widget.page);
    con.getMenu();
    con.obtener_sesiones();
    mostrarOrdenes();
    refrescarApp();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  Future<void> refrescarApp() async{
    // ignore: invalid_use_of_protected_member
    if(!global.refresh.hasListeners){
      global.refresh.addListener(() {
        setState(() {
        });
      });
    }
    // ignore: invalid_use_of_protected_member
    if(!global.refresh_chat.hasListeners){
      global.refresh_chat.addListener(() {
        setState(() {
        });
      });
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Verifica el estado de la aplicación
    if (state == AppLifecycleState.paused) {
      // La aplicación está en segundo plano
      print("La aplicación está en segundo plano");
    } else if (state == AppLifecycleState.resumed) {
      // La aplicación está en primer plano
      print("La aplicación está en primer plano");

      Future.delayed(Duration(milliseconds: 100),(){
        setState(() {
          print("=============== se hizo el setState");
        });
      });

    }
  }
  String mensaje = "Nuevo";
  Future<void> inciarTodo() async {
    con.getMenu();
    mostrarOrdenes();
  }
  Future<void> ordenPagada(Order orden)async{
    return showDialog(
      context: context,
      builder: (context){
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  "¡La orden ${orden.id} ha sido pagada!"
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cerrar",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: showNav == false ? const SizedBox(height: 0,)
            :   NavegacionWidget(page: page,currentPage: (value) {
          change_page(value);
        },
        ),
        body:currentPage,
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }
}