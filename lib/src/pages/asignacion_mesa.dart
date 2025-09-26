import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../elements/side_menu.dart';
import '../models/food.dart';
import 'asignacion_manual.dart';
import 'asignacion_qr.dart';
import '../controllers/global.dart' as global;

class AsiganacionMesaWidget extends StatefulWidget {
  final ValueChanged<int> onTapcCancelar;
  final List<Food> food;
  const AsiganacionMesaWidget({super.key, required this.food, required this.onTapcCancelar});
  @override
  _AsiganacionMesaWidgetState createState() => _AsiganacionMesaWidgetState();
}

class _AsiganacionMesaWidgetState extends StateX<AsiganacionMesaWidget>{
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/app/fondo_dark.jpg'),
              fit: BoxFit.fitWidth),
        ),
        child: Scaffold(
          drawer: NavDrawer(
            onTapcCancelar: (value) {
              if (value == 1) {
                widget.onTapcCancelar(value);
              }
            },
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Asignacion mesa".toUpperCase(),
              style: const TextStyle(
                fontFamily: 'alteHaasGrotesk',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.9,
              child: Center(
                      heightFactor: 10,
                      child: SingleChildScrollView(
                          child:Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: global.buttonColor.withValues(alpha: 0.5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Escanear QR de la mesa",
                                      style:  TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(45,204,211,1.0)
                                          ),
                                          child: Image.asset("assets/images/qr.png",),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => AsiganacionQRWidget(
                                                food: widget.food,
                                              )),
                                            );
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: global.buttonColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child:  Center(
                                              child: Text(
                                                "Escanear",
                                                style:  TextStyle(
                                                    fontFamily: 'alteHaasGrotesk',
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).appBarTheme.backgroundColor
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
                              const SizedBox(height: 25),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
                                width: MediaQuery.of(context).size.width,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: global.buttonColor.withValues(alpha: 0.5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Escoger la mesa",
                                      style: TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          padding: const EdgeInsets.all(15),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(45,204,211,1.0)
                                          ),
                                          child: Image.asset("assets/images/mesa.png",),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            global.paginas.asiganacionManualRoute(food: widget.food, context: context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 110,
                                            decoration: BoxDecoration(
                                              color: global.buttonColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child:  Center(
                                              child: Text(
                                                "Escoger mesa",
                                                style:  TextStyle(
                                                    fontFamily: 'alteHaasGrotesk',
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).appBarTheme.backgroundColor
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
                          )
                      ),
                  ),
            ),
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