import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/breathe_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/session_controller.dart';
import '../models/session.dart';

class BreatheScreen extends ConsumerStatefulWidget {
  const BreatheScreen({super.key});

  @override
  ConsumerState<BreatheScreen> createState() => _BreatheScreenState();
}

class _BreatheScreenState extends ConsumerState<BreatheScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      lowerBound: 0.7,
      upperBound: 1.2,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final phase = ref.watch(breathePhaseProvider);
    final breathCount = ref.watch(breathCountProvider);
    final countdown = ref.watch(phaseCountdownProvider);
    final elapsedSeconds = ref.watch(sessionDurationProvider);
    final isPaused = ref.watch(isPausedProvider);
    final isActive = ref.watch(breathePhaseProvider.notifier).isSessionActive;

    ref.listen<(AnimationCommand, int?)>(animCommandProvider, (previous, next) {
      final (cmd, secs) = next;
      if (cmd == AnimationCommand.forward && secs != null) {
        _animController.duration = Duration(seconds: secs);
        _animController.forward(from: 0.0);
      } else if (cmd == AnimationCommand.reverse && secs != null) {
        _animController.duration = Duration(seconds: secs);
        _animController.reverse(from: 1.0);
      } else if (cmd == AnimationCommand.stop) {
        _animController.stop();
      }
    });

    final circleColor = switch (phase) {
      BreathPhase.inhale => Colors.teal,
      BreathPhase.hold => Colors.amber,
      BreathPhase.exhale => Colors.lightBlue,
      BreathPhase.rest => Colors.deepPurple,
    };

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Breathing Session'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animController,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                    boxShadow: [
                      BoxShadow(
                        color: circleColor.withOpacity(0.35),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: ref.watch(settingsProvider).showPhaseCountdown
                          ? Text(
                              '$countdown',
                              key: ValueKey<int>(countdown),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              if (!isActive) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Session'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    final settings = ref.read(settingsProvider);
                    ref
                        .read(breathePhaseProvider.notifier)
                        .startSession(ref, settings.sessionDurationSeconds);
                  },
                ),
                const SizedBox(height: 24),
              ],
              if (isActive) ...[
                const SizedBox(height: 25),
                Text(
                  phase.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: circleColor.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Session Stats',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              label: 'Breaths',
                              value: '$breathCount',
                              icon: Icons.air,
                            ),
                            _StatItem(
                              label: 'Time',
                              value: formatDuration(elapsedSeconds),
                              icon: Icons.timer,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                      icon: Icon(
                        isPaused
                            ? Icons.play_circle_filled
                            : Icons.pause_circle_filled,
                        size: 56,
                        color: circleColor,
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        final controller =
                            ref.read(breathePhaseProvider.notifier);
                        if (isPaused) {
                          controller.resume(ref);
                        } else {
                          controller.pause(ref);
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.stop),
                      label: const Text('End Session'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        final count = ref.read(breathCountProvider);
                        final duration = ref.read(sessionDurationProvider);

                        // Save session to history
                        ref.read(sessionHistoryProvider.notifier).add(
                              Session(
                                date: DateTime.now(),
                                breathsTaken: count,
                                durationInSeconds: duration,
                              ),
                            );

                        // End session and return
                        ref
                            .read(breathePhaseProvider.notifier)
                            .endSession(ref: ref);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
