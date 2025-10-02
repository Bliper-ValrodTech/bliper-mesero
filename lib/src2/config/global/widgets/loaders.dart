import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import '../../theme/theme.dart';

Widget Loading(){
  return Container(
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: colorBackground,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: colorBtnGuardar,
          blurRadius: 10,
          spreadRadius: 2,
        )
      ]
    ),
    child: SizedBox(
      width: 200,
      height: 200,
      child: Lottie.asset('assets/lottie/cargando.json'),
    ),
  );
}