import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import 'package:state_extended/state_extended.dart';
import '../models/food.dart';
import 'menu.dart';
import '../controllers/global.dart' as global;

class AsiganacionQRWidget extends StatefulWidget {
  final List<Food> food;
  const AsiganacionQRWidget({required this.food});
  @override
  _AsiganacionQRWidgetState createState() => _AsiganacionQRWidgetState();
}

class _AsiganacionQRWidgetState extends StateX<AsiganacionQRWidget>{
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Escaner QR".toUpperCase(),
          style: const TextStyle(
            fontFamily: 'alteHaasGrotesk',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
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
                        "¡Escanea el centro de mesa para asignar la mesa!",
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
  }

  Future<void> Cargando({json}) async{
    if(json["verificar"] == "Bliper_valrodtech"){
      try{
        Future.delayed(const Duration(seconds: 1),(){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuWidget(
              deviceToken: global.token,
              mesa: json["Mesa"].toString(),
            )),
          );
        });
      }catch(e){
        print(VertexMode.triangles.toString());
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