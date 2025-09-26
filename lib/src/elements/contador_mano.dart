import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

// ignore: must_be_immutable
class ContadorMano extends StatefulWidget{
  final ValueChanged<int> contador;
  late  int cantidad;
  ContadorMano({required this.contador, required this.cantidad});
  @override
  _ContadorMano createState() => _ContadorMano();
}
class _ContadorMano extends StateX<ContadorMano> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width*0.8-200,
      child: Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white,width: 1),
        ),
        child:Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  if(widget.cantidad > 1){
                    setState(() {
                      widget.cantidad--;
                    });
                    widget.contador(widget.cantidad);
                  }
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: const Center(
                    child: Text(
                      "-",
                      style: TextStyle(
                          fontFamily: 'alteHaasGrotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.cantidad.toString(),
                style: const TextStyle(
                    fontFamily: 'alteHaasGrotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap:(){
                  setState(() {
                    widget.cantidad++;
                  });
                  widget.contador(widget.cantidad);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle
                  ),
                  child: const Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                          fontFamily: 'alteHaasGrotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}