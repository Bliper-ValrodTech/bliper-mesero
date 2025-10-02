import 'dart:ui';

class CircleModel {
  Offset position;
  Offset velocity;
  double radius;
  Color color;

  CircleModel({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });
}