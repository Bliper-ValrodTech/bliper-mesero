import 'package:bliper_mesero/src/models/order.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import 'package:bliper_mesero/src/controllers/global.dart' as global;
import 'package:state_extended/state_extended.dart';

class ListsaOrdenesWidget extends StatefulWidget {
  final List<Order> ordenes;
  final bool? entregadas;
  const ListsaOrdenesWidget({super.key, required this.ordenes, this.entregadas});

  @override
  _ListsaOrdenesWidgetState createState() => _ListsaOrdenesWidgetState();
}

class _ListsaOrdenesWidgetState extends StateX<ListsaOrdenesWidget> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.ordenes.length, (index) {
        if(widget.entregadas == true)
          {
            if(widget.ordenes[index].status == "Entregada")
              {
                List<bool> activado = [false,false,false,false,false,false];
                int posicion = 0;
                String Titulo = "";
                String cuerpo = "";
                List<double> datos = obtenerImpuesto(widget.ordenes[index]);
                double total = obtenerTotal(datos[0],datos[1]);
                if(widget.ordenes[index].status == "Orden recibida") {
                  activado[0] = true;
                  posicion = 0;
                  Titulo = "Orden recibida";
                  cuerpo = "La orden ha sido recibida.";
                }
                if(widget.ordenes[index].status == "Aceptada") {
                  activado[1] = true;
                  posicion = 1;
                  Titulo = "Aceptada";
                  cuerpo = "La orden ha sido Aceptada por el cocinero.";
                }
                if(widget.ordenes[index].status == "Preparando") {
                  activado[2] = true;
                  posicion = 2;
                  Titulo = "Preparando";
                  cuerpo = "La orden esta siendo preparada por el cocinero.";
                }
                if(widget.ordenes[index].status == "Lista") {
                  activado[3] = true;
                  posicion = 3;
                  Titulo = "Lista";
                  cuerpo = "La orden esta lista para entregarla al cliente.";
                }
                if(widget.ordenes[index].status == "En camino") {
                  activado[4] = true;
                  posicion = 4;
                  Titulo = "En camino";
                  cuerpo = "La orden esta lista para entregarla al cliente.";
                }
                if(widget.ordenes[index].status == "Entregada") {
                  activado[5] = true;
                  posicion = 5;
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10,left: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: global.buttonColor.withValues(alpha: 0.7),
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
                                      color: Theme.of(context).appBarTheme.backgroundColor?.withValues(alpha: 0.8),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Orden #${widget.ordenes[index].id}",
                                          style: const TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
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
                                      color: Theme.of(context).appBarTheme.backgroundColor?.withValues(alpha: 0.8),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Mesa #${widget.ordenes[index].Mesa}",
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
                                        color: Theme.of(context).appBarTheme.backgroundColor?.withValues(alpha: 0.8),
                                      ),
                                      child:  Center(
                                        child: Text(
                                          "Status: ${widget.ordenes[index].status}",
                                          style: const TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      statusOrdenes(getSteps(),posicion,Titulo,cuerpo);
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
                                              width: 150,
                                              child: Text(
                                                widget.ordenes[index].foodOrders![indexFoods].name.toString(),
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
                                            width: 100,
                                            child: Text(
                                              "${widget.ordenes[index].foodOrders![indexFoods].quantity} x ${widget.ordenes[index].foodOrders![indexFoods].price}",
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
                                    itemCount: widget.ordenes[index].foodOrders!.length
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
                                        "Impuesto ${global.user.porcentaje_iva.toString()}%",
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
                );
              }
            else{
              return const SizedBox();
            }
          }
        else
          {
            List<bool> activado = [false,false,false,false,false,false];
            int posicion = 0;
            String Titulo = "";
            String cuerpo = "";
            obtenerImpuesto(widget.ordenes[index]);
            if(widget.ordenes[index].status == "Orden recibida") {
              activado[0] = true;
              posicion = 0;
              Titulo = "Orden recibida";
              cuerpo = "La orden ha sido recibida.";
            }
            if(widget.ordenes[index].status == "Aceptada") {
              activado[1] = true;
              posicion = 1;
              Titulo = "Aceptada";
              cuerpo = "La orden ha sido Aceptada por el cocinero.";
            }
            if(widget.ordenes[index].status == "Preparando") {
              activado[2] = true;
              posicion = 2;
              Titulo = "Preparando";
              cuerpo = "La orden esta siendo preparada por el cocinero.";
            }
            if(widget.ordenes[index].status == "Lista") {
              activado[3] = true;
              posicion = 3;
              Titulo = "Lista";
              cuerpo = "La orden esta lista para entregarla al cliente.";
            }
            if(widget.ordenes[index].status == "En camino") {
              activado[4] = true;
              posicion = 4;
              Titulo = "En camino";
              cuerpo = "La orden esta lista para entregarla al cliente.";
            }
            if(widget.ordenes[index].status == "Entregada") {
              activado[5] = true;
              posicion = 5;
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(
                          minHeight: 0,
                          maxHeight: 330,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: global.buttonColor.withValues(alpha: 0.6),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                      color: Theme.of(context).appBarTheme.backgroundColor?.withValues(alpha: 0.8),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Orden #${widget.ordenes[index].id}",
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
                                      color: Theme.of(context).appBarTheme.backgroundColor?.withValues(alpha: 0.8),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Mesa #${widget.ordenes[index].Mesa}",
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
                                        color: Theme.of(context).appBarTheme.backgroundColor?.withValues(alpha: 0.8),
                                      ),
                                      child:  Center(
                                        child: Text(
                                          "Status: ${widget.ordenes[index].status}",
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
                                      statusOrdenes(getSteps(),posicion,Titulo,cuerpo);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: 160,
                              ),
                              width: MediaQuery.of(context).size.width*0.8,
                              child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, indexFoods) {
                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: global.bottomAppBarColor.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: Text(
                                                  widget.ordenes[index].foodOrders![indexFoods].name.toString(),
                                                  style: const TextStyle(
                                                    fontFamily:
                                                    'alteHaasGrotesk',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                //width: MediaQuery.of(context).size.width*0.2,
                                                child: Text(
                                                  "${widget.ordenes[index].foodOrders![indexFoods].quantity} x "r"$""${widget.ordenes[index].foodOrders![indexFoods].price!.toStringAsFixed(2)}",
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
                                          widget.ordenes[index].foodOrders![indexFoods].extras!.isNotEmpty ?
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 50),
                                                width: double.infinity,
                                                height: 2,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.black.withValues(alpha: 0.3),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  "Extras",
                                                  style: const TextStyle(
                                                    fontFamily:
                                                    'alteHaasGrotesk',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Column(
                                                    children: List.generate(
                                                      widget.ordenes[index].foodOrders![indexFoods].extras!.length, (index_ex) {
                                                      return Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            widget.ordenes[index].foodOrders![indexFoods].extras![index_ex].nombre,
                                                            style: const TextStyle(
                                                              fontFamily:
                                                              'alteHaasGrotesk',
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${widget.ordenes[index].foodOrders![indexFoods].extras![index_ex].cantidad} X "r"$"+widget.ordenes[index].foodOrders![indexFoods].extras![index_ex].precio,
                                                            style: const TextStyle(
                                                              fontFamily:
                                                              'alteHaasGrotesk',
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ) : SizedBox.shrink(),
                                          widget.ordenes[index].foodOrders![indexFoods].nota.toString().trim() != "" && widget.ordenes[index].foodOrders![indexFoods].nota.toString().trim() != "null"  ?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Nota",
                                                style: TextStyle(
                                                  fontFamily:
                                                  'alteHaasGrotesk',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                widget.ordenes[index].foodOrders![indexFoods].nota.toString(),
                                                style: TextStyle(
                                                  fontFamily:
                                                  'alteHaasGrotesk',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ) : SizedBox.shrink(),
                                          const SizedBox(height: 10,),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10,);
                                  },
                                  itemCount: widget.ordenes[index].foodOrders!.length
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                        r"$"+double.parse(widget.ordenes[index].subtotal.toString()).toStringAsFixed(2),//datos[1].toStringAsFixed(2),
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
                                        "Extras",
                                        style: TextStyle(
                                          fontFamily:
                                          'alteHaasGrotesk',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        r"$"+double.parse(widget.ordenes[index].extra_precio.toString()).toStringAsFixed(2),//datos[1].toStringAsFixed(2),
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
                                        r"$"+double.parse(widget.ordenes[index].iva.toString()).toStringAsFixed(2),//datos[0].toStringAsFixed(2),
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
                                        r"$"+double.parse(widget.ordenes[index].total.toString()).toStringAsFixed(2),//total.toStringAsFixed(2),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          global.mostrar_notificaiones_ordenes_orden(id_orden: widget.ordenes[index].id.toString()).toString() != "0" ?
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                global.mostrar_notificaiones_ordenes_orden(id_orden: widget.ordenes[index].id.toString()).toString(),
                                style: const TextStyle(
                                  fontFamily:
                                  'alteHaasGrotesk',
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
                const SizedBox(height: 10,),
              ],
            );
          }
      }),
    );
  }
  Future<void> statusOrdenes(List<Step> steps,position,Titulo,cuerpo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: const Color.fromRGBO(53, 78, 120, 1.0),
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.all(0),
                            shape: ContinuousRectangleBorder(),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width*0.8,
                                width: MediaQuery.of(context).size.width*0.5,
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
    for(int i = 0; i < orden.foodOrders!.length; i++)
      {
        double sub = orden.foodOrders![i].price! * double.parse(orden.foodOrders![i].quantity.toString());
        subTotal = subTotal+sub;
      }
    subimpuesto = double.parse(global.user.porcentaje_iva) * subTotal;
    impuesto = subimpuesto/100;
    List<double> datos = <double>[];
    datos.add(impuesto);
    datos.add(subTotal);
    return datos;
  }
}


/*Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          height: 200,
                          child: CarouselSlider(
                            items: List.generate(widget.ordenes[index].foodOrders!.length, (index2){
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).bottomAppBarColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:200,
                                      width: 140,
                                      child: ClipRRect(
                                        child: Image.network(widget.ordenes[index].foodOrders![index2].imagen_url.toString(),fit: BoxFit.fitHeight,),
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children:  [
                                             SizedBox(
                                              height: 50,
                                              width: 150,
                                              child: Text(
                                                widget.ordenes[index].foodOrders![index2].name.toString(),
                                                style: const TextStyle(
                                                  fontFamily:
                                                  'alteHaasGrotesk',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 150,
                                              child: Text(
                                                widget.ordenes[index].foodOrders![index2].description.toString(),
                                                style: const TextStyle(
                                                  fontFamily:
                                                  'alteHaasGrotesk',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.fade,
                                                ),
                                                maxLines: 2,
                                                softWrap: true,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 150,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Precio",
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'alteHaasGrotesk',
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                    maxLines: 2,
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    widget.ordenes[index].foodOrders![index2].quantity.toString()+" x "+r"$"+widget.ordenes[index].foodOrders![index2].price!.toStringAsFixed(2),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                      'alteHaasGrotesk',
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                    maxLines: 2,
                                                    softWrap: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            options: CarouselOptions(
                              height: 170,
                              aspectRatio: 0.5,
                              viewportFraction: 0.75,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ),
                      ],
                    ),*/