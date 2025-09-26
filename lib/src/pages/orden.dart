import 'package:bliper_mesero/src/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../models/order.dart';

class OrdenWidget extends StatefulWidget {
  final Order orden;
  final bool? entregadas;
  OrdenWidget({required this.orden, this.entregadas});

  @override
  _OrdenWidgetState createState() => _OrdenWidgetState();
}
class _OrdenWidgetState extends StateX<OrdenWidget> {
  @override
  Widget build(BuildContext context) {
    if(widget.entregadas == true)
    {
      if(widget.orden.status == "Entregada")
      {
        List<bool> activado = [false,false,false,false,false,false];
        List<int> contador = [0,0,0,0,0,0];
        String Titulo = "";
        String cuerpo = "";
        List<double> datos = obtenerImpuesto(widget.orden);
        double total = obtenerTotal(datos[0],datos[1]);
        if(widget.orden.status == "Orden recibida") {
          activado[0] = true;
          contador[0] = 0;
          Titulo = "Orden recibida";
          cuerpo = "La orden ha sido recibida.";
        }
        if(widget.orden.status == "Aceptada") {
          activado[1] = true;
          contador[1] = 1;
          Titulo = "Aceptada";
          cuerpo = "La orden ha sido Aceptada por el cocinero.";
        }
        if(widget.orden.status == "Preparando") {
          activado[2] = true;
          contador[2] = 2;
          Titulo = "Preparando";
          cuerpo = "La orden esta siendo preparada por el cocinero.";
        }
        if(widget.orden.status == "Lista") {
          activado[3] = true;
          contador[3] = 3;
          Titulo = "Lista";
          cuerpo = "La orden esta lista para entregarla al cliente.";
        }
        if(widget.orden.status == "En camino") {
          activado[4] = true;
          contador[4] = 4;
          Titulo = "En camino";
          cuerpo = "La orden esta lista para entregarla al cliente.";
        }
        if(widget.orden.status == "Entregada") {
          activado[5] = true;
          contador[5] = 5;
          Titulo = "Entregada";
          cuerpo = "Se entrego la orden al cliente.";
        }
        List<Step> getSteps() =>[
          Step(
            title: const Text(
              "Orden recibida",
              style: TextStyle(
                fontFamily:
                'alteHaasGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(),
            isActive: activado[0],
          ),
          Step(
            title: const Text(
              "Aceptada",
              style: TextStyle(
                fontFamily:
                'alteHaasGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(),
            isActive: activado[1],
          ),
          Step(
            title: const Text(
              "Preparando",
              style: TextStyle(
                fontFamily:
                'alteHaasGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(),
            isActive: activado[2],
          ),
          Step(
            title: const Text(
              "Lista",
              style: TextStyle(
                fontFamily:
                'alteHaasGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(),
            isActive: activado[3],
          ),
          Step(
            title: const Text(
              "En camino",
              style: TextStyle(
                fontFamily:
                'alteHaasGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(),
            isActive: activado[4],
          ),
          Step(
            title: const Text(
              "Entregada",
              style: TextStyle(
                fontFamily:
                'alteHaasGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(),
            isActive: activado[5],
          ),
        ];
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(53, 78, 120, 1.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromRGBO(0, 31, 36, 1.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Orden #${widget.orden.id}",
                                    style: const TextStyle(
                                      fontFamily:
                                      'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromRGBO(0, 31, 36, 1.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Mesa #${widget.orden.Mesa}",
                                    style: const TextStyle(
                                      fontFamily:
                                      'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromRGBO(0, 31, 36, 1.0),
                                ),
                                child:  Center(
                                  child: Text(
                                    "Status: ${widget.orden.status}",
                                    style: const TextStyle(
                                      fontFamily:
                                      'alteHaasGrotesk',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              onTap: (){
                                statusOrdenes(getSteps(),contador[0],Titulo,cuerpo);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, indexFoods) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.7,
                                        child: Text(
                                          widget.orden.foodOrders![indexFoods].name.toString(),
                                          style: const TextStyle(
                                            fontFamily:
                                            'alteHaasGrotesk',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      child: Text(
                                        "${widget.orden.foodOrders![indexFoods].quantity} x ${widget.orden.foodOrders![indexFoods].name}",
                                        style: const TextStyle(
                                          fontFamily:
                                          'alteHaasGrotesk',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 10,);
                              },
                              itemCount: widget.orden.foodOrders!.length
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "SubTotal",
                                  style: TextStyle(
                                    fontFamily:
                                    'alteHaasGrotesk',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  r"$"+datos[1].toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontFamily:
                                    'alteHaasGrotesk',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Impuesto ${global.user.porcentaje_iva}%",
                                  style: const TextStyle(
                                    fontFamily:
                                    'alteHaasGrotesk',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  r"$"+datos[0].toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontFamily:
                                    'alteHaasGrotesk',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontFamily:
                                    'alteHaasGrotesk',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  r"$"+total.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontFamily:
                                    'alteHaasGrotesk',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
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
              const SizedBox(height: 10,),
            ],
          ),
        );

      }
      else{
        return const SizedBox();
      }
    }
    else
    {
      List<bool> activado = [false,false,false,false,false,false];
      List<int> contador = [0,0,0,0,0,0];
      String Titulo = "";
      String cuerpo = "";
      List<double> datos = <double>[];

      try{
        datos = obtenerImpuesto(widget.orden);
      }catch(e){
        print(e);
        datos.add(0);
        datos.add(0);
      }
      double total = obtenerTotal(datos[0],datos[1]);
      if(widget.orden.status == "Orden recibida") {
        activado[0] = true;
        contador[0] = 0;
        Titulo = "Orden recibida";
        cuerpo = "La orden ha sido recibida.";
      }
      if(widget.orden.status == "Aceptada") {
        activado[1] = true;
        contador[1] = 1;
        Titulo = "Aceptada";
        cuerpo = "La orden ha sido Aceptada por el cocinero.";
      }
      if(widget.orden.status == "Preparando") {
        activado[2] = true;
        contador[2] = 2;
        Titulo = "Preparando";
        cuerpo = "La orden esta siendo preparada por el cocinero.";
      }
      if(widget.orden.status == "Lista") {
        activado[3] = true;
        contador[3] = 3;
        Titulo = "Lista";
        cuerpo = "La orden esta lista para entregarla al cliente.";
      }
      if(widget.orden.status == "En camino") {
        activado[4] = true;
        contador[4] = 4;
        Titulo = "En camino";
        cuerpo = "La orden esta lista para entregarla al cliente.";
      }
      if(widget.orden.status == "Entregada") {
        activado[5] = true;
        contador[5] = 5;
        Titulo = "Entregada";
        cuerpo = "Se entrego la orden al cliente.";
      }
      List<Step> getSteps() =>[
        Step(
          title: const Text(
            "Orden recibida",
            style: TextStyle(
              fontFamily:
              'alteHaasGrotesk',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(),
          isActive: activado[0],
        ),
        Step(
          title: const Text(
            "Aceptada",
            style: TextStyle(
              fontFamily:
              'alteHaasGrotesk',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(),
          isActive: activado[1],
        ),
        Step(
          title: const Text(
            "Preparando",
            style: TextStyle(
              fontFamily:
              'alteHaasGrotesk',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(),
          isActive: activado[2],
        ),
        Step(
          title: const Text(
            "Lista",
            style: TextStyle(
              fontFamily:
              'alteHaasGrotesk',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(),
          isActive: activado[3],
        ),
        Step(
          title: const Text(
            "En camino",
            style: TextStyle(
              fontFamily:
              'alteHaasGrotesk',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(),
          isActive: activado[4],
        ),
        Step(
          title: const Text(
            "Entregada",
            style: TextStyle(
              fontFamily:
              'alteHaasGrotesk',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(),
          isActive: activado[5],
        ),
      ];
      return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                "Orden ${widget.orden.id}"
            ),
            centerTitle: true,
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/app/fondo_dark.jpg'),
                  fit: BoxFit.fitWidth),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 10,left: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(53, 78, 120, 1.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(0, 31, 36, 1.0),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Orden #${widget.orden.id}",
                                        style: const TextStyle(
                                          fontFamily:
                                          'alteHaasGrotesk',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(0, 31, 36, 1.0),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Mesa #${widget.orden.Mesa}",
                                        style: const TextStyle(
                                          fontFamily:
                                          'alteHaasGrotesk',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color.fromRGBO(0, 31, 36, 1.0),
                                    ),
                                    child:  Center(
                                      child: Text(
                                        "Status: ${widget.orden.status}",
                                        style: const TextStyle(
                                          fontFamily:
                                          'alteHaasGrotesk',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    statusOrdenes(getSteps(),contador[0],Titulo,cuerpo);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width*0.8,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, indexFoods) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*0.3,
                                              child: Text(
                                                widget.orden.foodOrders![indexFoods].name.toString(),
                                                style: const TextStyle(
                                                  fontFamily:
                                                  'alteHaasGrotesk',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*0.3,
                                              child: Text(
                                                "${widget.orden.foodOrders![indexFoods].quantity} x ${widget.orden.foodOrders![indexFoods].name}",
                                                style: const TextStyle(
                                                  fontFamily:
                                                  'alteHaasGrotesk',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                            "nota"
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          height: 2,
                                          width: MediaQuery.of(context).size.width*0.7,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.black38
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10,);
                                  },
                                  itemCount: widget.orden.foodOrders!.isEmpty ? 0 : widget.orden.foodOrders!.length
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "SubTotal",
                                      style: TextStyle(
                                        fontFamily:
                                        'alteHaasGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      r"$"+datos[1].toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontFamily:
                                        'alteHaasGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Impuesto ${global.user.porcentaje_iva}%",
                                      style: const TextStyle(
                                        fontFamily:
                                        'alteHaasGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      r"$"+datos[0].toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontFamily:
                                        'alteHaasGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total",
                                      style: TextStyle(
                                        fontFamily:
                                        'alteHaasGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      r"$"+total.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontFamily:
                                        'alteHaasGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
        onWillPop: ()async{
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PagesWidget(page: 1,deviceToken: global.token)));
          return false;
        },
      );
    }
  }

  Future<void> statusOrdenes(List<Step> steps,position,Titulo,cuerpo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.width*0.8,
                      color: const Color.fromRGBO(53, 78, 120, 1.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width*0.8,
                            width: MediaQuery.of(context).size.width*0.40,
                            child: Stepper(
                              controlsBuilder: (context, details) {
                                return Row(
                                  children: <Widget>[
                                    Container(),
                                    Container(),
                                  ],
                                );
                              },
                              steps: steps,
                              currentStep: position,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width*0.5,
                            width: MediaQuery.of(context).size.width*0.40,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Titulo,
                                  style: const TextStyle(
                                    fontFamily:
                                    'alteHaasGrotesk',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: SizedBox(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width*0.40,
                                    child: Text(
                                      cuerpo,
                                      style: const TextStyle(
                                        fontFamily:
                                        'alteHaasGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Titulo == "Lista" ?
                                ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      // contador++;
                                    });
                                  },
                                  child: const Text(
                                    "Recojer orden",
                                    style: TextStyle(
                                      fontFamily:
                                      'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ) : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          );
        }
    );
  }
  obtenerTotal(impuesto,subtotal){
    double total = impuesto + subtotal;
    return total;
  }
  obtenerImpuesto(Order orden){
    double subimpuesto = 0.0;
    double impuesto = 0.0;
    double subTotal = 0.0;
    print("==================");
    print(orden.foodOrders!.length);
    for(int i = 0; i < orden.foodOrders!.length; i++)
    {
      double sub = orden.foodOrders![i].price! * double.parse(orden.foodOrders![i].quantity.toString());
      subTotal = subTotal+sub;
    }
    subimpuesto = double.parse(global.user.porcentaje_iva.toString()) * subTotal;
    impuesto = subimpuesto/100;
    List<double> datos = <double>[];
    datos.add(impuesto);
    datos.add(subTotal);
    return datos;
  }
}