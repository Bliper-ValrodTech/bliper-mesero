import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:record/src/record.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/chat_controller.dart';
import 'flow_shader.dart';
import 'globals.dart';
import 'lottie_animation.dart';

class RecordButton extends StatefulWidget {
  final ValueChanged<int> enviarMQTT;
  final String mesa;
  final codigoChat;
  final ValueChanged<String> cargando;
  final String id_restaurante;
  final ValueChanged<List<String>> enviar_mensaje;
  const RecordButton({
    Key? key,
    required this.controller,
    required this.mensajeID,
    required this.ordenID,
    required this.mesa,
    required this.enviarMQTT,
    required this.codigoChat,
    required this.cargando,
    required this.id_restaurante,
    required this.enviar_mensaje,
  }) : super(key: key);

  final int mensajeID;
  final String ordenID;
  final AnimationController controller;

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends StateX<RecordButton> {
  late ChatController con;

  _RecordButtonState() : super(controller: ChatController()) {
    con = controller as ChatController;
  }
  static const double size = 55;

  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  late AudioRecorder record;

  bool isLocked = false;
  bool showLottie = false;

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth =
        MediaQuery.of(context).size.width - 1 * Globals.defaultPadding - 4;
    timerAnimation =
        Tween<double>(begin: timerWidth + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin: lockerHeight + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    //record.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockSlider(),
        cancelSlider(),
        audioButton(),
        if (isLocked) timerLocked(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FaIcon(FontAwesomeIcons.lock, size: 20),
            const SizedBox(height: 8),
            FlowShader(
              direction: Axis.vertical,
              child: Column(
                children: const [
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelSlider() {
    return Positioned(
      right: -timerAnimation.value,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              showLottie ? const LottieAnimation() : Text(recordDuration),
              const SizedBox(width: size),
              FlowShader(
                child: Row(
                  children: const [
                    Icon(Icons.keyboard_arrow_left),
                    Text("Slide to cancel")
                  ],
                ),
                duration: const Duration(seconds: 3),
                flowColors: const [Colors.white, Colors.grey],
              ),
              const SizedBox(width: size),
            ],
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Positioned(
      right: 0,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 25),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              //Vibrate.feedback(FeedbackType.success);
              timer?.cancel();
              timer = null;
              startTime = null;
              recordDuration = "00:00";

              String hora = "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}:${DateTime.now().microsecond}";

              int id = int.parse(await con.hora_id());
              widget.cargando(id.toString());
              List<String> respuesta = await con.stopSend(id: id,hora: hora,codigoChat:widget.codigoChat,ordenId: widget.ordenID,mensajeId: widget.mensajeID,mesa: widget.mesa,id_restaurante: widget.id_restaurante, codigo: widget.codigoChat);
              widget.enviar_mensaje(respuesta);
              setState(() {
                isLocked = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(recordDuration),
                FlowShader(
                  child: const Text("Tap lock to stop"),
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                ),
                const Center(
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    size: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String filepath = "";
  AudioRecorder r = AudioRecorder();
  String nombre = "";
  Widget audioButton() {
    return GestureDetector(
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: Container(
          child: const Icon(Icons.mic),
          height: size,
          width: size,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
      ),
      onLongPressDown: (_) {
        debugPrint("onLongPressDown");
        widget.controller.forward();
      },
      onLongPressEnd: (details) async {
        debugPrint("onLongPressEnd");

        if (isCancelled(details.localPosition, context)) {
          //Vibrate.feedback(FeedbackType.heavy);

          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          setState(() {
            showLottie = true;
          });

          Timer(const Duration(milliseconds: 1440), () async {
            widget.controller.reverse();
            debugPrint("Cancelled recording");
            var filePath = await record.stop();
            debugPrint(filePath);
            File(filePath!).delete();
            con.r.stop();

            debugPrint("Deleted $filePath");
            showLottie = false;
          });
        } else if (checkIsLocked(details.localPosition)) {
          widget.controller.reverse();

          //Vibrate.feedback(FeedbackType.heavy);
          debugPrint("Locked recording");
          debugPrint(details.localPosition.dy.toString());
          setState(() {
            isLocked = true;
          });
        } else {
          try{
            widget.controller.reverse();

            //Vibrate.feedback(FeedbackType.success);

            timer?.cancel();
            timer = null;
            startTime = null;
            recordDuration = "00:00";

            String hora = "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}:${DateTime.now().microsecond}";

            int id = int.parse(await con.hora_id());
            widget.cargando(id.toString());
            List<String> respuesta = await con.stopSend(id: id,hora: hora,codigoChat:widget.codigoChat,ordenId: widget.ordenID,mensajeId: widget.mensajeID,mesa: widget.mesa,id_restaurante: widget.id_restaurante, codigo: widget.codigoChat);
            widget.enviar_mensaje(respuesta);
          }catch(e){
            print("=====================================");
            print(e.toString());
            print("=====================================");
          }

        }
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        widget.controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        //Vibrate.feedback(FeedbackType.success);
        if (await AudioRecorder().hasPermission()) {
          record = AudioRecorder();
          /*await record.start(
            path: Globals.documentPath +
                "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
            encoder: AudioEncoder.AAC,
            bitRate: 128000,
            samplingRate: 44100,
          );*/
          var status = await Permission.microphone.request();
          if (status != PermissionStatus.granted) {
            Permission.microphone.request();
          }
          else{
            con.r = AudioRecorder();
            con.startRecording();
            /*nombre = DateTime.now().millisecondsSinceEpoch.toString();
            filepath = directory.path +
                '/'+nombre+'.acc';
            await r.start(
              path: filepath, // required
              encoder: AudioEncoder.AAC, // by default
              bitRate: 128000, // by default
              samplingRate: 44100, // by default
            );*/
          }
          startTime = DateTime.now();
          timer = Timer.periodic(const Duration(seconds: 1), (_) {
            final minDur = DateTime.now().difference(startTime!).inMinutes;
            final secDur = DateTime.now().difference(startTime!).inSeconds % 60;
            String min = minDur < 10 ? "0$minDur" : minDur.toString();
            String sec = secDur < 10 ? "0$secDur" : secDur.toString();
            setState(() {
              recordDuration = "$min:$sec";
            });
          });
        }
      },
    );
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
}
