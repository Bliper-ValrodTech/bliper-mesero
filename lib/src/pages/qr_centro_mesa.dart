import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../controllers/centros_controller.dart';
import 'configurar_centroMesa.dart';
import 'mesas.dart';

class QrCentroMesaWidget extends StatefulWidget {
  const QrCentroMesaWidget();

  @override
  _QrCentroMesaWidgetState createState() => _QrCentroMesaWidgetState();
}

class _QrCentroMesaWidgetState extends StateX<QrCentroMesaWidget> {
  late CentrosControlller con;

  _QrCentroMesaWidgetState() : super(controller: CentrosControlller()) {
    con = controller as CentrosControlller;
  }
  int count = 0;
  int width = 135;
  int height = 160;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //Barcode? result;
  //QRViewController? controller_QR;

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      //controller_QR!.pauseCamera();
    } else if (Platform.isIOS) {
      //controller_QR!.resumeCamera();
    }
  }

  @override
  void dispose() {
    //controller_QR?.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Centros de mesas",
            style: TextStyle(
              fontFamily: 'alteHaasGrotesk',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(CupertinoIcons.sidebar_left)),
              Tab(icon: Icon(CupertinoIcons.qrcode)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 0,left: 10,right: 10),
              height: MediaQuery.of(context).size.height,
              child: con.centros.isEmpty
               ?  Center(
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
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: Image.asset("assets/app/centro_mesa.png",color: global.buttonColor),
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
                shrinkWrap: true,
                primary: true,
                children: List.generate(con.centros.length, (index){
                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor
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
                                    Image.asset("assets/app/centro_mesa.png"),
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
                                          color: global.buttonColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                        SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  con.centros[index].code.toString(),
                                  style: TextStyle(
                                      fontFamily: 'alteHaasGrotesk',
                                      fontWeight: FontWeight.bold,
                                      //fontSize: 20,
                                      color: global.buttonColor
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigurarCentros(
                                    mesa: con.centros[index].mesa_number.toString(),
                                    code:con.centros[index].code.toString(),
                                    nombre_mesero: con.centros[index].mesero_name.toString(),
                                    id_mesero: con.centros[index].mesero_id.toString(),
                                    Notificar: (value){
                                      if(value == 1){
                                        con.obtenerCentros();
                                        setState(() { });
                                      }
                                    },
                                  ),
                                  ),
                                  );
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
                                      "Configurar",
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
                          ),
                        ),
                      ],
                    ),
                  );
                },
                ),
              ),
            ),
            Stack(
              children: [
                /*QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  formatsAllowed: const [
                    BarcodeFormat.qrcode
                  ],
                ),*/
                Positioned(
                  top: MediaQuery.of(context).size.height*0.25,
                  left: MediaQuery.of(context).size.width*0.25,
                  child: Center(
                    child: CustomPaint(
                      foregroundPainter: BorderPainter(context: this.context),
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: global.bottomAppBarColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: global.buttonColor,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: const [
                            Text(
                              "¡Escanea el centro de mesa para configurarlo!",
                              style: TextStyle(
                                fontFamily: 'alteHaasGrotesk',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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

  Future<void> Cargando({json}) async{
    if(json["verificar"] == "Bliper_valrodtech"){
      if(json["Tipo"] == "Mesa"){
        String mesa = json["Mesa"];
        Future.delayed(Duration(seconds: 2),(){
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MesasWidget(
              numero_mesa: mesa,
              notificar: (int value) {
                if(value == 1){
                  //controller_QR!.resumeCamera();
                }
                if(value == 2){
                  con.obtenerCentros();
                }
              },)),
          );
        });
      }
      else if(json["Tipo"] == "CentroMesa"){
        con.obtenerCentroMesa(codigo: json["Code"]).then((value){
          if(con.centro!.id.toString() != "0"){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigurarCentros(
                mesa: con.centro!.mesa_number.toString(),
                code:con.centro!.code.toString(),
                nombre_mesero: con.centro!.mesero_name.toString(),
                id_mesero: con.centro!.mesero_id.toString(),
                Notificar: (value){
                  if(value == 1){
                    //controller_QR!.resumeCamera();
                    con.obtenerCentros();
                    setState(() { });
                  }
                },
               )),
              );
          }
          else
            {
              Future.delayed(const Duration(seconds: 2),(){
                Navigator.of(context).pop();
                errorScaner();
              });
            }
        });
      }
      else{
        Future.delayed(const Duration(seconds: 2),(){
          Navigator.of(context).pop();
          errorScaner();
        });
      }
    }
    else
      {
        Future.delayed(const Duration(seconds: 2),(){
          Navigator.of(context).pop();
          errorScaner();
        });
      }
    return showDialog(
        context: context,
        builder: (context){
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "¡Analizando QR!",
                          style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        CircularProgressIndicator(),
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
  Future<void> errorScaner() async{
    return showDialog(
        context: context,
        builder: (context){
          return WillPopScope(
              child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "¡Error al escanear el QR ó escaneo un QR no perteneciente a Bliper!",
                          style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 20),
                        Icon(CupertinoIcons.clear_circled,color: Colors.redAccent,size: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
              onWillPop: () async {
                //controller_QR!.resumeCamera();
                return true;
          });
        }
    );
  }
 /* Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Centros de mesa",
          style: TextStyle(
            fontFamily: 'alteHaasGrotesk',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
          children: List.generate(10, (index){
            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueAccent
              ),
              child: Column(),
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
                                   con.AgregarCarrito(_food);
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
      ),
    );
  }*/
 /* final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller_QR;
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller_QR!.pauseCamera();
    } else if (Platform.isIOS) {
      controller_QR!.resumeCamera();
    }
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller_QR = controller;
    controller.scannedDataStream.listen((scanData) {
      //controller.pauseCamera();
    });
  }
  @override
  void dispose() {
    controller_QR?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       centerTitle: true,
       title: const Text(
         "Centros de mesa",
         style: TextStyle(
           fontFamily: 'alteHaasGrotesk',
           fontWeight: FontWeight.bold,
           fontSize: 20,
         ),
       ),
     ),
     body: Stack(
       children: [
         QRView(
           key: qrKey,
           onQRViewCreated: _onQRViewCreated,
           formatsAllowed: const [
             BarcodeFormat.qrcode
           ],
         ),
         Positioned(
           top: MediaQuery.of(context).size.height*0.25,
           left: MediaQuery.of(context).size.width*0.25,
           child: Center(
             child: CustomPaint(
               foregroundPainter: BorderPainter(context: this.context),
               child: Container(
                 width: 200,
                 height: 200,
                 color: Colors.transparent,
               ),
             ),
           ),
         ),
         Positioned(
           bottom: 0,
           child: Container(
             width: MediaQuery.of(context).size.width,
             height: 100,
             decoration: BoxDecoration(
               color: Theme.of(context).bottomAppBarColor,
               borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
               boxShadow: [
                 BoxShadow(
                   color: Theme.of(context).buttonColor,
                   spreadRadius: 5,
                   blurRadius: 7,
                   offset: const Offset(0, 3), // changes position of shadow
                 ),
               ],
             ),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Wrap(
                   alignment: WrapAlignment.center,
                   children: const [
                     Text(
                       "¡Escanea el centro de mesa para configurarlo!",
                       style: TextStyle(
                         fontFamily: 'alteHaasGrotesk',
                         fontWeight: FontWeight.bold,
                         fontSize: 20,
                       ),
                       textAlign: TextAlign.center,
                     ),
                   ],
                 ),
               ],
             ),
           ),
         ),
       ],
     ),
   );
  }*/
}
class BorderPainter extends CustomPainter {
  final BuildContext context;
  BorderPainter({required this.context});
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = global.buttonColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}