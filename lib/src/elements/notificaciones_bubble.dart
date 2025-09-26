import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bliper_mesero/src/controllers/notificaciones_controller.dart' as noti;


class NotificacionesBubble extends StatefulWidget {
  final ValueChanged<int> open;
  final int size;
  NotificacionesBubble({required this.open,required this.size});
  @override
  _NotificacionesBubbleState createState() => _NotificacionesBubbleState();
}

class _NotificacionesBubbleState extends State<NotificacionesBubble> {
  final GlobalKey _floatingKey = GlobalKey();
  bool notificacionHeadOpened = false;

  // getting size of chat head
  late Size floatingSize;

  // Initial Location of Chat Head
  Offset floatingLocation = const Offset(0, 40);

  void getFloatingSize() async {
    RenderBox _floatingBox = _floatingKey.currentContext!.findRenderObject() as RenderBox;
    floatingSize = _floatingBox.size;
  }

  void onDragUpdate(BuildContext context, DragUpdateDetails dragUpdateDetails) {
    setState(() {
      notificacionHeadOpened = false;
    });

    // Gesture location on screen
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.globalToLocal(dragUpdateDetails.localPosition);

    // Screen Area
    const double startX = 0;
    final double endX = context.size!.width - floatingSize.width;
    final double startY = MediaQuery.of(context).padding.top;
    final double endY = context.size!.height - floatingSize.height;

    // Make sure the widget floats within screen area and keep updating its position, if changed
    if (startX < offset.dx && offset.dx < endX) {
      if (startY < offset.dy && offset.dy < endY) {
        setState(() {
          floatingLocation = Offset(offset.dx, offset.dy);
        });
      }
    }
  }

  void onDragEnd(BuildContext context, DragEndDetails dragEndDetails) {
    // Make sure to set the widget on left or right of the screen
    final double pointX = context.size!.width / 2;

    if ((floatingLocation.dx + floatingSize.width / 2) < pointX) {
      setState(() {
        floatingLocation = Offset(0, floatingLocation.dy);
      });
    } else {
      setState(() {
        if (!notificacionHeadOpened) {
          floatingLocation = Offset(
              context.size!.width - floatingSize.width, floatingLocation.dy);
        } else {
          floatingLocation =
              Offset(context.size!.width * 0.35, floatingLocation.dy);
        }
      });
    }
  }

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getFloatingSize());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) =>
          onDragUpdate(context, details),
      onHorizontalDragUpdate: (DragUpdateDetails details) =>
          onDragUpdate(context, details),
      onVerticalDragEnd: (DragEndDetails details) =>
          onDragEnd(context, details),
      onHorizontalDragEnd: (DragEndDetails details) =>
          onDragEnd(context, details),
      child: Stack(
        children: [
          //CustomCenterWiget(),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: floatingLocation.dx,
            top: floatingLocation.dy,
            onEnd: (){
              print(MediaQuery.of(context).size.height-200);
              print(floatingLocation.dy);
              if(floatingLocation.dy >= (MediaQuery.of(context).size.height-200))
              {
              }
            },
            child: GestureDetector(
              onTap: (){

              },
              child: chatHead(),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatHead() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            notificacionHeadOpened
                ? const SizedBox(
              width: 10,
            )
                : const SizedBox(),
            GestureDetector(
              key: _floatingKey,
              onTap: (){
                widget.open(1);
              },
              child: SizedBox(
                height: 70,
                width: 70,
                child: Stack(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360.0),
                          color: Colors.blueAccent,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                            )
                          ]
                      ),
                      child: const Center(
                        child: Icon(CupertinoIcons.bell_fill,color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 11,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            noti.size.toString(),
                            style: const TextStyle(
                              fontFamily: 'alteHaasGrotesk',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        /*notificacionHeadOpened ? ChatNuevo()/*ChatHeadBody(idOrden: widget.orden, Cerrar: (int value) {
            if(value == 0){
              setState(() {
                notificacionHeadOpened = false;
              });
            }
            if(value == 1)
              {
                widget.eliminar(1);
                setState(() {
                  notificacionHeadOpened = false;
                });
              }
          },)*/ : */const SizedBox()
      ],
    );
  }
}

class CustomCenterWiget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/messenger.png',
            height: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(children: [
              TextSpan(
                text: "Messenger",
                style: TextStyle(
                    color: Color(0xff0078FF),
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: "\nChat Head UI",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
