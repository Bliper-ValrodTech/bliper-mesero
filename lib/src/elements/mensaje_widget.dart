import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MensajeWidget extends StatefulWidget {
  final bool Enviado;
  final String? Mensaje;
  final String? Fecha;
  final bool primero;
  final bool ultimo;
  MensajeWidget({required this.Enviado, this.Mensaje, this.Fecha, required this.primero, required this.ultimo});
  @override
  _MensajeWidgetState createState() => _MensajeWidgetState();
}

class _MensajeWidgetState extends State<MensajeWidget> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Row(
        mainAxisAlignment: widget.Enviado == true ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: widget.primero ? const EdgeInsets.only(top: 10) : widget.ultimo ? const EdgeInsets.only(bottom: 10) : const EdgeInsets.only(bottom: 0),
            width: MediaQuery.of(context).size.width*0.8,
            child:  Row(
              mainAxisAlignment: widget.Enviado == true ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Padding(
                    padding:  widget.Enviado == true ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: widget.Enviado == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.Enviado == true ? Colors.blueAccent : Colors.blueGrey,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            crossAxisAlignment: widget.Enviado == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.Mensaje.toString(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                widget.Fecha.toString(),
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    ],
    );
  }
}