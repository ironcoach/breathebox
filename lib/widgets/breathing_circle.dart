import 'package:flutter/material.dart';

class BreathingCircle extends StatelessWidget {
  final AnimationController controller;

  const BreathingCircle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Debug output — watch this in the console
        print("BreathingCircle scale = ${animation.value}");

        return Transform.scale(
          scale: animation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary.withOpacity(0.4),
                ],
              ),
            ),
            child: Center(
              child: Text(
                animation.value
                    .toStringAsFixed(2), // 👀 shows scale inside circle
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
