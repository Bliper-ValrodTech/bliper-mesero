import 'dart:ui';
import 'package:flutter/material.dart';

import '../global/global.dart' as global;

Color colorBackground = global.restaurante.colorFondo != "" ? Color.fromRGBO(
    int.parse(global.restaurante.colorFondo.split(',')[0]),
    int.parse(global.restaurante.colorFondo.split(',')[1]),
    int.parse(global.restaurante.colorFondo.split(',')[2]),
    1.0) : Color.fromRGBO(0, 31, 36, 1.0);

Color colorBtnGuardar = global.restaurante.btnGuardar != "" ? Color.fromRGBO(
    int.parse(global.restaurante.btnGuardar.split(',')[0]),
    int.parse(global.restaurante.btnGuardar.split(',')[1]),
    int.parse(global.restaurante.btnGuardar.split(',')[2]),
    1.0) : Color.fromRGBO(45, 204, 211, 1.0);

Color cardBackground = Color.lerp(Color.fromRGBO(0, 31, 36, 1.0), colorBtnGuardar, 0.1)!;

//Color cardBackground = Color.fromRGBO(0, 31, 36, 1.0);
