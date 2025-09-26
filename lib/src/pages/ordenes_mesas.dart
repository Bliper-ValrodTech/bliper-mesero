import 'package:bliper_mesero/src/elements/lista_ordenes.dart';
import 'package:bliper_mesero/src/models/order.dart';
import 'package:bliper_mesero/src/models/sesiones_mesas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/controllers/global.dart' as global;
import 'package:state_extended/state_extended.dart';
import '../controllers/ordenesmesa_controller.dart';
import 'chat_nuevo.dart';

class OrdenesMesasWidget extends StatefulWidget {
  final SesionesMesas sesion;
  final bool? entregadas;
  const OrdenesMesasWidget({this.entregadas, required this.sesion});

  @override
  _OrdenesMesasWidgetState createState() => _OrdenesMesasWidgetState();
}

class _OrdenesMesasWidgetState extends StateX<OrdenesMesasWidget> {
  late OrdenesMesasController con;
  _OrdenesMesasWidgetState() : super(controller: OrdenesMesasController()) {
    con = controller as OrdenesMesasController;
  }

  late ValueNotifier<bool> refreshWidget = ValueNotifier<bool>(true);

  Future<void> refresh_Widget() async{
    // ignore: invalid_use_of_protected_member
    if(!refreshWidget.hasListeners){
      refreshWidget = global.refresh;
      refreshWidget.addListener(() {
        setState(() {
          print("refresh_Widget");
        });
      });
    }
  }

  @override
  void initState() {
    print("============================");
    //print(widget.ordenes.length);
    print("============================");
    revisarOrdenes();
    con.obtener_ordenes(mesa: widget.sesion.mesa.toString(), id_sesion: widget.sesion.id.toString());
    global.ordenes.addListener(() {
      print("orden nueva");
      con.obtener_ordenes(mesa: widget.sesion.mesa.toString(), id_sesion: widget.sesion.id.toString());
    });
    refresh_Widget();
    super.initState();
  }
  List<Order> ordenes_mesa = <Order>[];
  void revisarOrdenes(){
    /*if(widget.entregadas == true){

    }else{
      print("Entro al revisarOrdenes");
      if(ordenesGlobales.ordenes != null){
        for(int i = 0; i < ordenesGlobales.ordenes!.length; i++)
        {
          if(widget.mesa == ordenesGlobales.ordenes![i].Mesa)
          {
            ordenes_mesa.add(ordenesGlobales.ordenes![i]);
          }
        }
      }
      ordenesGlobales.a.addListener(() {
        Future.delayed(Duration(seconds: 2),(){
          print("Entro al revisarOrdenes addListener");
          if(ordenesGlobales.ordenes != null){
            ordenes_mesa.clear();
            for(int i = 0; i < ordenesGlobales.ordenes!.length; i++)
            {
              if(widget.mesa == ordenesGlobales.ordenes![i].Mesa)
              {
                ordenes_mesa.add(ordenesGlobales.ordenes![i]);
              }
            }
          }
          setState(() {
            ordenesGlobales.ordenes;
            ordenes_mesa;
          });
        });
      });
    }*/
  }
  void salir(){
    global.quitar_notificaiones_mesa(mesa: widget.sesion.mesa.toString());
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    global.refresh.notifyListeners();
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/app/fondo_dark.jpg'),
              fit: BoxFit.fitWidth),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: (){
                salir();
              },
              child: const Icon(Icons.arrow_back),
            ),
            elevation: 0,
            centerTitle: true,
            title: Text(
              "ordenes".toUpperCase(),
              style: const TextStyle(
                fontFamily: 'alteHaasGrotesk',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(CupertinoIcons.rectangle_grid_1x2_fill,color: global.buttonColor),
                  child: const Text(
                    "Ordenes",
                    style: TextStyle(
                      fontFamily: 'alteHaasGrotesk',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Tab(
                  icon: Icon(CupertinoIcons.bolt_horizontal_circle_fill, color: global.buttonColor),
                  child: const Text(
                    "SuperChat",
                    style: TextStyle(
                      fontFamily: 'alteHaasGrotesk',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      widget.entregadas == true ?
                      ListsaOrdenesWidget(ordenes: ordenes_mesa, entregadas: true,) :
                      ListsaOrdenesWidget(ordenes: con.ordenes,),
                    ],
                  ),
                ),
              ),
              ChatNuevo(mesa: widget.sesion.mesa.toString(),id_restaurante: widget.sesion.id_restaurante.toString(),codigo: widget.sesion.codigo_chat.toString(),refresh: (value){}),
            ],
          ),
        ),
      ),
    ),
        onWillPop: () async{ salir(); return false;});
  }
}