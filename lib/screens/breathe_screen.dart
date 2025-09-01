import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/breathe_controller.dart';
import '../controllers/settings_controller.dart';
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
  bool _listenersInitialized = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start small
    _animController.value = 0.0;
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

  void _ensureListeners() {
    if (_listenersInitialized) return;
    _listenersInitialized = true;

    // ✅ ONLY use the animCommandProvider listener - remove the phase listener
    ref.listen<(AnimationCommand, int?)>(animCommandProvider, (previous, next) {
      final (cmd, secs) = next;
      print("🎬 Animation command: $cmd with duration: ${secs}s");

      if (cmd == AnimationCommand.forward && secs != null) {
        _animController.duration = Duration(seconds: secs);
        _animController.forward(from: 0.0);
        print("▶️ Starting FORWARD animation");
      } else if (cmd == AnimationCommand.reverse && secs != null) {
        _animController.duration = Duration(seconds: secs);
        _animController.reverse(from: 1.0);
        print("◀️ Starting REVERSE animation");
      } else if (cmd == AnimationCommand.stop) {
        _animController.stop();
        print("⏹️ Stopping animation");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _ensureListeners();

    final settings = ref.watch(settingsProvider);
    final phase = ref.watch(breathePhaseProvider);
    final countdown = ref.watch(phaseCountdownProvider);
    final breathsTaken = ref.watch(breathCountProvider);
    final isPaused = ref.watch(isPausedProvider);

    final controller = ref.read(breathePhaseProvider.notifier);

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
                const SizedBox(height: 8),
                Text(
                  'Session duration: ${settings.sessionDurationSeconds}s • '
                  'Pattern: ${settings.inhaleSeconds}/'
                  '${settings.holdSeconds}/'
                  '${settings.exhaleSeconds}/'
                  '${settings.restSeconds}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                LayoutBuilder(builder: (context, constraints) {
                  final double avail = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : MediaQuery.of(context).size.width;
                  final double circleSize =
                      (avail * 0.8).clamp(120.0, 360.0).toDouble();

                  return SizedBox(
                    width: circleSize,
                    height: circleSize,
                    child: BreathingCircle(controller: _animController),
                  );
                }),
                const SizedBox(height: 20),
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
                      SizedBox(
                        width: 240,
                        child: ElevatedButton.icon(
                          icon: Icon(
                              isPaused ? Icons.play_arrow : Icons.play_circle),
                          label: Text(isPaused ? 'Resume' : 'Start'),
                          onPressed: () {
                            if (isPaused) {
                              controller.resume(ref);
                            } else {
                              controller.startSession(
                                  ref, settings.sessionDurationSeconds);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause'),
                          onPressed: () {
                            controller.pause(ref);
                            _animController.stop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop'),
                          onPressed: () {
                            controller.endSession(ref: ref);
                            _animController.reset();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tip: adjust breath lengths in Settings',
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
