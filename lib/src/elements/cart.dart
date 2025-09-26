import 'package:bliper_mesero/src/controllers/cart_controller.dart';
import 'package:bliper_mesero/src/models/cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import 'package:bliper_mesero/src/controllers/global.dart' as global;
import 'package:state_extended/state_extended.dart';

import '../models/extras.dart';
// ignore: must_be_immutable
class CartDrawer extends StatefulWidget {
  final int mesa;
  List<Cart> carrito;
  final ValueChanged<int>? onTapcCancelar;
   CartDrawer({super.key, required this.carrito, this.onTapcCancelar,required this.mesa});

  @override
  _CartDrawer createState() => _CartDrawer();
}

class _CartDrawer extends StateX<CartDrawer> {
  late CartController con;

  _CartDrawer() : super(controller: CartController()) {
    con = controller as CartController;
  }

  @override
  initState()
  {
    con.precios(widget.carrito);
    super.initState();
  }
  int respuesta = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: con.scaffoldKey,
      child: widget.carrito.isEmpty ?
      Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                spreadRadius: 5,
                blurRadius: 7,
                //offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset("assets/images/carrito.png",color: Colors.white,),
                ),
                const SizedBox(height: 20,),
                const Text(
                  "El carrito esta vacio",
                  style: TextStyle(
                      fontFamily: 'alteHaasGrotesk',
                      fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      )
      : SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        if (index < widget.carrito.length) {
                          for (var extra in widget.carrito[index].food!.extras!) {
                            extra.cantidad = "0"; // Restablece los extras solo del producto eliminado
                          }
                          widget.carrito.removeAt(index);
                        }
                        con.precios(widget.carrito);
                        calularExtras();
                      });
                    },
                    background: Container(
                      height: 115,
                      color: Colors.red,
                      child: const Center(
                        child: Text(
                          "Eliminar",
                          style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 115,
                      decoration: const BoxDecoration(
                        color: Color(0xff242931),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              detallesOrden(widget.carrito[index],index);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:  widget.carrito[index].food?.imagen_url ?? "",
                                height: 100,
                                width: 100,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 162,
                                child: Text(
                                  widget.carrito[index].food!.name.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Precio:",
                                    style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    r"$"+(double.parse(widget.carrito[index].food!.price.toString()) * double.parse(widget.carrito[index].quantity.toString())).toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        margin:const EdgeInsets.only(right: 10),
                                        child: const Icon(CupertinoIcons.minus_circled),
                                      ),
                                      onTap: (){
                                        if(widget.carrito[index].quantity! > 1)
                                        {
                                          setState(() {
                                            widget.carrito[index].quantity = widget.carrito[index].quantity!-1;
                                          });
                                          con.precios(widget.carrito);
                                          calularExtras();
                                        }
                                      },
                                    ),
                                    Container(
                                      margin:const EdgeInsets.only(right: 10),
                                      child: Text(widget.carrito[index].quantity.toString(),),
                                    ),
                                    GestureDetector(
                                      child: const Icon(CupertinoIcons.plus_circled,),
                                      onTap: (){
                                        setState(() {
                                          widget.carrito[index].quantity = widget.carrito[index].quantity!+1;
                                        });
                                        con.precios(widget.carrito);
                                        calularExtras();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 0,);
                },
                itemCount: widget.carrito.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              height: 190,
              // color: Colors.blue,
              // width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                   // height: 100,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           const Text(
                             "Subtotal:",
                             style: TextStyle(
                               fontFamily: 'alteHaasGrotesk',
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                             ),
                           ),
                            Text(
                              r"$"+con.subtotal,
                              style: const TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Extras:",
                              style: TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              r"$"+con.extras,
                              style: const TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Impuesto ${global.user.porcentaje_iva.toString()}%:",
                              style: const TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              r"$"+con.impuesto,
                              style: const TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              r"$"+con.total,
                              style: const TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          onTapcCancelar();
                        },
                        child: Container(
                          height: 60,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.red),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Cancelar",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 60,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              color: Colors.black12,
                              border: Border.all(color: Colors.blueAccent)
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Ordenar",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () async{
                          Cargando();
                          int a = 0;
                          a = await con.ordenar(widget.carrito,mesa: widget.mesa);
                          print("aaaaa $a");
                          setState(() {
                            for (var item in widget.carrito) {
                              for (var extra in item.food!.extras!) {
                                extra.cantidad = "0"; // Restablece la cantidad de extras a 0
                              }
                            }
                            widget.carrito.clear();
                          });
                          if(a == 1)
                          {
                            setState(() {
                              respuesta = 1;
                            });
                            Navigator.of(context).pop(true);
                            setState(() {
                              respuesta = 0;
                            });
                            onTapcCancelar();
                            widget.carrito.clear();
                          }
                          else if(a == 0){
                            setState(() {
                              respuesta = 2;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
  Future<void> Cargando() async {
   return showDialog(
            context: context,
            builder: (BuildContext context) {
              return PopScope(
                canPop: true,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              respuesta == 0 ? "Creando la orden" : respuesta == 1 ? "Orden creada con exito!" : "Error al crear",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: respuesta == 0 ? const SizedBox(height: 50,width: 50,child: CircularProgressIndicator(),) :
                              respuesta == 1 ? const Icon(Icons.check_circle,color: Colors.green,size: 200,) :
                              const Icon(CupertinoIcons.xmark_circle_fill,color: Colors.red,size: 200,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
  }
  Future<void> detallesOrden(Cart orden_original, index_orden) async {
    Cart orden = Cart.clone(orden_original);
    TextEditingController notaTXT = TextEditingController();
    notaTXT.text = orden.nota.toString() == "null" ? "" : orden.nota.toString();
    //List<Extras> extras = orden_original.food!.extras!.map((e) => Extras.clone(e)).toList();
    /*return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.9,
                          constraints: BoxConstraints(
                              maxHeight: 570,
                              minHeight: 350,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                          ),
                          child: Column(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CachedNetworkImage(
                                imageUrl: orden.food!.imagen_url.toString(),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                                errorWidget: (context, url, error) {
                                  return CircularProgressIndicator();
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 20,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              orden.food!.name.toString(),
                                              style: const TextStyle(
                                                fontFamily: 'alteHaasGrotesk',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              softWrap: true,
                                            ),
                                          ),
                                          Text(
                                            r"$"+orden.food!.price!.toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ]
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 38,
                                      child: TextField(
                                        controller: notaTXT,
                                        style: const TextStyle(
                                          fontFamily: 'alteHaasGrotesk',
                                        ),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            alignLabelWithHint: true,
                                            hintText: "Nota"
                                        ),
                                      ),
                                    ),

                                    //si hay extras
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Extras",
                                          style: TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        minHeight: 0,
                                        maxHeight: 190,
                                      ),
                                      width: double.infinity,
                                      //padding: EdgeInsets.all(10),
                                      child: ListView.builder(
                                        itemCount: orden.food!.extras!.length, // 🔹 Número de elementos en la lista
                                        physics: BouncingScrollPhysics(), // 🔹 Efecto de rebote
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 10), // 🔹 Espaciado entre los elementos
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Container(
                                                height: 70,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: global.buttonColor,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      width: 180,
                                                      margin: EdgeInsets.only(right: 10),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            orden.food!.extras![index].nombre, // 🔹 Muestra el índice del elemento
                                                            style: const TextStyle(
                                                              fontFamily: 'alteHaasGrotesk',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            r"$"+orden.food!.extras![index].precio,
                                                            style: const TextStyle(
                                                              fontFamily: 'alteHaasGrotesk',
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 139,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(15),
                                                                  topLeft: Radius.circular(15),
                                                                ),
                                                                border: Border.all(
                                                                  color: global.buttonColor,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  orden.food!.extras![index].cantidad = extra_mas(extra: orden.food!.extras![index]);
                                                                  setState((){});
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  padding: EdgeInsets.zero,
                                                                  backgroundColor: Colors.transparent,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.zero,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: SizedBox(
                                                                    width: 40,
                                                                    height: 40,
                                                                    child: Icon(
                                                                      CupertinoIcons.minus_circled,
                                                                      color: Colors.red,
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                border: Border(
                                                                  right: BorderSide(
                                                                    color: global.buttonColor,
                                                                    width: 2.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "0",
                                                                  style: const TextStyle(
                                                                    fontFamily: 'alteHaasGrotesk',
                                                                    fontWeight: FontWeight.w900,
                                                                    fontSize: 24,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius.circular(15),
                                                                  topRight: Radius.circular(15),
                                                                ),
                                                              ),
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                    orden.food!.extras![index].cantidad = extra_mas(extra: orden.food!.extras![index]);
                                                                    setState((){});
                                                                  },
                                                                style: ElevatedButton.styleFrom(
                                                                  padding: EdgeInsets.zero,
                                                                  backgroundColor: Colors.transparent,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.zero,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: SizedBox(
                                                                    width: 40,
                                                                    height: 40,
                                                                    child: Center(
                                                                      child: Icon(
                                                                        CupertinoIcons.add_circled,
                                                                        color: Colors.blue,
                                                                        size: 30,
                                                                      ),
                                                                    ),
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
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: ElevatedButton(
                                        onPressed: (){
                                          widget.carrito[index_orden] = orden;
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: global.buttonColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Guardar",
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                              color: global.bottomAppBarColor,
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
                  ),
                )
              ],
            ),
          );
        },
    );*/
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) { // 👈 Aquí se obtiene el `setState` para actualizar el diálogo
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        backgroundColor: Colors.transparent,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            constraints: BoxConstraints(maxHeight: 570, minHeight: 350),
                            decoration: BoxDecoration(
                              color: Theme.of(context).appBarTheme.backgroundColor,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: orden.food!.imagen_url.toString(),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                  errorWidget: (context, url, error) {
                                    return CircularProgressIndicator();
                                  },
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              orden.food!.name.toString(),
                                              style: const TextStyle(
                                                fontFamily: 'alteHaasGrotesk',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              softWrap: true,
                                            ),
                                          ),
                                          Text(
                                            r"$" + orden.food!.price!.toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 38,
                                        child: TextField(
                                          controller: notaTXT,
                                          onChanged: (nota){
                                            orden.nota = nota;
                                          },
                                          style: const TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                          ),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30)),
                                              alignLabelWithHint: true,
                                              hintText: "Nota"),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Extras",
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight: 0,
                                          maxHeight: 190,
                                        ),
                                        width: double.infinity,
                                        child: ListView.builder(
                                          itemCount: orden.food!.extras!.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: Container(
                                                  height: 70,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(
                                                      color: global.buttonColor,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        width: 180,
                                                        margin: EdgeInsets.only(right: 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              orden.food!.extras![index].nombre,
                                                              style: const TextStyle(
                                                                fontFamily: 'alteHaasGrotesk',
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              r"$" + orden.food!.extras![index].precio,
                                                              style: const TextStyle(
                                                                fontFamily: 'alteHaasGrotesk',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 139,
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                height: 70,
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.only(
                                                                    bottomLeft:
                                                                    Radius.circular(15),
                                                                    topLeft:
                                                                    Radius.circular(15),
                                                                  ),
                                                                  border: Border(
                                                                    left: BorderSide(
                                                                      color: global.buttonColor,
                                                                      width: 2.0,
                                                                    ),
                                                                    right: BorderSide(
                                                                      color: global.buttonColor,
                                                                      width: 2.0,
                                                                    ),
                                                                  )
                                                                ),
                                                                child: ElevatedButton(
                                                                  onPressed: () {
                                                                    orden.food!.extras![index].cantidad = extra_menos(extra: orden.food!.extras![index]);
                                                                    print("Extras: ${orden.food!.extras![index].cantidad}");
                                                                    setState(() {}); // 👈 Actualiza el diálogo
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: EdgeInsets.zero,
                                                                    backgroundColor:
                                                                    Colors.transparent,
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.zero,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: SizedBox(
                                                                      width: 40,
                                                                      height: 40,
                                                                      child: Icon(
                                                                        CupertinoIcons
                                                                            .minus_circled,
                                                                        color: Colors.red,
                                                                        size: 30,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 70,
                                                                child: Center(
                                                                  child: Text(
                                                                      orden.food!.extras![index].cantidad.toString(), // 👈 Muestra la cantidad correcta
                                                                    style: const TextStyle(
                                                                      fontFamily:
                                                                      'alteHaasGrotesk',
                                                                      fontWeight:
                                                                      FontWeight.w900,
                                                                      fontSize: 24,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                height: 70,
                                                                decoration: BoxDecoration(
                                                                  border: Border(
                                                                    left: BorderSide(
                                                                      color: global.buttonColor,
                                                                      width: 2.0,
                                                                    )
                                                                  )
                                                                ),
                                                                child: ElevatedButton(
                                                                  onPressed: () {
                                                                    orden.food!.extras![index].cantidad = extra_mas(extra: orden.food!.extras![index]);
                                                                    setState(() {}); // 👈 Actualiza el diálogo
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: EdgeInsets.zero,
                                                                    backgroundColor:
                                                                    Colors.transparent,
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.zero,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: SizedBox(
                                                                      width: 40,
                                                                      height: 40,
                                                                      child: Icon(
                                                                        CupertinoIcons
                                                                            .add_circled,
                                                                        color: Colors.blue,
                                                                        size: 30,
                                                                      ),
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
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: ElevatedButton(
                                          onPressed: (){
                                            widget.carrito[index_orden] = orden;
                                            calularExtras();
                                            setState((){});
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: global.buttonColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Guardar",
                                              style: TextStyle(
                                                fontFamily: 'alteHaasGrotesk',
                                                fontWeight: FontWeight.bold,
                                                color: global.bottomAppBarColor,
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
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void calularExtras(){
    double precio_extra = 0.0;
    for(int i = 0; i < widget.carrito.length; i++){
      for(int b = 0; b < widget.carrito[i].food!.extras!.length; b++){
        precio_extra += double.parse(widget.carrito[i].food!.extras![b].precio) * int.parse(widget.carrito[i].food!.extras![b].cantidad);
      }
    }
    setState((){
      con.extras = precio_extra.toStringAsFixed(2);
      con.total = (double.parse(con.subtotal)  + double.parse(con.extras)).toStringAsFixed(2);
    });
  }
  String extra_mas({required Extras extra}){
    int cantidad = int.parse(extra.cantidad) + 1;
    return cantidad.toString();
  }
  String extra_menos({required Extras extra}){
    int cantidad = int.parse(extra.cantidad) - 1;
    if(cantidad <= 0){
      cantidad = 0;
    }
    return cantidad.toString();
  }
  void onTapcCancelar() {
    setState(() {widget.carrito.clear();});
    Navigator.pop(context);
    widget.onTapcCancelar!(1);
  }
}


/*Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.clear),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.6,
                  color: global.bottomAppBarColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),

                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: orden.food?.imagen_url ?? "",
                                  height: 100,
                                  width: 100,
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),

                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: const Color.fromRGBO(0, 119, 125,0.9))
                                ),
                                child: Text(
                                  orden.quantity.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.red,
                            width: MediaQuery.of(context).size.width*0.4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    orden.food!.name.toString(),
                                    style:const TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    orden.food!.description.toString(),
                                    style:const TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );*/