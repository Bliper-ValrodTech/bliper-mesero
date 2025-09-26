import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mic extends StatefulWidget {
  final ValueChanged<int> status;
  Mic({required this.status});
  _MicState createState() => _MicState();
}

class _MicState extends State<Mic> {
  bool mic = false;
  double opacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "¡Crear Ordenes por voz!",
          style: TextStyle(
            fontFamily: 'alteHaasGrotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Expanded(child: SizedBox()),
        mic == true
        ? const SizedBox(
          height: 50,
          child: Text(
            "¡Grabando!",
            style: TextStyle(
              fontFamily: 'alteHaasGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        : const SizedBox(height: 50),
        Stack(
          children: [
            Center(
              child: GestureDetector(
                child: Container(
                  width: 130,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(45,204,211,1.0),
                  ),
                  child: const Icon(Icons.mic,size: 70),
                ),
                onLongPress: (){
                  setState(() {
                    mic = true;
                    opacity = 1.0;
                  });
                  widget.status(0);
                  //_con!.startRecording();
                },
                onLongPressUp: () async{
                  widget.status(1);
                  /*String retorno = await _con!.stopRecording();
                    enviarMQTT(retorno);*/
                  setState(() {
                    mic = false;
                    opacity = 0.0;
                  });
                },
              ),
            ),
            mic == true
            ? const Center(
              child:SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 10.5,
                ),
              ),
            )
            : const SizedBox(width: 0),
          ],
        ),
        Expanded(child: const SizedBox()),
      ],
    );
  }
}
