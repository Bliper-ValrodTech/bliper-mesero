import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../controllers/centros_controller.dart';

class ConfigurarCentros extends StatefulWidget {
  final String code;
  final String mesa;
  final String nombre_mesero;
  final String id_mesero;
  final ValueChanged<int> Notificar;
  ConfigurarCentros({required this.code,required this.mesa,required this.nombre_mesero,required this.id_mesero,required this.Notificar});

  @override
  _ConfigurarCentrosState createState() => _ConfigurarCentrosState();
}

class _ConfigurarCentrosState extends StateX<ConfigurarCentros> {
  late CentrosControlller con;

  _ConfigurarCentrosState() : super(controller: CentrosControlller()) {
    con = controller as CentrosControlller;
  }

  int count = 0;
  int width = 135;
  int height = 160;

  String finalMesa = "";
  String finalMesero = "";
  @override
  void initState() {
    finalMesa = widget.mesa;
    finalMesero = widget.nombre_mesero;
    con.obtenerMesas();
    con.obtenerMesero();
    if(finalMesero == ""){
      finalMesero = "Libre";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).orientation == Orientation.landscape)
    {
      double width=MediaQuery.of(context).size.width;
      int widthCard= this.width+40;
      int countRow=width~/widthCard;
      count = countRow;
    }
    else
    {
      double width=MediaQuery.of(context).size.width;
      int widthCard= this.width;
      int countRow=width~/widthCard;
      count = countRow;
    }
    return WillPopScope(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Configuracion Centro Mesa",
            style: TextStyle(
              fontFamily: 'alteHaasGrotesk',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Seleccionar mesa",icon: Icon(CupertinoIcons.sidebar_left)),
              Tab(text: "Seleccionar mesero",icon: Icon(CupertinoIcons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/app/centro_mesa.png"),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  finalMesa == "" || finalMesa == "0"
                                      ? ""
                                      : finalMesa.toString(),
                                  style: TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    color: global.buttonColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        width: 200,
                        padding: const EdgeInsets.only(left: 2,right: 2),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topRight: Radius.circular(15)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.code,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  con.mesas.isEmpty
                      ? Center(
                      child: Stack(
                        children: [
                          const Center(
                            child:SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/app/centro_mesa.png",color: global.buttonColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  )
                      : GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    crossAxisCount: count,
                    childAspectRatio: (width / height),
                    scrollDirection: Axis.vertical,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    primary: false,
                    shrinkWrap: true,
                    children: List.generate(con.mesas.length, (index){
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: finalMesa ==con.mesas[index].mesa_number
                                ? global.buttonColor
                                : Theme.of(context).primaryColor
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                                width: 100,
                                height: 100,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            "assets/images/mesa.png",
                                            color: finalMesa !=con.mesas[index].mesa_number
                                                ? global.buttonColor
                                                : Theme.of(context).primaryColor
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            con.mesas[index].mesa_number.toString(),
                                            style: TextStyle(
                                                fontFamily: 'alteHaasGrotesk',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: finalMesa !=con.mesas[index].mesa_number
                                                    ? global.buttonColor
                                                    : Theme.of(context).primaryColor
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Mesa ${con.mesas[index].mesa_number}",
                                    style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        color: finalMesa !=con.mesas[index].mesa_number
                                            ? global.buttonColor
                                            : Theme.of(context).primaryColor
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  finalMesa !=con.mesas[index].mesa_number
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          preguntarCambiarMesa(original: finalMesa,cambio:con.mesas[index].mesa_number.toString());
                                          /*guardar();

                                          setState(() {
                                            finalMesa =con.mesas[index].mesa_number.toString();
                                          });
                                          print("entro");
                                          Future.delayed(Duration(seconds: 3),(){
                                            Navigator.of(context).pop();
                                          });*/
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Seleccionar",
                                              style: TextStyle(
                                                fontFamily: 'alteHaasGrotesk',
                                                fontWeight: FontWeight.bold,
                                                //color: Theme.of(context).buttonColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Seleccionado",
                                          style: TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: (){
                                            preguntarCambiarMesa(mesa: finalMesa,quitar: "si",original: finalMesa,cambio: "0");
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Quitar",
                                                style: TextStyle(
                                                  fontFamily: 'alteHaasGrotesk',
                                                  fontWeight: FontWeight.bold,
                                                  color: global.buttonColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Icon(Icons.person,size: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        width: 200,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topRight: Radius.circular(15)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          finalMesero,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  con.meseros.isEmpty
                      ? Center(
                      child: Stack(
                        children: [
                          const Center(
                            child:SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset("assets/app/centro_mesa.png",color: global.buttonColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  )
                      : GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    crossAxisCount: count,
                    childAspectRatio: (width / height),
                    scrollDirection: Axis.vertical,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    primary: false,
                    shrinkWrap: true,
                    children: List.generate(con.meseros.length, (index){
                      String mesero =con.meseros[index].name.toString();
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: finalMesero == mesero
                                ? global.buttonColor
                                : Theme.of(context).primaryColor
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                                width: 100,
                                height: 100,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person,size: 100,color: finalMesero != mesero
                                            ? global.buttonColor
                                            : Theme.of(context).primaryColor,)
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    mesero,
                                    style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        color: finalMesero != mesero
                                            ? global.buttonColor
                                            : Theme.of(context).primaryColor
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  finalMesero != mesero
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          preguntarCambiarMesero(mesa: widget.mesa,mesero:con.meseros[index].name.toString(),meseroId:con.meseros[index].id.toString());
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Seleccionar",
                                              style: TextStyle(
                                                fontFamily: 'alteHaasGrotesk',
                                                fontWeight: FontWeight.bold,
                                                //color: Theme.of(context).buttonColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Seleccionado",
                                          style: TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: (){
                                            preguntarCambiarMesero(quitar: "si",mesa: widget.mesa,mesero:con.meseros[index].name.toString(),meseroId:con.meseros[index].id.toString());
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Quitar",
                                                style: TextStyle(
                                                  fontFamily: 'alteHaasGrotesk',
                                                  fontWeight: FontWeight.bold,
                                                  color: global.buttonColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
        onWillPop: ()async{
          widget.Notificar(1);
          return true;
        }
    );
  }

  Future<void> error({required String configuracion}) async{
    Navigator.pop(context);
    return showDialog(
        context: context,
        builder: (context){
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width*0.7,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "¡Ocurrio un error al guardar los cambios!",
                        style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Icon(Icons.clear),
                    ],
                  )
              ),
            ),
          );
        }
    );
  }
  Future<void> guardar({codigo,mesa,MeseroId,nombreMesero,quitar}) async{
    Navigator.of(context).pop();
    if(MeseroId == null){
      if(quitar == "si"){
        mesa = "0";
      }
      con.cambiarMesas(numero_mesa: mesa,codigo: codigo).then((value) {
        if(value == "true"){
          setState(() {
            finalMesa = mesa;
          });
          Future.delayed(const Duration(seconds: 2),(){
            Navigator.pop(context);
          });
        } else{
          String configuracion = "";
          if(MeseroId != null){
            configuracion = "el mesero";
          }
          else{
            configuracion = "la mesa";
          }
          error(configuracion: configuracion);
        }
        widget.Notificar(1);
      });
    }
    else{
      if(quitar == "si"){
        MeseroId = "0";
      }
      con.cambiarMesero(mesero_id: MeseroId, codigo: widget.code).then((value) {
        if(value == "true"){
          if(quitar == "si"){
            setState(() {
              finalMesero = "Libre";
            });
          }else{
            setState(() {
              finalMesero = nombreMesero;
            });
          }
          Future.delayed(const Duration(seconds: 2),(){
            Navigator.pop(context);
          });
        } else{
          String configuracion = "";
          if(MeseroId != null){
            configuracion = "el mesero";
          }
          else{
            configuracion = "la mesa";
          }
          error(configuracion: configuracion);
        }
        widget.Notificar(1);
      });
    }
    return showDialog(
        context: context,
        builder: (context){
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "¡Guardando los cambios!",
                      style: TextStyle(
                        fontFamily: 'alteHaasGrotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                )
              ),
            ),
          );
        }
    );
  }
  Future<void> preguntarCambiarMesa({required String original,required String cambio, quitar,mesa}) async{
    return showDialog(
        context: context,
        builder: (context){
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width*0.7,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        quitar == "si"
                         ? "¿Seguro que quieres quitar el centro de mesa ${widget.code} de la mesa $mesa"
                         : "¿Seguro que quieres cambiar el centro de mesa $original al $cambio?",
                        style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              guardar(quitar: quitar,codigo: widget.code,mesa: cambio);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue,
                              ),
                              child: const Center(
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ),
          );
        }
    );
  }
  Future<void> preguntarCambiarMesero({required String mesero,required String mesa,required String meseroId,quitar}) async{
    return showDialog(
        context: context,
        builder: (context){
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width*0.7,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        quitar == "si"
                        ? "¿Seguro de quitar el mesero $mesero del centro de mesa ${widget.code}"
                        : "¿Seguro que quieres asignar el mesero $mesero al centro de mesa ${widget.code}?",
                        style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              guardar(quitar: quitar,nombreMesero: mesero,mesa:mesa,MeseroId: meseroId,codigo: widget.code);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue,
                              ),
                              child: const Center(
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ),
          );
        }
    );
  }
}