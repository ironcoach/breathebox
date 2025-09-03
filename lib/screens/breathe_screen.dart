import 'package:breathebox/widgets/other_circles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/breathe_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/session_controller.dart';
import '../models/session.dart';
import '../widgets/breathing_circle.dart';

class BreatheScreen extends ConsumerStatefulWidget {
  const BreatheScreen({super.key});

  @override
  ConsumerState<BreatheScreen> createState() => _BreatheScreenState();
}

class _BreatheScreenState extends ConsumerState<BreatheScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Default duration
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    print("🎬 AnimationController initialized: ${_animController.value}");
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int _secondsForPhase(BreathPhase phase) {
    final s = ref.read(settingsProvider);
    switch (phase) {
      case BreathPhase.inhale:
        return s.inhaleSeconds;
      case BreathPhase.hold:
        return s.holdSeconds;
      case BreathPhase.exhale:
        return s.exhaleSeconds;
      case BreathPhase.rest:
        return s.restSeconds;
    }
  }

  String _phaseLabel(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return 'Inhale';
      case BreathPhase.hold:
        return 'Hold';
      case BreathPhase.exhale:
        return 'Exhale';
      case BreathPhase.rest:
        return 'Rest';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final phase = ref.watch(breathePhaseProvider);
    final countdown = ref.watch(phaseCountdownProvider);
    final breathsTaken = ref.watch(breathCountProvider);
    final isPaused = ref.watch(isPausedProvider);
    final isActive = ref.read(breathePhaseProvider.notifier).isSessionActive;

    final controller = ref.read(breathePhaseProvider.notifier);

    // ✅ CRITICAL FIX: Animation listener inside build method
    ref.listen<(AnimationCommand, int?)>(animCommandProvider, (previous, next) {
      final (cmd, secs) = next;
      print("🎬 Animation command received: $cmd with duration: ${secs}s");
      print("🎬 Current animation value: ${_animController.value}");

      if (cmd == AnimationCommand.forward && secs != null) {
        _animController.duration = Duration(seconds: secs);
        _animController.forward(from: 0.0).then((_) {
          print("✅ Forward animation completed");
        });
        print("▶️ Starting FORWARD animation from 0.0");
      } else if (cmd == AnimationCommand.reverse && secs != null) {
        _animController.duration = Duration(seconds: secs);
        _animController.reverse(from: 1.0).then((_) {
          print("✅ Reverse animation completed");
        });
        print("◀️ Starting REVERSE animation from 1.0");
      } else if (cmd == AnimationCommand.stop) {
        _animController.stop();
        print("⏹️ Animation stopped at: ${_animController.value}");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathe Session'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Guided Breathing',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 48),
                LayoutBuilder(builder: (context, constraints) {
                  final double avail = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : MediaQuery.of(context).size.width;
                  final double circleSize =
                      (avail * 0.8).clamp(120.0, 360.0).toDouble();

                  return SizedBox(
                    width: circleSize,
                    height: circleSize,
                    // child: RippleBreathingCircle(
                    //   controller: _animController,
                    //   currentPhase: phase,
                    // ),
                    // child: PhaseRingBreathingCircle(
                    //   controller: _animController,
                    //   currentPhase: phase,
                    //   phaseCountdown: countdown,
                    //   phaseDuration: _secondsForPhase(phase),
                    // )
                    // child: GlowBreathingCircle(
                    //   controller: _animController,
                    //   currentPhase: phase,
                    // ),
                    // child: ParticleBreathingCircle(
                    //   controller: _animController,
                    //   currentPhase: phase,
                    // ),
                    child: SubtleColorGlowCircle(
                      controller: _animController,
                      currentPhase: phase,
                    ),
                    // child: ColorTransitionCircle(
                    //   controller: _animController,
                    //   currentPhase: phase,
                    // ),
                    //child: BreathingCircle(controller: _animController),
                  );
                }),
                const SizedBox(height: 32),
                Column(
                  children: [
                    Text(
                      _phaseLabel(phase),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      countdown > 0 ? '$countdown s' : '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Breaths: $breathsTaken',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    runSpacing: 8,
                    spacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      if (!isActive) ...[
                        SizedBox(
                          width: 240,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start Session'),
                            onPressed: () {
                              //print("🎯 Start button pressed");
                              controller.startSession(
                                  ref, settings.sessionDurationSeconds);
                            },
                          ),
                        ),
                      ],
                      if (isActive) ...[
                        SizedBox(
                          width: 120,
                          child: ElevatedButton.icon(
                            icon:
                                Icon(isPaused ? Icons.play_arrow : Icons.pause),
                            label: Text(isPaused ? 'Resume' : 'Pause'),
                            onPressed: () {
                              //print(
                              //    "🎯 ${isPaused ? 'Resume' : 'Pause'} button pressed");
                              if (isPaused) {
                                controller.resume(ref);
                              } else {
                                controller.pause(ref);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 120,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.stop),
                            label: const Text('End'),
                            onPressed: () {
                              //print("⏹️ Stop button pressed");
                              final count = ref.read(breathCountProvider);
                              final duration =
                                  ref.read(sessionDurationProvider);

                              // Save session to history
                              if (count > 0 && duration > 0) {
                                ref.read(sessionHistoryProvider.notifier).add(
                                      Session(
                                        date: DateTime.now(),
                                        breathsTaken: count,
                                        durationInSeconds: duration,
                                      ),
                                    );
                              }

                              controller.endSession(ref: ref);
                              _animController.reset();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isActive
                      ? 'Session active - follow the breathing pattern'
                      : 'Tip: Use Test buttons to verify animation works',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
