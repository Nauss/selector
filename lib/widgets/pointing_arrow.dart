import 'dart:math';

import 'package:flutter/material.dart';

class PointingArrow extends StatefulWidget {
  const PointingArrow({
    Key? key,
    required this.angle,
    required this.size,
  }) : super(key: key);
  final double angle;
  final double size;

  @override
  State<PointingArrow> createState() => _PointingArrowState();
}

class _PointingArrowState extends State<PointingArrow>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    // compute the offset direction
    final dx = cos(widget.angle) * 10;
    final dy = sin(widget.angle) * 10;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform.translate(
            offset: Offset(animation.value * dx, animation.value * dy),
            child: child,
          ),
        );
      },
      child: Transform.rotate(
        angle: widget.angle,
        child: Icon(
          Icons.play_arrow,
          size: widget.size,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
