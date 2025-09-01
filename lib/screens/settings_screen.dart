import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Settings'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick preset cards
            Text(
              'Quick Presets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PresetCard(
                    title: 'Quick Breaths',
                    description: '3 seconds per phase',
                    onTap: () {
                      ref.read(settingsProvider.notifier).updateSettings(
                            inhaleSeconds: 3,
                            holdSeconds: 3,
                            exhaleSeconds: 3,
                            restSeconds: 3,
                          );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PresetCard(
                    title: 'Slow Breaths',
                    description: '6 seconds per phase',
                    onTap: () {
                      ref.read(settingsProvider.notifier).updateSettings(
                            inhaleSeconds: 6,
                            holdSeconds: 6,
                            exhaleSeconds: 6,
                            restSeconds: 6,
                          );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Custom duration controls
            Text(
              'Custom Durations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _DurationSlider(
              label: 'Inhale Duration',
              value: settings.inhaleSeconds,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                      inhaleSeconds: value,
                    );
              },
            ),
            _DurationSlider(
              label: 'Hold Duration',
              value: settings.holdSeconds,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                      holdSeconds: value,
                    );
              },
            ),
            _DurationSlider(
              label: 'Exhale Duration',
              value: settings.exhaleSeconds,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                      exhaleSeconds: value,
                    );
              },
            ),
            _DurationSlider(
              label: 'Rest Duration',
              value: settings.restSeconds,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                      restSeconds: value,
                    );
              },
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: SwitchListTile(
                title: const Text('Show Phase Countdown'),
                subtitle:
                    const Text('Display remaining seconds for each phase'),
                value: settings.showPhaseCountdown,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        showPhaseCountdown: value,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _PresetCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationSlider extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _DurationSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value}s'),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}
