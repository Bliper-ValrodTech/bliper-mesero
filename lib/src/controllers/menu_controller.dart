import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bliper_mesero/src/models/cart.dart';
import 'package:bliper_mesero/src/models/cupon.dart';
import 'package:bliper_mesero/src/models/food.dart';
import 'package:bliper_mesero/src/models/orden_voz.dart';
import 'package:bliper_mesero/src/repository/menu_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:state_extended/state_extended.dart';
import '../elements/menu_item.dart';
import '../models/category.dart';
import '../models/food_abreviatura.dart';
import '../models/food_id_cantidad.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/orden_repository.dart';
import 'package:bliper_mesero/src/controllers/global.dart' as global;

class MenuController extends StateXController {
  AudioRecorder r = AudioRecorder();
  List<Cart> Carrito = <Cart>[];
  String filepath = "";
  String nombre = "";
  bool scanner = true;
  Cupon? cupon;
  var context;
  String? deviceToken;
  String ocrText = '';
  List<food_abreviatura> fa = <food_abreviatura>[];
  List<Food> food = <Food>[];
  List<Food_ID_Cantidad> idCantidad = <Food_ID_Cantidad>[];
  List<FoodOrder> foodOrders = <FoodOrder>[];
  List<Category> categorias = <Category>[];
  OrdenVoz orden = OrdenVoz();
  int count = 0;
  int width = 135;
  int height = 250;
  bool grabando = false;
  GlobalKey keyComidas = GlobalKey();
  GlobalKey keynotas = GlobalKey();
  List<GlobalKey> keysNotas = <GlobalKey>[];
  MenuController();

