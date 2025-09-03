// ========================================
// SUBTLE PHASE TRANSITION IDEAS
// ========================================

import 'dart:math';

import 'package:flutter/material.dart';
import '../controllers/breathe_controller.dart';

// ========================================
// COMBINED: Color Transition + Glow Intensity Circle
// ========================================

class ColorGlowBreathingCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const ColorGlowBreathingCircle(
      {super.key, required this.controller, required this.currentPhase});

  Color _getPhaseColor(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return Colors.teal; // Calming green-blue
      case BreathPhase.hold:
        return Colors.amber; // Warm golden
      case BreathPhase.exhale:
        return Colors.lightBlue; // Soft blue
      case BreathPhase.rest:
        return Colors.deepPurple; // Deep, restful purple
    }
  }

  double _getGlowIntensity() {
    switch (currentPhase) {
      case BreathPhase.inhale:
        return controller.value; // Glow increases as you inhale (0.0 → 1.0)
      case BreathPhase.exhale:
        return 1.0 -
            controller.value; // Glow decreases as you exhale (1.0 → 0.0)
      case BreathPhase.hold:
        return 0.8; // Strong steady glow during hold
      case BreathPhase.rest:
        return 0.3; // Gentle glow during rest
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 0.7 + (controller.value * 0.5);
        final phaseColor = _getPhaseColor(currentPhase);
        final glowIntensity = _getGlowIntensity();

        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: 800), // Smooth color transition
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  // Inner color gets brighter with glow
                  phaseColor.withOpacity(0.7 + (glowIntensity * 0.3)),
                  // Outer color stays more transparent
                  phaseColor.withOpacity(0.2 + (glowIntensity * 0.2)),
                ],
              ),
              boxShadow: [
                // Main glow shadow - intensity changes with breathing
                BoxShadow(
                  color: phaseColor.withOpacity(0.2 + (glowIntensity * 0.5)),
                  blurRadius: 15 + (glowIntensity * 25), // 15px to 40px blur
                  spreadRadius: 3 + (glowIntensity * 12), // 3px to 15px spread
                ),
                // Inner bright glow for depth
                BoxShadow(
                  color: Colors.white.withOpacity(glowIntensity * 0.4),
                  blurRadius: 5 + (glowIntensity * 10),
                  spreadRadius: -2,
                ),
                // Outer atmospheric glow
                BoxShadow(
                  color: phaseColor.withOpacity(glowIntensity * 0.3),
                  blurRadius: 40 + (glowIntensity * 20),
                  spreadRadius: 10 + (glowIntensity * 5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ========================================
// ALTERNATIVE: More Dramatic Glow Effect
// ========================================

class IntenseColorGlowCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const IntenseColorGlowCircle(
      {super.key, required this.controller, required this.currentPhase});

  Color _getPhaseColor(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return Colors.teal;
      case BreathPhase.hold:
        return Colors.amber;
      case BreathPhase.exhale:
        return Colors.lightBlue;
      case BreathPhase.rest:
        return Colors.deepPurple;
    }
  }

  double _getGlowIntensity() {
    switch (currentPhase) {
      case BreathPhase.inhale:
        // Smooth ease-in glow during inhale
        return Curves.easeIn.transform(controller.value);
      case BreathPhase.exhale:
        // Smooth ease-out glow during exhale
        return Curves.easeOut.transform(1.0 - controller.value);
      case BreathPhase.hold:
        return 0.9; // Very bright during hold
      case BreathPhase.rest:
        return 0.2; // Very dim during rest
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 0.7 + (controller.value * 0.5);
        final phaseColor = _getPhaseColor(currentPhase);
        final glowIntensity = _getGlowIntensity();

        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                stops: const [0.0, 0.7, 1.0],
                colors: [
                  // Bright center that pulses with breathing
                  Colors.white.withOpacity(glowIntensity * 0.8),
                  // Phase color in the middle
                  phaseColor.withOpacity(0.8),
                  // Fade to transparent at edges
                  phaseColor.withOpacity(0.1),
                ],
              ),
              boxShadow: [
                // Inner bright core
                BoxShadow(
                  color: Colors.white.withOpacity(glowIntensity * 0.6),
                  blurRadius: 8 + (glowIntensity * 12),
                  spreadRadius: -5,
                ),
                // Main colored glow
                BoxShadow(
                  color: phaseColor.withOpacity(0.3 + (glowIntensity * 0.4)),
                  blurRadius: 20 + (glowIntensity * 30),
                  spreadRadius: 5 + (glowIntensity * 10),
                ),
                // Far outer atmospheric glow
                BoxShadow(
                  color: phaseColor.withOpacity(glowIntensity * 0.2),
                  blurRadius: 50 + (glowIntensity * 25),
                  spreadRadius: 15 + (glowIntensity * 5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ========================================
// SUBTLE VERSION: For users who want less intensity
// ========================================

class SubtleColorGlowCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const SubtleColorGlowCircle(
      {super.key, required this.controller, required this.currentPhase});

  Color _getPhaseColor(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return Colors.teal;
      case BreathPhase.hold:
        return Colors.amber;
      case BreathPhase.exhale:
        return Colors.lightBlue;
      case BreathPhase.rest:
        return Colors.deepPurple;
    }
  }

  double _getGlowIntensity(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return 0.3 + (controller.value * 0.4); // 0.3 → 0.7
      case BreathPhase.exhale:
        return 0.7 - (controller.value * 0.4); // 0.7 → 0.3
      case BreathPhase.hold:
        return 0.6; // Moderate glow
      case BreathPhase.rest:
        return 0.2; // Gentle glow
    }
  }

  double _getScale(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return 0.7 + (controller.value * 0.5);
      case BreathPhase.exhale:
        return 0.7 - (controller.value * 0.5);
      case BreathPhase.hold:
        return 0.6;
      case BreathPhase.rest:
        return 0.7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = _getScale(currentPhase);
        final phaseColor = _getPhaseColor(currentPhase);
        final glowIntensity = _getGlowIntensity(currentPhase);

        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(
                milliseconds: 1000), // Slower, more gentle transition
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  phaseColor.withOpacity(0.8),
                  phaseColor.withOpacity(0.3),
                ],
              ),
              boxShadow: [
                // Single, gentle glow
                BoxShadow(
                  color: phaseColor.withOpacity(glowIntensity * 0.6),
                  blurRadius: 20 + (glowIntensity * 15),
                  spreadRadius: 5 + (glowIntensity * 8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StableColorTransitionCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const StableColorTransitionCircle(
      {super.key, required this.controller, required this.currentPhase});

  Color _getPhaseColor(BuildContext context, BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return Colors.teal;
      case BreathPhase.hold:
        return Colors.amber;
      case BreathPhase.exhale:
        return Colors.lightBlue;
      case BreathPhase.rest:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final scale = 0.7 + (controller.value * 0.5);
            final circleSize = size * scale;
            final baseColor = _getPhaseColor(context, currentPhase);

            return Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      baseColor.withOpacity(0.9),
                      baseColor.withOpacity(0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ColorTransitionCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const ColorTransitionCircle(
      {super.key, required this.controller, required this.currentPhase});

  Color _getPhaseColor(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return Colors.teal; // Calming green-blue
      case BreathPhase.hold:
        return Colors.amber; // Warm golden
      case BreathPhase.exhale:
        return Colors.lightBlue; // Soft blue
      case BreathPhase.rest:
        return Colors.deepPurple; // Deep, restful purple
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 0.7 + (controller.value * 0.5);
        final baseColor = _getPhaseColor(currentPhase);

        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: 800), // Smooth color transition
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  baseColor.withOpacity(0.9),
                  baseColor.withOpacity(0.3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: baseColor.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// 1. COLOR TRANSITIONS - Smooth color changes between phases
class ColorTransitionCircleOrg extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const ColorTransitionCircleOrg(
      {super.key, required this.controller, required this.currentPhase});

  Color _getPhaseColor(BuildContext context, BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return const Color.fromARGB(255, 77, 237, 106); // Calming green-blue
      case BreathPhase.hold:
        return const Color.fromARGB(255, 243, 229, 105); // Warm golden
      case BreathPhase.exhale:
        return const Color.fromARGB(255, 69, 134, 233); // Soft blue
      case BreathPhase.rest:
        return const Color.fromARGB(255, 236, 184, 112); // Deep, restful purple
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 0.7 + (controller.value * 0.5);
        final baseColor = _getPhaseColor(context, currentPhase);

        return AnimatedContainer(
          duration:
              const Duration(milliseconds: 800), // Smooth color transition
          curve: Curves.easeInOut,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                baseColor.withOpacity(0.9),
                baseColor.withOpacity(0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: baseColor.withOpacity(0.4),
                blurRadius: 20 * scale,
                spreadRadius: 5 * scale,
              ),
            ],
          ),
          transform: Matrix4.identity()..scale(scale),
        );
      },
    );
  }
}

// ========================================
// 2. PARTICLE EFFECTS - Gentle floating particles
// ========================================

class ParticleBreathingCircle extends StatefulWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const ParticleBreathingCircle({
    super.key,
    required this.controller,
    required this.currentPhase,
  });

  @override
  State<ParticleBreathingCircle> createState() =>
      _ParticleBreathingCircleState();
}

class _ParticleBreathingCircleState extends State<ParticleBreathingCircle>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Create floating particles
    for (int i = 0; i < 8; i++) {
      _particles.add(Particle(
        angle: (i * 45.0) * (3.14159 / 180), // Convert to radians
        distance: 40.0 + (i * 10),
        speed: 0.5 + (i * 0.1),
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _particleController]),
      builder: (context, child) {
        final scale = 0.7 + (widget.controller.value * 0.5);

        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main breathing circle
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              // Floating particles
              ..._particles.map((particle) => _buildParticle(particle)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParticle(Particle particle) {
    final animationValue = _particleController.value;
    final x = particle.distance *
        cos(particle.angle + animationValue * particle.speed);
    final y = particle.distance *
        sin(particle.angle + animationValue * particle.speed);

    return Positioned(
      left: 50 + x,
      top: 50 + y,
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}

class Particle {
  final double angle;
  final double distance;
  final double speed;

  Particle({required this.angle, required this.distance, required this.speed});
}

// ========================================
// 3. RIPPLE EFFECT - Gentle ripples during phase changes
// ========================================

class RippleBreathingCircle extends StatefulWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const RippleBreathingCircle(
      {super.key, required this.controller, required this.currentPhase});

  @override
  State<RippleBreathingCircle> createState() => _RippleBreathingCircleState();
}

class _RippleBreathingCircleState extends State<RippleBreathingCircle>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  BreathPhase? _previousPhase;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger ripple on phase change
    if (_previousPhase != widget.currentPhase) {
      _previousPhase = widget.currentPhase;
      _rippleController.forward(from: 0.0);
    }

    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _rippleController]),
      builder: (context, child) {
        final scale = 0.7 + (widget.controller.value * 0.5);

        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main circle
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              // Ripple effect
              if (_rippleController.isAnimating)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5 * (1 - _rippleController.value)),
                      width: 3,
                    ),
                  ),
                  transform: Matrix4.identity()
                    ..scale(1.0 + (_rippleController.value * 0.3)),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ========================================
// 4. GLOW INTENSITY - Breathing glow that intensifies
// ========================================

class GlowBreathingCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;

  const GlowBreathingCircle(
      {super.key, required this.controller, required this.currentPhase});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 0.7 + (controller.value * 0.5);
        final glowIntensity = currentPhase == BreathPhase.inhale
            ? controller.value
            : currentPhase == BreathPhase.exhale
                ? (1.0 - controller.value)
                : 0.5;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  Theme.of(context).colorScheme.primary.withOpacity(0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.3 + (glowIntensity * 0.4)),
                  blurRadius: 15 + (glowIntensity * 25),
                  spreadRadius: 3 + (glowIntensity * 8),
                ),
                // Inner glow
                BoxShadow(
                  color: Colors.white.withOpacity(glowIntensity * 0.3),
                  blurRadius: 5,
                  spreadRadius: -5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ========================================
// 5. PHASE INDICATOR RING - Subtle progress ring
// ========================================

class PhaseRingBreathingCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase currentPhase;
  final int phaseCountdown;
  final int phaseDuration;

  const PhaseRingBreathingCircle({
    super.key,
    required this.controller,
    required this.currentPhase,
    required this.phaseCountdown,
    required this.phaseDuration,
  });

  @override
  Widget build(BuildContext context) {
    final progress = phaseDuration > 0
        ? (phaseDuration - phaseCountdown) / phaseDuration
        : 0.0;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 0.7 + (controller.value * 0.5);

        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main circle
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              // Progress ring
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
