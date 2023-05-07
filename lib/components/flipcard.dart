import 'dart:math';

import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Image front;
  final Image back;
  const FlipCard({super.key, required this.front, required this.back});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  double dragPosition = 0;
  bool isFront = true;
  @override
  Widget build(BuildContext context) {
    final angle = dragPosition / 180 * -pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(angle);
    return GestureDetector(
      onVerticalDragUpdate: (details) => setState(() {
        dragPosition -= details.delta.dy;
        dragPosition %= 360;
        setImageSide();
      }),
      child: Transform(
        transform: transform,
        alignment: Alignment.center,
        child: isFront
            ? widget.front
            : Transform(
                transform: Matrix4.identity()..rotateX(pi),
                alignment: Alignment.center,
                child: widget.back,
              ),
      ),
    );
  }

  void setImageSide() {
    if (dragPosition <= 90 || dragPosition >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
  }
}
