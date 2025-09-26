import 'package:bliper_mesero/src/controllers/home_controller.dart';
import 'package:bliper_mesero/src/elements/side_menu.dart';
import 'package:bliper_mesero/src/models/order.dart';
import 'package:bliper_mesero/src/models/sesiones_mesas.dart';
import 'package:bliper_mesero/src/pages/ordenes_mesas.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/controllers/global.dart' as global;
import 'package:state_extended/state_extended.dart';


class HomeWidget extends StatefulWidget {
  final List<Order> ordenes;
  final ValueChanged<int> onTapcCancelar;
  final List<int> Mesas;
  final ValueChanged<int> atender;
  final bool llamadoMesa;
  final List<SesionesMesas> sesionMesas;
  const HomeWidget({required this.ordenes, required this.onTapcCancelar, required this.Mesas, required this.atender, required this.llamadoMesa, required this.sesionMesas});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateX<HomeWidget> {
  late HomeController con;
  _HomeWidgetState() : super(controller: HomeController()) {
    con = controller as HomeController;
  }
  void showDrawer() {
    setState(() {
      _showDrawer = !_showDrawer;
    });
  }
  //CarouselController buttonCarouselController = CarouselController();
  bool _showDrawer = false;
  int count = 0;
  int width = 144;
  int height = 168;
  double subTotal = 0.0;
  double Total = 0.0;
  double Tax = 16.0;
  double tax = 0.0;
  late ValueNotifier<bool> refreshWidget = ValueNotifier<bool>(true);
  @override
  initState() {
    global.ordenes.addListener(() {
      con.obtener_sesiones();
    });
    con.obtener_sesiones();
    refresh_Widget();
    super.initState();
  }
  Future<void> refresh_Widget() async{
    // ignore: invalid_use_of_protected_member
    if(!refreshWidget.hasListeners){
      refreshWidget = global.refresh;
      refreshWidget.addListener(() {
        setState(() {
          print("refresh_Widget");
        });
      });
    }
  }

  bool grid = true;

@override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/app/fondo_dark.jpg'),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: NavDrawer(
          onTapcCancelar: (value) {
            if (value == 1) {
              widget.onTapcCancelar(value);
            }
          },
        ),
        appBar: AppBar(
          title: Text(
            "Ordenes".toUpperCase(),
            style: const TextStyle(
              fontFamily: 'alteHaasGrotesk',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: con.sesionesMesas.isEmpty ?
              const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ) :
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(con.sesionesMesas.length, (index){
                  return SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width*0.43,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width*0.43,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: global.buttonColor.withOpacity(0.7),
                            ),
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrdenesMesasWidget(sesion: con.sesionesMesas[index],entregadas: false,)));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Mesas",
                                      style:  TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      con.sesionesMesas[index].mesa.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: global.buttonColor,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/mesa.png",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            global.mostrar_notificaciones_ordenes_mesas(mesa: con.sesionesMesas[index].mesa.toString()).toString() != "0" ?
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  global.mostrar_notificaciones_ordenes_mesas(mesa: con.sesionesMesas[index].mesa.toString()).toString(),
                                  style: const TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ) : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  /*if (MediaQuery.of(context).orientation == Orientation.landscape) {
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
    return WillPopScope(
      onWillPop: () => back(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/app/fondo_dark.jpg'),
              fit: BoxFit.fitWidth),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: NavDrawer(
            onTapcCancelar: (value) {
              if (value == 1) {
                widget.onTapcCancelar(value);
              }
            },
          ),
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              "ordenes".toUpperCase(),
              style: const TextStyle(
                  fontFamily: 'alteHaasGrotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
              ),
            ),
          ),
          body: SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              primary: true,
              child: Stack(
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 64,
                                  width: MediaQuery.of(context).size.width*0.4,//168,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Color.fromRGBO(53, 78, 120, 1.0),
                                  ),
                                  child: Center(
                                    child: grid == true
                                        ? const Text(
                                            "Mesas",
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Text(
                                            "Ordenes",
                                            style: TextStyle(
                                              fontFamily: 'alteHaasGrotesk',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                              ),
                              Container(
                                height: 64,
                                width: MediaQuery.of(context).size.width*0.4,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Color.fromRGBO(53, 78, 120, 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          grid = false;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: const Color.fromRGBO(53, 78, 120, 1.0),
                                        child: Icon(
                                          Icons.menu,
                                          color: grid == true
                                              ? Colors.black
                                              : const Color.fromRGBO(45, 204, 211, 1.0),
                                          size: 45,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          grid = true;
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        color: const Color.fromRGBO(53, 78, 120, 1.0),
                                        child: Icon(
                                          CupertinoIcons.circle_grid_3x3_fill,
                                          color: grid == true
                                              ? const Color.fromRGBO(45, 204, 211, 1.0) : Colors.black,
                                          size: 45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          grid == true
                              ? GridView.count(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  crossAxisCount: count,
                                  childAspectRatio: (width / height),
                                  scrollDirection: Axis.vertical,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  shrinkWrap: true,
                                  primary: false,
                                  children: List.generate(widget.Mesas.length, (index) {
                                      return SizedBox(
                                        width: 144,
                                        height: 180,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: ElevatedButton(
                                            onPressed: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => OrdenesMesasWidget(mesa: widget.Mesas[index],ordenes:widget.ordenes)),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(0),
                                              backgroundColor: const Color.fromRGBO(53, 78, 120, 1.0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        const SizedBox(width: 10,),
                                                        widget.llamadoMesa == true ?
                                                        GestureDetector(
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: const BoxDecoration(
                                                              color: Colors.amber,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: const Center(
                                                              child: Icon(CupertinoIcons.bell,color: Colors.white,),
                                                            ),
                                                          ),
                                                          onTap: (){
                                                            mesaAtendida();
                                                          },
                                                        ) : const SizedBox(height: 30,),
                                                        const SizedBox(width: 10,),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    widget.Mesas[index].toString(),
                                                    style: const TextStyle(
                                                        fontFamily: 'alteHaasGrotesk',
                                                        fontSize: 20),
                                                  ),
                                                  const Text(
                                                    "Mesa",
                                                    style: TextStyle(
                                                        fontFamily: 'alteHaasGrotesk',
                                                        fontSize: 20),
                                                  ),
                                                  Image.asset(
                                                    "assets/images/mesa.png",
                                                    width: 97,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      /*GestureDetector(
                                        child: Container(
                                          width: 144,
                                          height: 178,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromRGBO(53, 78, 120, 1.0),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    const SizedBox(width: 10,),
                                                    widget.llamadoMesa == true ?
                                                    GestureDetector(
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.amber,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Center(
                                                          child: Icon(CupertinoIcons.bell,color: Colors.white,),
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        mesaAtendida();
                                                      },
                                                    ) : const SizedBox(height: 30,),
                                                    const SizedBox(width: 10,),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                widget.Mesas[index].toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'alteHaasGrotesk',
                                                    fontSize: 20),
                                              ),
                                              const Text(
                                                "Mesa",
                                                style: TextStyle(
                                                    fontFamily: 'alteHaasGrotesk',
                                                    fontSize: 20),
                                              ),
                                              Image.asset(
                                                "assets/images/mesa.png",
                                                width: 100,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => OrdenesMesasWidget(mesa: widget.Mesas[index],ordenes:widget.ordenes)),
                                          );
                                        },
                                      );*/
                                    },
                                  ),
                                )
                              : ListsaOrdenesWidget(ordenes: widget.ordenes,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );*/
  }
  Future<bool> back() async {
    return false;
  }
  Future<void> mesaAtendida() {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
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
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: const Icon(Icons.clear),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: MediaQuery.of(context).size.width*0.8,
                  color: global.bottomAppBarColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "¿Mesa atendida?",
                        style: TextStyle(
                          fontFamily: 'alteHaasGrotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,
                              ),
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              widget.atender(0);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue,
                              ),
                              child: const Text(
                                "Si",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
          );
        },
    );
  }
}