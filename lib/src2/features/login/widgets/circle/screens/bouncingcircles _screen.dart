import 'dart:math';

import 'package:flutter/cupertino.dart';
import '../models/circle_model.dart';
import 'circle_screen.dart';

class BouncingCircles extends StatefulWidget {
  @override
  _BouncingCirclesState createState() => _BouncingCirclesState();
}

class _BouncingCirclesState extends State<BouncingCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final int numberOfCircles = 10;
  late List<CircleModel> circles;

  @override
  void initState() {
    super.initState();

    circles = List.generate(numberOfCircles, (index) {
      return CircleModel(
        position: Offset(_random.nextDouble() * 300, _random.nextDouble() * 600),
        velocity: Offset(_random.nextDouble() * 4 - 2, _random.nextDouble() * 4 - 2),
        radius: 20 + _random.nextDouble() * 20,
        color: Color.fromARGB(
          255,
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextInt(256),
        ),
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10000),
    )..addListener(() {
      updateCircles();
    });
    _controller.repeat();
  }

  void updateCircles() {
    final size = MediaQuery.of(context).size;

    for (var circle in circles) {
      var pos = circle.position + circle.velocity;

      // Rebotar horizontal
      if (pos.dx - circle.radius <= 0 || pos.dx + circle.radius >= size.width) {
        circle.velocity = Offset(-circle.velocity.dx, circle.velocity.dy);
      }
      // Rebotar vertical
      if (pos.dy - circle.radius <= 0 || pos.dy + circle.radius >= size.height) {
        circle.velocity = Offset(circle.velocity.dx, -circle.velocity.dy);
      }

      circle.position += circle.velocity;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: CirclePainterWidget(circles: circles),
    );
  }
}