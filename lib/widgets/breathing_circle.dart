import 'package:flutter/material.dart';

class BreathingCircle extends StatelessWidget {
  final AnimationController controller;

  const BreathingCircle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    //print("🔄 BreathingCircle rebuilding...");

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Scale from 0.7 to 1.2 based on controller value (0.0 to 1.0)
        final scale = 0.7 +
            (controller.value * 0.5); // 0.7 + (0.0-1.0 * 0.5) = 0.7 to 1.2

        // print(
        //     "🎯 Animation value: ${controller.value.toStringAsFixed(3)}, Scale: ${scale.toStringAsFixed(3)}");

        return Transform.scale(
          scale: scale,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary.withOpacity(0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20 * scale, // Shadow grows with circle
                  spreadRadius: 5 * scale,
                ),
              ],
            ),
            // child: Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         scale.toStringAsFixed(2),
            //         style: const TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //       ),
            //       Text(
            //         'Value: ${controller.value.toStringAsFixed(2)}',
            //         style: const TextStyle(
            //           fontSize: 12,
            //           color: Colors.white70,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
