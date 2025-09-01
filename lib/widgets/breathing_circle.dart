import 'package:flutter/material.dart';

class BreathingCircle extends StatelessWidget {
  final AnimationController controller;
  const BreathingCircle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.7, end: 1.2).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal,
        ),
      ),
    );
  }
}
