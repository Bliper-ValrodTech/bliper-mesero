import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/models/user_login.dart' as user;
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../controllers/asignacion_mesa_controller.dart';
import '../models/food.dart';
import 'menu.dart';

class AsiganacionManualWidget extends StatefulWidget {
  final List<Food> food;
  const AsiganacionManualWidget({super.key, required this.food});
  @override
  _AsiganacionManualWidgetState createState() => _AsiganacionManualWidgetState();
}

class _AsiganacionManualWidgetState extends StateX<AsiganacionManualWidget> {
  late AsignacionMesaController con;
  _AsiganacionManualWidgetState() : super(controller: AsignacionMesaController()) {
    con = controller as AsignacionMesaController;
  }
  int count = 0;
  int width = 144;
  int height = 168;//168
  @override
  void initState() {
    super.initState();
    con.obtenerMesas();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      double width = MediaQuery.of(context).size.width;
      int widthCard = this.width;
      int countRow = width ~/ widthCard;
      count = countRow;
    }
    else {
      double width = MediaQuery.of(context).size.width;
      int widthCard = this.width;
      int countRow = width ~/ widthCard;
      count = countRow;
    }
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/app/fondo_dark.jpg'),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          child:con.mesas.isEmpty
          ?Center(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/images/mesa.png",color: global.buttonColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ],
            ),
          )
          :  SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 20,
                children: List.generate(con.mesas.length, (index) {
                  return GestureDetector(
                    child: Container(
                      width: 144,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(20),
                        color: const Color.fromRGBO(53, 78, 120, 0.5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: 144,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(20),
                          color: global.buttonColor.withValues(alpha: 0.5),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Mesa ${con.mesas[index].mesa_number}",
                                style: const TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(45,204,211,1.0)
                                ),
                                child: Image.asset("assets/images/mesa.png",),
                              ),
                              const Text(
                                "Seleccionar",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                    onTap: () {
                      global.paginas.menuRoute(mesa: con.mesas[index].mesa_number.toString(), deviceToken: global.token, context: context);
                    },
                  );
                },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}