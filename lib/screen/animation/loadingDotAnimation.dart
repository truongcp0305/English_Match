import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class LoadingDotsAnimation extends StatefulWidget {
  @override
  _LoadingDotsAnimationState createState() => _LoadingDotsAnimationState();
}

class _LoadingDotsAnimationState extends State<LoadingDotsAnimation> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159265359,
    ).animate(controller);

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          children: <Widget>[
            Dot(animation.value),
            Dot(animation.value - 1),
            Dot(animation.value - 2),
          ],
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  final double animationValue;

  Dot(this.animationValue);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(30 * cos(animationValue), 0.0),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
        ),
      ),
    );
  }
}