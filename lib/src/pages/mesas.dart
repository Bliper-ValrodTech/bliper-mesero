import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../controllers/centros_controller.dart';

class MesasWidget extends StatefulWidget {
  final String numero_mesa;
  final ValueChanged<int> notificar;
  MesasWidget({required this.numero_mesa,required this.notificar});

  @override
  _MesasWidgetState createState() => _MesasWidgetState();
}

class _MesasWidgetState extends StateX<MesasWidget> {
  late CentrosControlller con;

  _MesasWidgetState() : super(controller: CentrosControlller()) {
    con = controller as CentrosControlller;
  }

  int count = 0;
  int width = 135;
  int height = 160;
  String numMesa = "";

  @override
  void initState() {
    numMesa = widget.numero_mesa;
    con.obtenerCentros();
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
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Mesa ${widget.numero_mesa}".toUpperCase(),
              style: const TextStyle(
                fontFamily: 'alteHaasGrotesk',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),

            ),
          ),
          body: SingleChildScrollView(
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
                            Image.asset("assets/images/mesa.png",color: global.buttonColor,),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                numMesa.toString(),
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
                        "Mesa $numMesa",
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
                GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  crossAxisCount: count,
                  childAspectRatio: (width / height),
                  scrollDirection: Axis.vertical,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  primary: false,
                  shrinkWrap: true,
                  children: List.generate(con.centros.length, (index){
                    return Container(
                      height: 130,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: numMesa == con.centros[index].mesa_number
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
                                          "assets/app/centro_mesa.png",
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          con.centros[index].mesa_number.toString() != "0"
                                          ? con.centros[index].mesa_number.toString()
                                          : "",
                                          style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: numMesa != con.centros[index].mesa_number
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
                                  con.centros[index].mesa_number.toString() != "null" && con.centros[index].mesa_number.toString() != ""
                                  && con.centros[index].mesa_number.toString() != "0"
                                  ? "Mesa ${con.centros[index].mesa_number}"
                                  : "",
                                  style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      color: numMesa != con.centros[index].mesa_number
                                          ? global.buttonColor
                                          : Theme.of(context).primaryColor
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  con.centros[index].code.toString(),
                                  style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      color: numMesa != con.centros[index].mesa_number
                                          ? global.buttonColor
                                          : Theme.of(context).primaryColor
                                  ),
                                ),
                                const SizedBox(height: 10),
                                numMesa != con.centros[index].mesa_number
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        preguntarCambiarMesa(code: con.centros[index].code.toString());
                                        /*guardar();

                                              setState(() {
                                                finalMesa = con.mesas[index].mesa_number.toString();
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
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Seleccionado",
                                      style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: (){
                                        preguntarCambiarMesa(code: con.centros[index].code.toString(),quitar: "si");
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
    ),
        onWillPop: ()async{
          widget.notificar(1);
          return true;
    });
  }
  Future<void> preguntarCambiarMesa({required String code, quitar}) async{
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
                      quitar == null
                      ? Text(
                          "¿Seguro que quieres asignar la mesa $numMesa a este centro de mesa $code?",
                          style: const TextStyle(
                              fontFamily: 'alteHaasGrotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                        "¿Seguro que quieres quitar el centro de mesa $code de la mesa $numMesa?",
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
                              guardar(codigo: code,quitar: quitar);
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
  Future<void> guardar({codigo,quitar}) async{
    Navigator.of(context).pop();
    String nmesa = "0";
    if(quitar == null){
      nmesa = numMesa;
    }
    con.cambiarMesas(numero_mesa: nmesa,codigo: codigo).then((value) {
      if(value == "true"){
        con.obtenerCentros();
        widget.notificar(2);
        Future.delayed(const Duration(seconds: 2),(){
          Navigator.pop(context);
        });
      } else{
        String configuracion = "la mesa";
        error(configuracion: configuracion);
      }
    });
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
}