  Future<String> ocr_img({required File img}) async{
    String respuesta = await ocrImg(img: img);
    print("controller $respuesta");
    return respuesta;
  }
  Future<void> getFoods() async {
    food = await GetFoods();
    agregarAbreviacion(food);
    setState(() {
      food;
    });
  }
  Future<void> AgregarCarrito(Comida,{mano,idCantidad,foods}) async {
    print("comida ${Comida.id}");
    if(mano == true){
      for(int i = 0; i < idCantidad.length; i++){
        Food food = Food();
        for(int b = 0; b < foods.length; b++){
          if(idCantidad[i].id == foods[b].id){
            food = foods[b];
          }
        }
        bool? misma = false;
        if(Carrito.isNotEmpty)
        {
          misma = await MismaComida(food,mano: true,cantidad: idCantidad[i].cantidad);
        }
        if(misma == false)
        {
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd mm:ss').format(now);
          Cart nuevo = Cart();
          nuevo.food = food;
          nuevo.Fecha = formattedDate;
          nuevo.id_restaurante = 157;
          nuevo.quantity = int.parse(idCantidad[i].cantidad);
          nuevo.en_restaurante = 1;
          nuevo.nota = food.nota;
          setState(() {
            Carrito.add(nuevo);
          });
        }
      }
    }
    else
      {
        bool? misma = false;
        if(Carrito.isNotEmpty)
        {
          misma = await MismaComida(Comida);
        }
        if(misma == false)
        {
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd mm:ss').format(now);
          Cart nuevo = Cart();
          nuevo.food = Comida;
          nuevo.Fecha = formattedDate;
          nuevo.id_restaurante = 157;
          nuevo.quantity = 1;
          nuevo.en_restaurante = 1;
          print("nuevo ${nuevo.food?.id}");
          setState(() {
            Carrito.add(nuevo);
          });
        }
      }
  }
  Future<int> ordenar(List<Cart> carrito,{required int mesa,tax}) async {
    print("Carrito Ordenar ${carrito.length}");
    Payment payment = Payment("Cash on Delivery");
    payment.id = "1";
    payment.status = "Order not paid yet";
    payment.method = "Cash on Delivery";

    Order _order = Order();
    User User2 = User();
    User2.name = global.user.name;
    User2.id = global.user.id;
    User2.deviceToken = global.token;
    User2.apiToken = global.token;
    _order.user = User2;
    _order.idRestaurante = int.parse(global.user.restaurante_id);
    _order.restaurant_id = int.parse(global.user.restaurante_id);
    _order.En_Restaurante = 1;
    _order.Mesa = mesa;

    _order.foodOrders = foodOrders;
    _order.tax = double.parse(tax);


    _order.deliveryFee = 0;

    OrderStatus _orderStatus = OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;

    for (var _cart in carrito) {
      FoodOrder foodOrder = FoodOrder();
      foodOrder.quantity = _cart.quantity;
      foodOrder.price = _cart.food!.price;
      foodOrder.food = _cart.food;
      foodOrder.nota = _cart.nota != null && _cart.nota != "" ? _cart.nota :" ";
      foodOrder.Fecha = _cart.Fecha != null && _cart.Fecha != "" ? _cart.Fecha: " ";
      foodOrder.Hora = _cart.Hora != null && _cart.Hora != "" ? _cart.Hora : DateTime.now();
      _order.foodOrders!.add(foodOrder);
    }
    // orderRepo.addOrder
    print(_order.user!.id);
    int respuesta = 0;
    respuesta = await agregarOrden(_order, payment);

    return respuesta;
  }
  Future<bool> MismaComida(Food Comida,{mano,cantidad}) async {
    bool misma = false;
    if(mano == true){
      for(int i = 0; i < Carrito.length; i++)
      {
        if(Comida.id == Carrito[i].food!.id)
        {
          setState(() {
            Carrito[i].quantity= Carrito[i].quantity!+int.parse(cantidad.toString());
          });
          misma = true;
        }
      }
    }
    else{
      for(int i = 0; i < Carrito.length; i++)
      {
        if(Comida.id == Carrito[i].food!.id)
        {
          setState(() {
            Carrito[i].quantity= Carrito[i].quantity!+1;
          });
          misma = true;
        }
      }
    }
    return misma;
  }
  Future<void> startRecording() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {

    }
    else{
      nombre = DateTime.now().millisecondsSinceEpoch.toString();
      filepath = '${directory.path}/$nombre.wav';
      RecordConfig rc = RecordConfig(
          sampleRate: 44100,
          encoder: AudioEncoder.wav,
          bitRate: 128000
      );
      await r.start(
        rc,
        path: filepath, // required
      );
    }
  }
  Future<void> stopRecording({required mesa, required bool menu}) async {
    await r.stop();
    File audio = File(filepath);
    if(await audio.exists())
    {

      OrdenVoz respuesta = OrdenVoz();

      respuesta = await voz_comida(audio: audio.path);

      if(respuesta.respuesta == 1)
        {
          Navigator.of(context).pop();
          if(menu){
            orden = OrdenVoz();
          }

          if(orden.comidas.isNotEmpty){
            double subtotal = 0.0;
            double total = 0.0;
            double iva = 0.0;
            if(double.parse(global.user.porcentaje_iva) >= 0.0){
              iva = subtotal * double.parse(global.user.porcentaje_iva)/100;
            }else{
              iva = 0.0;
            }
            subtotal = double.parse(respuesta.subTotal.toString()) + double.parse(orden.subTotal.toString());
            total = subtotal + iva;
            orden.subTotal = subtotal.toStringAsFixed(2);
            orden.iva = iva.toStringAsFixed(2);
            orden.total = total.toStringAsFixed(2);
            for(int i = 0; i < respuesta.comidas.length; i++){
              orden.comidas.add(respuesta.comidas[i]);
            }
          }else{
            orden = respuesta;
          }
          keysNotas.clear();
          mostrarComidas(mesa: int.parse(mesa.toString()));
          print("====================================================================");
          print("Retorno Nombre: $nombre");
          print("====================================================================");
        }
      else
        {
          Navigator.of(context).pop();
          fallo();
        }
    }
    else
    {
     print("no existe ");
    }
  }
  Future<void> fallo() async{
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context,setState){
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Center(
                                child: Text(
                                  "Lo siento no entendí la orden",
                                  style: TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: const Icon(CupertinoIcons.clear_circled_solid,color: Colors.red,size: 50,),
                              ),
                            ],
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

  Future<void> cerrarOrden() async {
    Carrito = [];
    foodOrders.clear();
    orden = OrdenVoz();
    Navigator.pop(context);
  }
  Future<void> mostrarComidas({required int mesa}){
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            key: keyComidas,
            builder:(context,setState){
              return WillPopScope(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.height*0.52,
                            decoration: BoxDecoration(
                              color: global.bottomAppBarColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Orden",
                                      style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                orden.comidas.isEmpty ?
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width*0.8,
                                  height: MediaQuery.of(context).size.height*0.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black45
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "No hay comidas",
                                      style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ):
                                SingleChildScrollView(
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width*0.8,
                                    height: MediaQuery.of(context).size.height*0.3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black45
                                    ),
                                    child: ListView.separated(
                                        itemBuilder: (context,index){
                                          TextEditingController notaTXT = TextEditingController();
                                          String nota = orden.comidas[index].nota.toString();
                                          if(notaTXT.text != orden.comidas[index].nota.toString()){
                                            notaTXT.text = orden.comidas[index].nota.toString();
                                          }
                                          /*if(keysNotas.length != 0){
                                          if((keysNotas.length-1) == index){
                                            GlobalKey keynotas = GlobalKey();
                                            keysNotas.add(keynotas);
                                          }
                                        }else{
                                          GlobalKey keynotas = GlobalKey();
                                          keysNotas.add(keynotas);
                                        }*/
                                          if(keysNotas.isEmpty){
                                            for(int i = 0; i < orden.comidas.length+2; i++){
                                              GlobalKey keynotas = GlobalKey();
                                              keysNotas.add(keynotas);
                                            }
                                          }
                                          return Column(
                                            children: [
                                              Dismissible(
                                                onDismissed: (direccion){
                                                  orden.comidas.removeAt(index);
                                                  double sub = 0.0;
                                                  double impuesto = 0.0;
                                                  double total = 0.0;
                                                  if(orden.comidas.isNotEmpty){
                                                    for(int i = 0; i < orden.comidas.length; i++){
                                                      sub += double.parse(orden.comidas[i].cantidad.toString()) * double.parse(orden.comidas[i].price.toString());
                                                    }
                                                    impuesto = sub * double.parse(orden.iva.toString())/100;
                                                    total =  sub+impuesto;
                                                    // ignore: invalid_use_of_protected_member
                                                    keyComidas.currentState!.setState(() {
                                                      orden.subTotal = sub.toStringAsFixed(2);
                                                      orden.impuesto = impuesto.toStringAsFixed(2);
                                                      orden.total = total.toStringAsFixed(2);
                                                    });
                                                  }else{
                                                    // ignore: invalid_use_of_protected_member
                                                    keyComidas.currentState!.setState(() {
                                                      orden.subTotal = "0.00";
                                                      orden.impuesto = "0.00";
                                                      orden.total = "0.00";
                                                    });
                                                  }
                                                },
                                                key: UniqueKey(),
                                                background: Container(
                                                  height: 100,
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
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.8,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                                        color: global.buttonColor.withOpacity(0.7),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 100,
                                                            height: 100,
                                                            decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),
                                                              child: CachedNetworkImage(
                                                                imageUrl: orden.comidas[index].imagen_url.toString(),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SingleChildScrollView(
                                                                child: SizedBox(
                                                                  width: 100,
                                                                  height: 50,
                                                                  child: Center(
                                                                    child: Text(
                                                                      orden.comidas[index].name.toString(),
                                                                      style: const TextStyle(
                                                                          fontFamily: 'alteHaasGrotesk',
                                                                          fontWeight: FontWeight.w500
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SingleChildScrollView(
                                                                child: SizedBox(
                                                                    width: 100,
                                                                    height: 50,
                                                                    child: Center(
                                                                      child: Text(
                                                                        r"Precio: $"+orden.comidas[index].price!.toStringAsFixed(2),
                                                                        style: const TextStyle(
                                                                          fontFamily: 'alteHaasGrotesk',
                                                                        ),
                                                                      ),
                                                                    )
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              decoration:  BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                border: Border.all(color: global.buttonColor,width: 1),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      int cantidad = int.parse(orden.comidas[index].cantidad.toString());
                                                                      cantidad++;
                                                                      orden.comidas[index].cantidad = cantidad.toString();
                                                                      // ignore: invalid_use_of_protected_member
                                                                      keyComidas.currentState!.setState(() {
                                                                        print(orden.iva.toString());
                                                                        orden.comidas[index].cantidad = cantidad.toString();
                                                                        double subAux = 0.0;
                                                                        for(int i = 0; i < orden.comidas.length; i++){
                                                                          double aux = double.parse(orden.comidas[i].cantidad.toString()) * double.parse(orden.comidas[i].price.toString());
                                                                          subAux = subAux + aux;
                                                                        }
                                                                        double sub = subAux;
                                                                        double iva = sub * double.parse(orden.iva.toString())/100;
                                                                        orden.subTotal = sub.toStringAsFixed(2);
                                                                        orden.impuesto = iva.toStringAsFixed(2);
                                                                        orden.total = (sub + iva).toStringAsFixed(2);
                                                                      });
                                                                    },
                                                                    child: SizedBox(
                                                                      height: 38,
                                                                      child: Center(
                                                                        child: Icon(CupertinoIcons.add_circled,color: Theme.of(context).appBarTheme.backgroundColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 1,
                                                                    decoration: BoxDecoration(
                                                                        color: global.buttonColor,
                                                                        borderRadius: BorderRadius.circular(15)
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                    child: Center(
                                                                      child: Text(
                                                                        orden.comidas[index].cantidad.toString(),
                                                                        style: const TextStyle(
                                                                          fontFamily: 'alteHaasGrotesk',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 1,
                                                                    decoration: BoxDecoration(
                                                                        color: global.buttonColor,
                                                                        borderRadius: BorderRadius.circular(15)
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      int cantidad = int.parse(orden.comidas[index].cantidad.toString());
                                                                      if(cantidad > 1){
                                                                        cantidad--;
                                                                        orden.comidas[index].cantidad = cantidad.toString();
                                                                        // ignore: invalid_use_of_protected_member
                                                                        keyComidas.currentState!.setState(() {
                                                                          orden.comidas[index].cantidad = cantidad.toString();
                                                                          double subAux = 0.0;
                                                                          for(int i = 0; i < orden.comidas.length; i++){
                                                                            double aux = double.parse(orden.comidas[i].cantidad.toString()) * double.parse(orden.comidas[i].price.toString());
                                                                            subAux = subAux + aux;
                                                                          }
                                                                          print(subAux);
                                                                          double sub = subAux;
                                                                          double iva = sub * double.parse(orden.iva.toString())/100;
                                                                          orden.subTotal = sub.toStringAsFixed(2);
                                                                          orden.impuesto = iva.toStringAsFixed(2);
                                                                          orden.total = (sub + iva).toStringAsFixed(2);
                                                                        });
                                                                      }
                                                                    },
                                                                    child: SizedBox(
                                                                      height: 38,
                                                                      child: Center(
                                                                        child: Icon(CupertinoIcons.minus_circled,color: Theme.of(context).appBarTheme.backgroundColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.8,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                        color: global.buttonColor.withOpacity(0.7),
                                                      ),
                                                      child: Center(
                                                        child: keysNotas.length > index ?
                                                        TextFormField(
                                                          key: keysNotas[index],
                                                          controller: notaTXT,
                                                          onChanged: (_nota) {
                                                            // ignore: invalid_use_of_protected_member
                                                            keysNotas[index].currentState!.setState(() {
                                                              nota = _nota;
                                                              orden.comidas[index].nota = nota;
                                                            });
                                                          },
                                                          style: TextStyle(
                                                              color: Theme.of(context).brightness ==
                                                                  Brightness.dark
                                                                  ? Colors.white
                                                                  : Colors.black),
                                                          decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.only(left: 10,right: 10),
                                                              fillColor: Theme.of(context).brightness ==
                                                                  Brightness.dark
                                                                  ? Colors.black26
                                                                  : Colors.grey.shade100,
                                                              filled: true,
                                                              hintText: "nota",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(15),
                                                              )),
                                                        )
                                                            : SizedBox(),
                                                      ),

                                                      /*Text(
                                                      orden.comidas[index].nota.toString(),
                                                      style: const TextStyle(
                                                        fontFamily: 'alteHaasGrotesk',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),*/
                                                    )
                                                  ],
                                                ),
                                              ),
                                              (index+1) ==  orden.comidas.length ?
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               children: [
                                                 SizedBox(height: 5),
                                                 const Text(
                                                   "Añadir a la orden",
                                                   style: TextStyle(
                                                     fontFamily: 'alteHaasGrotesk',
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.white,
                                                   ),
                                                 ),
                                                 SizedBox(height: 5),
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                   children: [
                                                     GestureDetector(
                                                       /*onTap: (){
                                                      mostrarMenu();
                                                    },*/
                                                       onLongPress: (){
                                                         setState((){
                                                           grabando = true;
                                                         });

                                                         startRecording();
                                                       },
                                                       onLongPressUp: () async{
                                                         setState((){
                                                           grabando = false;
                                                         });
                                                         Navigator.pop(context);
                                                         audioCargando();
                                                         await stopRecording(mesa: mesa,menu: false);
                                                       },
                                                       child: Container(
                                                         margin: const EdgeInsets.only(top: 10),
                                                         width: MediaQuery.of(context).size.width*0.35,
                                                         height: 100,
                                                         decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(15),
                                                           color: global.buttonColor.withOpacity(0.7),
                                                         ),
                                                         child: Column(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           crossAxisAlignment: CrossAxisAlignment.center,
                                                           children: [
                                                             Text(
                                                               grabando == false ? "Audio" : "Grabando!",
                                                               style: const TextStyle(
                                                                 fontFamily: 'alteHaasGrotesk',
                                                                 fontWeight: FontWeight.bold,
                                                                 //fontSize: 20,
                                                                 color: Colors.black45,
                                                               ),
                                                               textAlign: TextAlign.center,
                                                             ),
                                                             SizedBox(height: 5),
                                                             Container(
                                                               width: 50,
                                                               height: 50,
                                                               decoration: const BoxDecoration(
                                                                 shape: BoxShape.circle,
                                                                 color: Colors.blueAccent,
                                                               ),
                                                               child: Center(
                                                                 child: Icon(Icons.mic,color: grabando == false ? Colors.white : Colors.red),
                                                               ),
                                                             ),
                                                             //SizedBox(height: 10),
                                                             //Icon(CupertinoIcons.add_circled,color: Colors.black45,size: 35,)
                                                           ],
                                                         ),
                                                       ),
                                                     ),
                                                     GestureDetector(
                                                       onTap: (){
                                                         mostrarMenu();
                                                       },
                                                       child: Container(
                                                         margin: const EdgeInsets.only(top: 10),
                                                         width: MediaQuery.of(context).size.width*0.35,
                                                         height: 100,
                                                         decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(15),
                                                           color: global.buttonColor.withOpacity(0.7),
                                                         ),
                                                         child: Column(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           crossAxisAlignment: CrossAxisAlignment.center,
                                                           children: [
                                                             const Text(
                                                               "Digital",
                                                               style: TextStyle(
                                                                   fontFamily: 'alteHaasGrotesk',
                                                                   fontWeight: FontWeight.bold,
                                                                   //fontSize: 20,
                                                                   color: Colors.black45
                                                               ),
                                                               textAlign: TextAlign.center,
                                                             ),
                                                             const SizedBox(height: 5),
                                                             Container(
                                                               width: 50,
                                                               height: 50,
                                                               decoration: const BoxDecoration(
                                                                 shape: BoxShape.circle,
                                                                 color: Colors.blueAccent,
                                                               ),
                                                               child: const Center(
                                                                 child: Icon(Icons.fastfood,),
                                                               ),
                                                             ),
                                                             //SizedBox(height: 10),
                                                             //Icon(CupertinoIcons.add_circled,color: Colors.black45,size: 35,)
                                                           ],
                                                         ),
                                                       ),
                                                     )
                                                   ],
                                                 )
                                               ],
                                             ) : const SizedBox(height: 0),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context,index){
                                          return const SizedBox(height: 10,);
                                        },
                                        itemCount: orden.comidas.length
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "SubTotal",
                                      style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      r"$"+orden.subTotal.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "iva ${orden.iva}%",
                                      style: const TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      r"$"+orden.impuesto.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
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
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      r"$"+orden.total.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        cerrarOrden();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 100,
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
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        try{
                                          print("global.carrito ${global.carrito}");
                                          if(global.carrito == false){
                                            Carrito = [];
                                            foodOrders.clear();
                                          }

                                          global.carrito = true;
                                          print("carrito ${Carrito.length}");
                                          for(int i = 0; i < orden.comidas.length; i++){
                                            DateTime now = DateTime.now();
                                            String formattedDate = DateFormat('yyyy-MM-dd mm:ss').format(now);
                                            Cart nuevo = Cart();
                                            nuevo.food = orden.comidas[i];//food;
                                            nuevo.Fecha = formattedDate;
                                            nuevo.id_restaurante = 157;
                                            nuevo.quantity = int.parse(orden.comidas[i].cantidad.toString());
                                            nuevo.en_restaurante = 1;
                                            nuevo.nota = orden.comidas[i].nota.toString();
                                            setState(() {
                                              Carrito.add(nuevo);
                                            });
                                            print("carrito ${Carrito.length}");
                                          }
                                        }catch(e){
                                          print(e);
                                        }finally{
                                          Navigator.pop(this.context);
                                          audioCargando();
                                          print("carrito ${Carrito.length}");
                                          ordenar(Carrito, mesa: mesa,tax: orden.iva).then((value){
                                            Navigator.pop(this.context);
                                            respuestaOrdenVoz(respuesta: value.toString());
                                            global.carrito = false;
                                            print("global.carrito ${global.carrito}");
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blueAccent,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Ordenar",
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
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
                        ),
                      ],
                    ),
                  ),
                ),
                onWillPop: () async{
                  cerrarOrden();
                  return false;
                },);
            }
          );
        }
    );
  }
  Future<void> mostrarMenu(){
    if(MediaQuery.of(context).orientation == Orientation.landscape)
    {
      double width= MediaQuery.of(context).size.width;
      int widthCard= this.width+40;
      int countRow=width~/widthCard;
      count = countRow;
    }
    else
    {
      double width= MediaQuery.of(context).size.width;
      int widthCard= this.width;
      int countRow=width~/widthCard;
      count = countRow;
    }
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder:(context,setState){
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.9,
                          decoration: BoxDecoration(
                            color: global.buttonColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SingleChildScrollView(
                            child: FutureBuilder<List<Food>>(
                              future: null,
                              initialData: food,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    padding: const EdgeInsets.only(bottom: 0,left: 10,right: 10),
                                    height: MediaQuery.of(context).size.height,
                                    child:   GridView.count(
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                      crossAxisCount: count,
                                      childAspectRatio: (width / height),
                                      scrollDirection: Axis.vertical,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      shrinkWrap: true,
                                      primary: true,
                                      children: List.generate(snapshot.data!.length, (index){
                                        return Menu_Item(foods: snapshot.data![index],index: index,
                                          food:(food){
                                            //_con!.AgregarCarrito(food);
                                            setState((){
                                              food.cantidad = "1";
                                              food.nota="";
                                              orden.comidas.add(food);
                                            });
                                            // ignore: invalid_use_of_protected_member
                                            keyComidas.currentState!.setState((){
                                              double subAux = 0.0;
                                              for(int i = 0; i < orden.comidas.length; i++){
                                                double aux = double.parse(orden.comidas[i].cantidad.toString()) * double.parse(orden.comidas[i].price.toString());
                                                subAux = subAux + aux;
                                              }
                                              double sub = subAux;
                                              double iva = sub * double.parse(orden.iva.toString())/100;
                                              orden.subTotal = sub.toStringAsFixed(2);
                                              orden.impuesto = iva.toStringAsFixed(2);
                                              orden.total = (sub + iva).toStringAsFixed(2);
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                        /*GestureDetector(
                                 child: AnimatedContainer(
                                   duration: Duration(seconds: 1),
                                   height: double.tryParse(height.toString()),
                                   width: 161,
                                   child: SingleChildScrollView(
                                     primary: false,
                                     child: Column(
                                       children: [
                                         const SizedBox(height: 10,),
                                         ClipRRect(
                                           borderRadius: BorderRadius.circular(15),
                                           child: CachedNetworkImage(
                                             fit: BoxFit.fill,
                                             imageUrl: snapshot.data?[index].imagen_url ?? "",
                                             height: 135,
                                             width: 140,
                                             errorWidget: (context, url, error) => const Icon(Icons.error),
                                           ),
                                         ),
                                         Container(
                                           padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               SizedBox(
                                                 height: 35,
                                                 width: 200,
                                                 child: Text(
                                                   snapshot.data![index].name.toString(),
                                                   style: const TextStyle(
                                                     fontFamily: 'alteHaasGrotesk',
                                                     fontWeight: FontWeight.bold,
                                                   ),
                                                 ),
                                               ),
                                               SingleChildScrollView(
                                                 child: SizedBox(
                                                   height: 85,
                                                   width: 200,
                                                   child: Text(
                                                     snapshot.data![index].description.toString(),
                                                     style: const TextStyle(
                                                       fontFamily: 'alteHaasGrotesk',
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                               const SizedBox(height: 5,),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   const Text(
                                                     "Precio",
                                                     style: TextStyle(
                                                       fontFamily: 'alteHaasGrotesk',
                                                       fontWeight: FontWeight.bold,
                                                     ),
                                                   ),
                                                   Text(
                                                     r'$'+snapshot.data![index].price.toString(),
                                                     style: const TextStyle(
                                                       fontFamily: 'alteHaasGrotesk',
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
                                   decoration: BoxDecoration(
                                     color: seleccionado == 0 ? const Color.fromRGBO(0, 31, 36, 1.0) : Colors.lightBlue,
                                     borderRadius: BorderRadius.circular(20),
                                   ),
                                   onEnd: (){
                                     setState(() {
                                       seleccionado = 0;
                                     });
                                     print(seleccionado);
                                   },
                                 ),
                                 onTap: (){
                                   print(seleccionado);
                                   Food _food = snapshot.data![index];
                                   _con!.AgregarCarrito(_food);
                                   Scaffold.of(context).openEndDrawer();
                                   setState(() {
                                     seleccionado = 1;
                                   });
                                   print(seleccionado);
                                 },
                               );*/
                                      },
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Text('${snapshot.error}');
                                }
                                return Center(
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Image.asset("assets/images/ubicacion.gif"),
                                  ),
                                );
                              },
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
        });
  }
  Future<void> audioCargando() async{
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context,setState){
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Theme.of(context).appBarTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const CircularProgressIndicator(),
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
  Future<void> respuestaOrdenVoz({required String respuesta}) async{
    print("entro");
    Carrito.clear();
    return showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context,setState){
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: respuesta != "0" ?
                           ElevatedButton(
                             onPressed: (){
                               Navigator.pop(context);
                             },
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.transparent,
                               padding: EdgeInsets.zero,
                             ),
                             child: Column(
                               children: [
                                 const Text(
                                   "!Orden creada¡",
                                   style: TextStyle(
                                       fontFamily: 'alteHaasGrotesk',
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16
                                   ),
                                 ),
                                 const SizedBox(height: 10),
                                 Lottie.asset('assets/app/check-circle.json'),
                               ],
                             ),
                           ):
                           Column(
                             children: [
                               const Text(
                                 "!Error al crear la orden¡",
                                 style: TextStyle(
                                   fontFamily: 'alteHaasGrotesk',
                                   fontWeight: FontWeight.bold,
                                   fontSize: 16
                                 ),
                               ),
                               const SizedBox(height: 10),
                               GestureDetector(
                                 onTap: (){
                                   Navigator.pop(this.context);
                                 },
                                 child: const Icon(CupertinoIcons.clear_circled_solid,color: Colors.red,size: 50),
                               ),
                             ],
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
  Future<List<String>> directo() async{
    List<String> qr = <String>[];
    qr.add("Bliper_valrodtech");
    qr.add("157");
    qr.add("25.895384");
    qr.add("-108.401349");
    qr.add("Sushiko");
    qr.add("4");
    qr.add("Totalplay-2.4G-acb8");
    qr.add("PbQ6xHBS4gpyD6hr");
    setState(() {
      scanner = false;
    });
    return qr;
  }
  Future<List<String>> scanQR() async {

    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RestauranteWidget(MQTT: (value) {
        enviarMQTT(value[0],value[1]);
      },)),
    );*/
    // ignore: unused_local_variable
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      /*barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);*/
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
   // if (!mounted) return;
    print("barcodeScanRes");
    var barcod = jsonDecode("barcodeScanRes");
    List<String> qr = <String>[];
    if(barcod["verificar"] == "Bliper_valrodtech")
    {
      qr.add(barcod["verificar"]);
      qr.add(barcod["RestauranteID"].toString());
      qr.add(barcod["Lat"].toString());
      qr.add(barcod["Lng"].toString());
      qr.add(barcod["RestauranteNombre"]);
      qr.add(barcod["Mesa"].toString());
      qr.add(barcod["Wifi"]);
      qr.add(barcod["Password"]);
      setState(() {
        scanner = false;
      });
      return qr;
    }
    else{
      qr.add("false");
      return qr;
    }
    //verificar RestauranteID RestauranteNombre Mesa
    /*setState(() {
      _scanBarcode = barcodeScanRes;
    });*/
  }
  Future<List<Object>> scanQRCupon(context) async {

    // ignore: unused_local_variable
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      /*barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);*/
      print("barcodeScanRes");
      /*if(barcodeScanRes.toString() == "-1"){
        Navigator.pop(context);
      }*/
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;
    //print(barcodeScanRes);
    var barcod = jsonDecode("barcodeScanRes");
    List<Object> respuesta = await verficarCupon(barcod["codigo"],barcod["deviceToken"]);
    return respuesta;
  }
  Future<List<Object>> verficarCupon(cupon2,deviceToken) async {

    /*cupon = await VerificarCupon(cupon2,deviceToken);
    cupon!.tokenDevice = deviceToken;
    cupon!.codigo = cupon2;
    if(cupon!.success == "true")
      {
        return true;
      }
    else{
      return false;
    }*/
    List<Object> respuesta = await VerificarCupon(device_token: deviceToken, codigo_cupon: cupon2,);
    return respuesta;
  }
  Future<List<String>> ordenarCupon({required String mesa, required String codigo_cupon, required String client_deviceToken}) async {
    /*
   List<String> respuesta = await ordenar_cupon(deviceToken: cupon!.client_deviceToken,mesa: mesa,codigo: codigo,deviceTokenMesero: user.deviceToken);
   respuestaDialog(respuesta[0],respuesta[1]);
    */
    String codigoChat = "Bliper-";
    const String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    for (var i = 0; i < 10; i++) {
      codigoChat = codigoChat + chars[_rnd.nextInt(chars.length)];
    }

    List<String> respuesta = await ordenar_cupon(client_deviceToken: client_deviceToken, codigo_cupon: codigo_cupon, mesa: mesa, codigo_chat: codigoChat);
    return respuesta;
  }
  Future<void> respuestaDialog(res,mensaje) async {
    Navigator.pop(context);
    Navigator.pop(context);
    return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
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
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.clear),
                          ),
                        ),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.8,
                    color: global.bottomAppBarColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        res == "true"
                            ? Container(
                          height: 50,
                          width: 50,
                          child: const Center(
                            child: Icon(Icons.check),
                          ),
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle
                          ),
                        )
                            : Container(
                          height: 50,
                          width: 50,
                          child: const Center(
                            child: Icon(Icons.clear),
                          ),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          mensaje,
                          style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Ok",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
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
  //final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  Future<void> jpgText(File jpg) async{
    /*InputImage inputImage = InputImage.fromFilePath(jpg.path);

    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);


    String text = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        print(line.text);
        for (TextElement element in line.elements) {
          print(element.text);
          // Same getters as TextBlock
        }
      }
    }
    print("============================");
    print(text.isEmpty);
    print("============================");
    textRecognizer.close();*/
    /*FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(file);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    String w = "";
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          w = w + " "+ word.text.toString();
          print(word.text);
        }
      }
    }*/

    /*String base64JPG = await  base64(jpg.path);
    if(base64JPG != null){
      Uri uri = Uri.parse("https://vision.googleapis.com/v1/images:annotate?key=AIzaSyBJCfjdta4lU8DP7UQIJYXrSevvH2n4igo");
      final client = http.Client();
      String jsonString = '{'
          '"requests": [{'
          '"image": {'
          '"content": "${base64JPG}"'
          '},'
          '"features": [{'
          '"type": "DOCUMENT_TEXT_DETECTION"'
          '}]'
          '}]'
          '}';
      log(jsonString);
      final response = await client.post(
        uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonString,
      );
      //ocrText = jsonDecode(response.body)["responses"];
      //print(jsonDecode(response.body)["responses"][0]["textAnnotations"][0]["description"]);
      ocrText = "";
      try{
        ocrText = jsonDecode(response.body)["responses"][0]["textAnnotations"][0]["description"].toString();
      }catch(e){
        ocrText = "";
        print(e);
      }
      print(w);
      comparar(w);*/
  }
  Future<String> base64(path) async{
    File fileData = File(path);
    List<int> imageBytes = fileData.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
  Future<void> agregarAbreviacion(List<Food> food) async{
    for(int i = 0; i < food.length; i++){
      food_abreviatura nuevo = food_abreviatura();
      nuevo.id = food[i].id!;
      nuevo.abreviatura = food[i].abreviatura!.toUpperCase();
      //print("${food[i].id} : ${food[i].abreviatura}");
      fa.add(nuevo);
    }
  }
  Future<void> comparar(String pedidoss) async {
    print("pedidos $pedidoss");
    idCantidad.clear();
    print("Entro");
    if(pedidoss.isNotEmpty){
      List<String> pedidos = pedidoss.split("-");
      for(int p = 0; p < pedidos.length; p++){
        String ocr = pedidos[p].trim();
        String cantidad = "";
        for (int i = 0; i < 30; i++) {
          if (ocr.contains(i.toString())) {
            cantidad = i.toString();
          }
        }
        if(cantidad == ""){
          cantidad = "1";
        }
        List<String> pedido = ocr.split(cantidad);
        String total = "";
        for (int i = 0; i < pedido.length; i++) {
          for(int b = 0; b < pedido[i].length; b++){
            if(pedido[i][b] != " "){
              total = total + pedido[i][b];
            }
          }
        }
        print(total);
        String id = "";
        int porcentaje = 0;
        int? pocicion;
        for(int i = 0; i < fa.length; i++){
          int aux = 0;
          String ab = fa[i].abreviatura != "" ? fa[i].abreviatura!.toUpperCase() : "";
          print("===========   $ab");
          if(ab.trim() != ""){
            aux = ratio(total.toUpperCase(), ab);
          }

          if(porcentaje < aux){
            porcentaje = aux;
            pocicion = i;
          }
        }
        if(pocicion != null){
          id = fa[pocicion].id.toString();
          print("id :$id");
          String nombre_food = "";
          for(int i = 0; i < food.length; i++){
            if(id == food[i].id){
              nombre_food = food[i].name.toString();
            }
          }
          print("nombre_food :$nombre_food");
          print("$cantidad $nombre_food");
          Food_ID_Cantidad nuevo = Food_ID_Cantidad();
          nuevo.id = id;
          nuevo.cantidad = cantidad;
          idCantidad.add(nuevo);
        }
      }
    }
    if(idCantidad.isNotEmpty){
      double total = 0.0;
      double sub = 0.0;
      double tax = 0.0;
      for(int i = 0; i < idCantidad.length; i++){
        for(int j = 0; j < food.length; j++){
          if(idCantidad[i].id == food[j].id){
            double subAux = double.parse(food[j].price.toString()) * double.parse(idCantidad[i].cantidad.toString());
            food[j].cantidad = idCantidad[i].cantidad.toString();
            orden.comidas.add(food[j]);
            sub = subAux+sub;
          }
        }
      }
      tax = sub * double.parse(global.user.porcentaje_iva)/100;
      total = sub + tax;
      orden.iva = global.user.porcentaje_iva;
      orden.impuesto = tax.toStringAsFixed(2);
      orden.subTotal = sub.toStringAsFixed(2);
      orden.total = total.toStringAsFixed(2);
    }
  }

  Future<void> getCategoria() async{
    String respuesta = await GetCategorias();
    List<dynamic> jsonList = json.decode(respuesta)["data"];
    final parsed = jsonList.cast<Map<String, dynamic>>();
    setState((){
      categorias = parsed.map<Category>((json) => Category.fromJSON(json)).toList();
    });
  }

  Future<void> seleccionarCategoria({required int index}) async{
    //global.cargando(context: context);
    //await Future.delayed(Duration(milliseconds: 500));
    if(categorias[index].seleccionado == true){
      for(int i = 0; i < food.length; i++){
        food[i].mostrar = true;
      }
      setState((){
        categorias[index].seleccionado = false;
        food;
      });
    }else{
      for(int i = 0; i < categorias.length; i++){
        categorias[i].seleccionado = false;
      }
      for(int i = 0; i < food.length; i++){
        if(food[i].category_id == categorias[index].id){
          food[i].mostrar = true;
        }else{
          food[i].mostrar = false;
        }
      }
      setState((){
        categorias[index].seleccionado = true;
        food;
      });
    }
    //Navigator.pop(context);
  }
}

//Cupon aplicado con exito!!!