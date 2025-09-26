import 'package:bliper_mesero/src/models/category.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart';
class CategoriaWidget extends StatefulWidget{
  final Category categoria;
  final ValueChanged<bool> seleccionado;
  CategoriaWidget({required this.categoria, required this.seleccionado});

  _CategoriaWidgetState createState() => _CategoriaWidgetState();
}
class _CategoriaWidgetState extends StateX<CategoriaWidget>{
  _CategoriaWidgetState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.seleccionado(true);
      },
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.categoria.seleccionado ? buttonColor : Theme.of(context).appBarTheme.backgroundColor,
          border: Border.all(
            color: buttonColor,
            width: 1,
          )
        ),
        child: Center(
          child: Text(
            widget.categoria.name,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: widget.categoria.seleccionado ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}