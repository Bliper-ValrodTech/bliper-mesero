import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../models/models.dart';

class CirclePainterWidget extends CustomPainter {
  final List<CircleModel> circles;

  CirclePainterWidget({required this.circles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var circle in circles) {
      paint.color = circle.color;
      canvas.drawCircle(circle.position, circle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}