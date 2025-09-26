import 'dart:io';
import 'package:bliper_mesero/src/elements/cart.dart';
import 'package:bliper_mesero/src/controllers/menu_controller.dart' as mc;
import 'package:bliper_mesero/src/elements/side_menu.dart';
import 'package:bliper_mesero/src/models/food.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribble/scribble.dart';
import '../elements/categoria.dart';
import '../elements/contador_mano.dart';
import '../elements/menu_item.dart';
import '../elements/mic.dart';
import '../models/cupon.dart';
import '../models/orden_voz.dart';
import '../controllers/global.dart' as global;
import 'package:state_extended/state_extended.dart';

class MenuWidget extends StatefulWidget {
  final String deviceToken;
  final String mesa;
  const MenuWidget({super.key, required this.mesa,required this.deviceToken});

@override
_MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends StateX<MenuWidget> with SingleTickerProviderStateMixin {
  late mc.MenuController con;

  _MenuWidgetState() : super(controller: mc.MenuController()) {
    con = controller as mc.MenuController;
  }

  late Future<Food> futureFood;
  Widget body =  const SizedBox(width: 0,);
  late ScribbleNotifier notifier;
  late TabController _tabController;
  int _activeIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  initState() {
    con.deviceToken = widget.deviceToken;
    con.context = context;
    con.getFoods();
    con.agregarAbreviacion(con.food);
    con.getCategoria();

    _tabController = TabController(
      length: 3, vsync: this,
    );
    notifier = ScribbleNotifier();
    super.initState();
  }

  int count = 0;
  int width = 135;
  int height = 250;
  //bool mic = false;
  double opacity = 0.0;
  bool showMic = false;
  String Mesa = "";
  bool mostrarOpcion = true;
  bool qr = true;
  String cupon="";
  bool tradicional = false;

  @override
  Widget build(BuildContext context)  {
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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        back();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(_activeIndex == 2 ? 'assets/app/fondo_light.jpg' : 'assets/app/fondo_dark.jpg'),
              fit: BoxFit.fitWidth),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: NavDrawer(
            onTapcCancelar: (value) {
            },
          ),
          endDrawer: CartDrawer(
            mesa: int.parse(widget.mesa.toString()),
            carrito: con.Carrito,
            onTapcCancelar: (index){ if(index == 1 ){setState(() {con.Carrito.clear();});}},
          ),
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                )
              ],
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Mesa ${widget.mesa}".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'alteHaasGrotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
          ),

          body: Stack(
            children: [
              DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    leading: const SizedBox(),
                    bottom: TabBar(
                      controller: _tabController,
                      onTap: (value){
                        print(value);
                        setState(() {
                          _activeIndex = value;
                          _tabController.index = value;
                        });
                      },
                      tabs: [
                        Tab(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.fastfood,
                                color: Colors.white,
                              ),
                              Text(
                                "Digital",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                            child: Column(
                              children: [
                                Image.asset("assets/app/mic.png",width: 25,height: 25,color: Colors.white,),
                                const Text(
                                  "Orden audio",
                                  style: TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                        Tab(
                          child:  Column(
                            children: [
                              Image.asset("assets/images/escribir.png",width: 25,height: 25,color: Colors.white,),
                              const Text(
                                "Tradicional",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      Stack(
                        children: [
                          con.food.isEmpty ?
                          const Center(
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(),
                            ),
                          ) :
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(con.categorias.length, (index) {
                                        return Row(
                                          children: [
                                            CategoriaWidget(
                                              categoria: con.categorias[index],
                                              seleccionado: (value){
                                                con.seleccionarCategoria(index: index);
                                              },
                                            ),
                                            const SizedBox(width: 10,),
                                          ],
                                        );
                                      },),
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children:  con.food
                                        .asMap()
                                        .entries
                                        .where((entry) => entry.value.mostrar)
                                        .map((entry) {
                                      final index = entry.key;
                                      final foodItem = entry.value;
                                      return Menu_Item(
                                        foods: foodItem,
                                        index: index,
                                        key: Key(index.toString()),
                                        food: (food) {
                                          print("id ${food.id}");
                                          con.AgregarCarrito(food);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Mic(
                          status: (status) async{
                            if(status == 0){
                              con.startRecording();
                            }
                            else if(status == 1){
                              con.audioCargando();
                              await con.stopRecording(mesa: widget.mesa, menu: true);
                              //enviarMQTT(retorno);
                            }
                          }
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height*0.778,
                          child: Stack(
                            children: [
                              Scribble(
                                notifier: notifier,
                                drawPen: true,
                              ),
                              ElevatedButton(
                                onPressed: (){
                                  _saveImage(context);

                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(10),
                                ),
                                child: const Icon(Icons.save,size: 30),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Column(
                                  children: [
                                    _buildColorToolbar(context),
                                    const Divider(
                                      height: 32,
                                    ),
                                    _buildStrokeToolbar(context),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Column(
                  children: [
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(45,204,211,1.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0,0,0, 1.0),
                                      spreadRadius: 3,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: const Icon(CupertinoIcons.tickets),
                              ),
                              onTap: (){
                                scannearCupon();
                              },
                            ),
                          ],
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
  }
  void cambiarQRCodigo() {
    if(qr == false)
      {
        setState(() {
          body = codigo();
        });
      }
    else
      {
        setState(() {
          body = qrScanner();
        });
      }
  }
  void cambiarBody({List<String>? respuestaQR}) {
    if(con.scanner == true)
    {
      cambiarQRCodigo();
    }
    else
    {
      if(respuestaQR == null)
        {
          cambiarQRCodigo();
        }
      else
        {
          setState(() {
            print("========================");
            print(respuestaQR[5]);
            print("========================");
            Mesa = respuestaQR[5];
            body = menu(respuestaQR: respuestaQR);
          });
        }
    }
  }
  Widget codigo() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50,right: 50),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                     const Text(
                        "Mesa",
                        style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                     const SizedBox(width: 10,),
                      Image.asset("assets/images/escribir.png",width: 25,height: 25,color: Colors.white,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: TextField(
                            onChanged: (_Mesa) {
                              setState(() {
                                Mesa = _Mesa;
                              });
                            },
                            style: TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                                fillColor: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.black26
                                    : Colors.grey.shade100,
                                filled: true,
                                hintText: "Mesa",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            mostrarOpcion = false;
                            con.scanner = false;
                            if(Mesa == "")
                              {

                              }
                            body = menu();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(45,204,211,1.0),
                          ),
                          child: const Center(
                            child: Icon(CupertinoIcons.arrowtriangle_right_fill,color: Color.fromRGBO(0, 31, 36, 1.0),),
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
    );
  }
  Widget qrScanner() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.11),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 190,
                height: 190,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(45,204,211,1.0)
                ),
                child: Image.asset("assets/images/qr.png",),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.12,
              ),
              SizedBox(
                width: 249,
                height: 62,
                child: ElevatedButton(
                  onPressed: () async {
                    try
                    {
                      await con.scanQR().then((value){
                        if(value[0] != "false")
                        {

                          cambiarBody(respuestaQR: value);
                        }
                        else
                        {
                          print("error al escanear qr");
                        }
                      });
                    }catch(e)
                    {
                      print(e);
                    }
                  },
                  child: const Text(
                    "Escanear",
                    style: TextStyle(
                        fontFamily: 'alteHaasGrotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      return const Color.fromRGBO(45,204,211,1.0);
                    }),
                    shape: WidgetStateProperty.resolveWith((states) {
                      return const StadiumBorder();
                    }),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.1),
              const Text(
                "¡Escanea el qr de la mesa para ordenar!",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget menu({respuestaQR}) {
   return Stack(
     children: [
       DefaultTabController(
         length: 3,
         child: Scaffold(
           backgroundColor: Colors.transparent,
           appBar: AppBar(
             bottom: TabBar(
               controller: _tabController,
               onTap: (value){
                 print(value);
                 setState(() {
                   _activeIndex = value;
                   _tabController.index = value;
                 });
               },
               tabs: [
                 Tab(
                   child: Column(
                     children: const [
                       Icon(
                         Icons.fastfood,
                         color: Colors.white,
                       ),
                       Text(
                         "Digital",
                         style: TextStyle(
                           fontFamily: 'alteHaasGrotesk',
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Tab(
                     child: Column(
                       children: [
                         Image.asset("assets/app/mic.png",width: 25,height: 25,color: Colors.white,),
                         const Text(
                           "Orden audio",
                           style: TextStyle(
                             fontFamily: 'alteHaasGrotesk',
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     )),
                 Tab(
                   child:  Column(
                     children: [
                       Image.asset("assets/images/escribir.png",width: 25,height: 25,color: Colors.white,),
                       const Text(
                         "Tradicional",
                         style: TextStyle(
                           fontFamily: 'alteHaasGrotesk',
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
           body: TabBarView(
             controller: _tabController,
             children: [
               Stack(
                 children: [
                   FutureBuilder<List<Food>>(
                     future: null,
                     initialData: con.food,
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
                               /*return Menu_Item(snapshot: snapshot,index: index,
                                 food:(food){
                                   con.AgregarCarrito(food);
                                 },
                               );*/
                               return SizedBox();
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
                 ],
               ),
               Mic(
                   status: (status) async{
                     if(status == 0){
                       con.startRecording();
                     }
                     else if(status == 1){
                       await con.stopRecording(mesa: widget.mesa, menu: true);
                     }
                   }
               ),
               SingleChildScrollView(
                 child: SizedBox(
                   height: MediaQuery.of(context).size.height * 2,
                   child: Stack(
                     children: [
                       Positioned(
                         top: 16,
                         left: 16,
                         child: GestureDetector(
                           onTap: (){
                             //cargarCupon();
                             //_saveImage(context);
                             //print("entro ==================");
                           },
                           child: Container(
                             width: 50,
                             height: 50,
                             decoration: const BoxDecoration(
                               color: Colors.lightBlue,
                               shape: BoxShape.circle,
                             ),
                             child: const Center(
                               child: Icon(Icons.save),
                             ),
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
       ),
       Positioned(
         child: Column(
           children: [
             const SizedBox(height: 5,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Column(
                   children: [
                     GestureDetector(
                       child: Container(
                         width: 40,
                         height: 40,
                         decoration: const BoxDecoration(
                           shape: BoxShape.circle,
                           color: Color.fromRGBO(45,204,211,1.0),
                           boxShadow: [
                             BoxShadow(
                               color: Color.fromRGBO(0,0,0, 1.0),
                               spreadRadius: 3,
                               blurRadius: 3
                             )
                           ]
                         ),
                         child: const Icon(CupertinoIcons.tickets),
                       ),
                       onTap: (){
                         scannearCupon();
                       },
                     ),
                   ],
                 ),
               ],
             ),
           ],
         ),
       ),
     ],
   );
  }
  Future<bool> back() async {
    return true;
  }
  Future<void> cuponMenu() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black45,
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     GestureDetector(
                       child: Container(
                         width: 25,
                         height: 25,
                         decoration: const BoxDecoration(
                           shape: BoxShape.circle,
                           color: Colors.red,
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
                   color: Colors.amber,
                 ),
               ],
              ),
            );
          },
        );
      },
    );
  }
  Future<void> scannearCupon() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: global.bottomAppBarColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Escanear Cupon".toUpperCase(),
                                      style: const TextStyle(
                                          fontFamily: 'alteHaasGrotesk',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () async{
                                    try
                                    {
                                      cargarCupon();
                                      List<Object> resp = await con.scanQRCupon(context);
                                      if(resp[0] == "true")
                                      {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        print("===============");
                                        mostrarCupon(succes: resp[0].toString(),cupon: resp[1] as Cupon);
                                      }
                                      else{
                                        //Navigator.pop(context);
                                        CuponError(succes: resp[0].toString(), mensaje: resp[1].toString());
                                      }
                                    }catch(e)
                                    {
                                      print(e);
                                    }
                                  },
                                  child:  Container(
                                    width: 160,
                                    height: 160,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(45,204,211,1.0)
                                    ),
                                    child: Center(
                                      child: Icon(CupertinoIcons.qrcode,size: 100,color: global.bottomAppBarColor,),
                                    ),
                                  ),
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
        );
      },
    );
  }
  Future<void> CuponError({required String succes, required String mensaje}) {
    Navigator.pop(context);
    return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              const Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: Colors.red,
                                size: 100,
                              ),
                              Text(
                                mensaje.toString(),
                                style: const TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ]
                        ),
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
  Future<void> cargarCupon() async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> mostrarCupon({required String succes,required Cupon cupon}) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent
                        ),
                        child: const SizedBox(),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height*0.6,
                            color: global.bottomAppBarColor,
                            child: succes.toString() == "true" ?
                            Column(
                              children: [
                                const SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Detalles del cupon".toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: const [
                                    SizedBox(width: 10),
                                    Text(
                                      "Productos",
                                      style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Expanded(
                                  child: ListView.separated(
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width-20,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: const Color.fromRGBO(0, 119, 125,0.9)),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                    child: ClipRRect(
                                                      child: Image.network(cupon.detalle![index].food!.imagen_url.toString(),fit: BoxFit.cover,),
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  SingleChildScrollView(
                                                    child: SizedBox(
                                                      width: 165,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            cupon.detalle![index].food!.name.toString(),
                                                            style: const TextStyle(
                                                              fontFamily: 'alteHaasGrotesk',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 70,
                                                            child: Text(
                                                              cupon.detalle![index].food!.description.toString(),
                                                              style: const TextStyle(
                                                                fontFamily: 'alteHaasGrotesk',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 98,
                                                    width: MediaQuery.of(context).size.width*0.23,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            const Text(
                                                              "Cantidad",
                                                              style: TextStyle(
                                                                fontFamily: 'alteHaasGrotesk',
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 50,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                border: Border.all(color: const Color.fromRGBO(0, 119, 125,0.9)),
                                                              ),
                                                              alignment: Alignment.center,
                                                              child:  Text(
                                                                cupon.detalle![index].cantidad.toString(),
                                                                style: const TextStyle(
                                                                  fontFamily: 'alteHaasGrotesk',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              r"$"+cupon.detalle![index].food!.price.toString(),
                                                              style: const TextStyle(
                                                                fontFamily: 'alteHaasGrotesk',
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
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10,);
                                      },
                                      itemCount: cupon.detalle!.length
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Precio sin descuento: ",
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            r"$"+double.parse(cupon.total_sin_descuento.toString()).toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Precio con descuento: ",
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            r"$"+double.parse(cupon.total_con_descuento.toString()).toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).pop();
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
                                          border: Border.all(color: Colors.blueAccent),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Ordenar",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      onTap: () async{
                                        cargarCupon();
                                        List<String> res = await con.ordenarCupon(mesa: widget.mesa.toString(),codigo_cupon: cupon.code.toString(),client_deviceToken: cupon.client_deviceToken.toString());
                                        respuesta(succes: res[0], mensaje: res[1]);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                              ],
                            ) :
                            Center(child: Image.asset("assets/images/ubicacion.gif")),
                          ),
                        ],
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
  Future<void> respuesta({required String succes, required String mensaje}) async{
    return showDialog(
      context: context,
      builder: (context){
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).appBarTheme.backgroundColor
                      ),
                      child: Column(
                        children: [
                          succes == "false" ?
                            const Icon(
                            CupertinoIcons.clear_circled_solid,
                            size: 100,
                            color: Colors.red,
                          ) :
                          Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            size: 100,
                            color: global.buttonColor,
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                mensaje,
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
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  void obtenerCupon({required String codigo}) async {
  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ordenes.png');
  }
  Future<void> _saveImage(BuildContext context) async {
    cargarCupon();
    final image = await notifier.renderImage();
    Image.memory(image.buffer.asUint8List());
    final file = await _localFile;

    final files = await File(file.path).writeAsBytes(image.buffer.asUint8List(image.offsetInBytes, image.lengthInBytes));
    String r = await con.ocr_img(img: files);

    print("r $r");
    List<String> respuestas = r.split("\n");
    con.orden = OrdenVoz();

    for(int i=0; i<respuestas.length; i++){
      print(respuestas[i]);
      con.comparar(respuestas[i]);
      print(con.idCantidad.isEmpty);
      if(con.idCantidad.isNotEmpty){
        Future.delayed(const Duration(seconds: 1),(){
          Navigator.pop(context);
        });
        break;
      }
    }
    if(con.idCantidad.isEmpty){
      mostrarTexto();
    }

  }
  Future<void> mostrarTexto() async {
    Navigator.pop(context);
    List<Food> foods = <Food>[];
    for(int i = 0; i < con.idCantidad.length; i++){
      for(int b = 0; b < con.food.length; b++){
        if(con.idCantidad[i].id.toString() == con.food[b].id.toString()){
          Food nuevo = Food();
          nuevo = con.food[b];
          foods.add(nuevo);
        }
      }
    }
    print(foods.length);
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
                foods.isEmpty ?
                Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  height: MediaQuery.of(context).size.height*0.3,
                  color: global.bottomAppBarColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Lo siento no entendi la orden.",
                        style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "¿puede volver a escribir?",
                        style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.lightBlue
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    :
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.5,
                  decoration: BoxDecoration(
                      color: global.bottomAppBarColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Orden",
                            style: TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.4-50,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.8,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl:  foods[index].imagen_url ?? "",
                                                height: 100,
                                                width: 100,
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              height: 100,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    height: 60,
                                                    width:MediaQuery.of(context).size.width*0.8-150,
                                                    child: Text(
                                                      foods[index].name.toString(),
                                                      style: const TextStyle(
                                                        fontFamily: 'alteHaasGrotesk',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  ContadorMano(cantidad: int.parse(con.idCantidad[index].cantidad.toString()),contador: (value){
                                                    con.idCantidad[index].cantidad = value.toString();
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                            separatorBuilder: (context,index){
                              return const SizedBox(height: 0);
                            },
                            itemCount: foods.length
                        ),
                      ),
                      Expanded(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
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
                            onTap: (){
                              con.AgregarCarrito("Comida", foods: foods,idCantidad:con.idCantidad,mano: true);
                              notifier.clear();
                              Navigator.pop(context);
                              con.ordenar(con.Carrito,mesa: int.parse(widget.mesa));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15),
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
                      )),
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
  Widget _buildStrokeToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in notifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }
  Widget _buildStrokeButton( BuildContext context, { required double strokeWidth, required ScribbleState state,}) {
    final selected = state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => notifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
            decoration: BoxDecoration(
                color: state.map(
                  drawing: (s) => Color(s.selectedColor),
                  erasing: (_) => Colors.transparent,
                ),
                border: state.map(
                  drawing: (_) => null,
                  erasing: (_) => Border.all(width: 1),
                ),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }
  Widget _buildColorToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //_buildUndoButton(context),
          const Divider(
            height: 4.0,
          ),
          //_buildRedoButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildClearButton(context),
          const Divider(
            height: 20.0,
          ),
          _buildPointerModeSwitcher(context,
              penMode:
              state.allowedPointersMode == ScribblePointerMode.penOnly),
          const Divider(
            height: 20.0,
          ),
          _buildEraserButton(context, isSelected: state is Erasing),
          _buildColorButton(context, color: Colors.black, state: state),
          //_buildColorButton(context, color: Colors.red, state: state),
          //_buildColorButton(context, color: Colors.green, state: state),
          //_buildColorButton(context, color: Colors.blue, state: state),
          //_buildColorButton(context, color: Colors.yellow, state: state),
        ],
      ),
    );
  }
  Widget _buildPointerModeSwitcher(BuildContext context, {required bool penMode}) {
    return FloatingActionButton.small(
      onPressed: () => notifier.setAllowedPointersMode(
        penMode ? ScribblePointerMode.all : ScribblePointerMode.penOnly,
      ),
      tooltip:
      "Switch drawing mode to ${penMode ? "all pointers" : "pen only"}",
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: !penMode
            ? const Icon(
          Icons.touch_app,
          key: ValueKey(true),
        )
            : const Icon(
          Icons.do_not_touch,
          key: ValueKey(false),
        ),
      ),
    );
  }
  Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        tooltip: "Erase",
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: isSelected ? 10 : 2,
        shape: !isSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: notifier.setEraser,
        child: const Icon(Icons.remove, color: Colors.blueGrey),
      ),
    );
  }
  Widget _buildColorButton( BuildContext context, { required Color color, required ScribbleState state,}) {
    final isSelected = state is Drawing && state.selectedColor == color;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          backgroundColor: color,
          elevation: isSelected ? 10 : 2,
          shape: !isSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: "Clear",
      onPressed: notifier.clear,
      disabledElevation: 0,
      backgroundColor: Colors.blueGrey,
      child: const Icon(Icons.clear),
    );
  }
}