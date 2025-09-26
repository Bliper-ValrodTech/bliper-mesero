import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/mesas_controller.dart';
import '../controllers/global.dart' as global;
class MesasConfiguracion extends StatefulWidget{
  const MesasConfiguracion();
  @override
  _MesasConfiguracion createState() => _MesasConfiguracion();
}
class _MesasConfiguracion extends StateX<MesasConfiguracion>{
  late MesasController con;
  _MesasConfiguracion() : super(controller: MesasController()) {
    con = controller as MesasController;
  }

  @override
  void initState() {
    con.context = context;
    con.obtener_mesas();
    con.obtener_meseros();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Mesas",
                style: TextStyle(
                    fontFamily: 'alteHaasGrotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(CupertinoIcons.sidebar_left),
                    child: Text(
                      "Mis mesas",
                      style: TextStyle(
                          fontFamily: 'alteHaasGrotesk',
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Icon(CupertinoIcons.sidebar_left),
                    child: Text(
                      "Mesas",
                      style: TextStyle(
                        fontFamily: 'alteHaasGrotesk',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  child: con.misMesas.isEmpty ?
                      const Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(),
                        ),
                      ):
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(con.misMesas.length, (index){
                            return SizedBox(
                              width: MediaQuery.of(context).size.width*0.45,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ElevatedButton(
                                  onPressed: (){
                                    pasar_mesa(mesa: con.misMesas[index].mesa_number.toString());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: global.buttonColor,
                                    shape: RoundedRectangleBorder(),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Image.asset("assets/images/mesa.png",color: Theme.of(context).appBarTheme.backgroundColor,),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        con.misMesas[index].mesa_number.toString(),
                                        style:  TextStyle(
                                          fontFamily: 'alteHaasGrotesk',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Theme.of(context).appBarTheme.backgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  child: con.mesas.isEmpty ?
                  const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ):SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(con.mesas.length, (index){
                            return SizedBox(
                              width: MediaQuery.of(context).size.width*0.45,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ElevatedButton(
                                  onPressed: (){
                                    pedir_mesa(mesa: con.mesas[index].mesa_number.toString(),id_mesa: con.mesas[index].id.toString());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: con.mesas[index].id_mesero != global.user.id ?
                                    Theme.of(context).appBarTheme.backgroundColor : global.buttonColor,
                                    shape: RoundedRectangleBorder(),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Image.asset("assets/images/mesa.png",color: con.mesas[index].id_mesero == global.user.id ? Theme.of(context).appBarTheme.backgroundColor : global.buttonColor,),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        con.mesas[index].mesa_number.toString(),
                                        style: TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: con.mesas[index].id_mesero == global.user.id ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
    );
  }
  Future<void> pedir_mesa({required String mesa,required String id_mesa}) async{
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width*0.8,
                    //height: MediaQuery.of(context).size.height*0.2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Pedir la mesa #$mesa?",
                          style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                //mostrar_meseros(mesa: mesa);
                                cargar();
                                con.pasar_mesa(mesa: mesa, mesero: global.user.id).whenComplete((){
                                  Navigator.pop(context);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: global.buttonColor
                              ),
                              child: Center(
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).appBarTheme.backgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
  Future<void> pasar_mesa({required String mesa}) async{
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width*0.8,
                    //height: MediaQuery.of(context).size.height*0.2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Pasar la mesa #$mesa a otro mesero?",
                          style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                mostrar_meseros(mesa: mesa);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: global.buttonColor
                              ),
                              child: Center(
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).appBarTheme.backgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
  Future<void> mostrar_meseros({required String mesa}) async {
    Navigator.pop(context);
    return showDialog(
    context: context,
    builder: (context){
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: MediaQuery.of(context).size.height*0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Meseros",
                            style: TextStyle(
                              fontFamily: 'alteHaasGrotesk',
                              fontWeight: FontWeight.bold,
                              color: global.buttonColor,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(con.meseros.length, (index){
                              return Container(
                                width: MediaQuery.of(context).size.width*0.8/2-5,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).appBarTheme.backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: global.buttonColor,
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      cargar();
                                      con.pasar_mesa(mesa: mesa, mesero: con.meseros[index].id.toString());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.person_circle_fill, color: global.buttonColor, size: 70,),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.8/2-5,
                                          height: 80,
                                          child: Text(
                                            con.meseros[index].name.toString(),
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                              color: global.buttonColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                ),

              ),
            ],
          ),
        ),
      );
    });
  }
  Future<void> cargar(){
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}