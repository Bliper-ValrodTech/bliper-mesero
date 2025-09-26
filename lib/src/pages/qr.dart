import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;

class QrWidget extends StatefulWidget {
  final ValueChanged<List<String>> info;
  const QrWidget({required this.info});

  @override
  _QrWidgetState createState() => _QrWidgetState();
}

class _QrWidgetState extends StateX<QrWidget> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //Barcode? result;
  //QRViewController? controller_QR;
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
     // controller_QR!.pauseCamera();
    } else if (Platform.isIOS) {
      //controller_QR!.resumeCamera();
    }
  }

  @override
  void dispose() {
    //controller_QR?.dispose();
    super.dispose();
  }
  bool on = false;
  Future<void> aprenderApagar() async {
    if(on){
      on = false;
    }
    else
      {
        on = true;
      }
    setState(() {
      on;
    });
    //controller_QR?.toggleFlash();
  }

  @override
  void initState() {
    super.initState();
  }

  String estado = " ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scanner ${global.user.restaurant_name}"
        ),
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          /*QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            formatsAllowed: const [
              BarcodeFormat.qrcode
            ],
          ),*/
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: global.bottomAppBarColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: global.buttonColor,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: global.buttonColor,
                          spreadRadius: -1,
                          blurRadius: 4,
                          //offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: global.user.logo.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      aprenderApagar();
                    },
                    child: Icon( on == false ? CupertinoIcons.lightbulb_fill : CupertinoIcons.lightbulb_slash_fill,size: 30),
                  ),
                  const SizedBox(width: 50,),
                ],
              ),
            )
          ),
          Center(
            child: CustomPaint(
              foregroundPainter: BorderPainter(context: this.context),
              child: Container(
                width: 200,
                height: 200,
                color: Colors.transparent,
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
                    offset: Offset(0, 3), // changes position of shadow
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
                        "¡Escanear el codigo QR para crear la orden!",
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
          )
        ],
      ),
    );
  }
  void regresarInfo(String code){
    var json = jsonDecode(code);
    if(json["verificar"].toString() == "Bliper_valrodtech"){
      print(json["verificar"]);
      print(json["RestauranteID"]);
      print(json["Lat"]);
      print(json["Lng"]);
      print(json["RestauranteNombre"]);
      print(json["Mesa"]);
      print(json["Wifi"]);
      print(json["Password"]);
      setState(() {
        estado = "exito";
      });
    }
    else{
      setState(() {
        estado = "error";
      });
      print("Eror al leer el QR");
    }
  }
  Future<void> leerQR() async{
    return showDialog(
        context: context,
        builder: (context){
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {

            },
            child: EscaneandoQr(estado: estado));
        }
    );
  }
}
class EscaneandoQr extends StatefulWidget{
  final String estado;
  const EscaneandoQr({required this.estado});

  @override
  _EscaneandoQrState createState() => _EscaneandoQrState();
}

class _EscaneandoQrState extends StateX<EscaneandoQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black45,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: global.bottomAppBarColor
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.estado == " "
                   ? const Text(
                      "¡Escaneando el QR!",
                      style: TextStyle(
                        fontFamily: 'alteHaasGrotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                     )
                   : widget.estado == "error"
                   ? const Text(
                      "¡A ocurrido un error al escanear el codigo qr ó escaneo un codigo qr no valido!",
                      style: TextStyle(
                        fontFamily: 'alteHaasGrotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                   : widget.estado == "exito"
                   ? const Text(
                      "¡Se escaneo correctamente el codigo qr!",
                      style: TextStyle(
                        fontFamily: 'alteHaasGrotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                   : const SizedBox(),
                    const SizedBox(height: 20),
                    widget.estado == " "
                   ? SizedBox(
                      height: 100,
                      width: 100,
                      child: Stack(
                        children: const [
                          Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Icon(CupertinoIcons.qrcode,size: 70),
                            ),
                          ),
                        ],
                      ),
                    )
                  : widget.estado == "error"
                  ? const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(CupertinoIcons.clear_circled,size: 70,color: Colors.red),
                        ),
                      ),
                    )
                  : widget.estado == "exito"
                  ? const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(CupertinoIcons.checkmark_alt_circle,size: 70,color: Colors.greenAccent),
                        ),
                      ),
                    )
                  : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
