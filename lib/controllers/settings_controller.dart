import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:shared_preferences/shared_preferences.dart';

//import 'package:shared_preferences.dart';

class BreathingSettings {
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int restSeconds;
  final int sessionDurationSeconds;
  final bool showPhaseCountdown; // Add this field

  const BreathingSettings({
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.restSeconds,
    this.sessionDurationSeconds = 300,
    this.showPhaseCountdown = true, // Add this field // Default 5 minutes
  });

  BreathingSettings copyWith({
    int? inhaleSeconds,
    int? holdSeconds,
    int? exhaleSeconds,
    int? restSeconds,
    int? sessionDurationSeconds,
    bool? showPhaseCountdown,
  }) {
    return BreathingSettings(
      inhaleSeconds: inhaleSeconds ?? this.inhaleSeconds,
      holdSeconds: holdSeconds ?? this.holdSeconds,
      exhaleSeconds: exhaleSeconds ?? this.exhaleSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      sessionDurationSeconds:
          sessionDurationSeconds ?? this.sessionDurationSeconds,
      showPhaseCountdown: showPhaseCountdown ?? this.showPhaseCountdown,
    );
  }
}

class SettingsController extends StateNotifier<BreathingSettings> {
  SettingsController()
      : super(const BreathingSettings(
          inhaleSeconds: 4,
          holdSeconds: 4,
          exhaleSeconds: 4,
          restSeconds: 4,
          sessionDurationSeconds: 300,
          showPhaseCountdown: true,
        ));

  void updateSettings({
    int? inhaleSeconds,
    int? holdSeconds,
    int? exhaleSeconds,
    int? restSeconds,
    int? sessionDurationSeconds,
    bool? showPhaseCountdown, // Add this parameter
  }) {
    state = state.copyWith(
      inhaleSeconds: inhaleSeconds,
      holdSeconds: holdSeconds,
      exhaleSeconds: exhaleSeconds,
      restSeconds: restSeconds,
      sessionDurationSeconds: sessionDurationSeconds,
      showPhaseCountdown: showPhaseCountdown,
    );
  }
}

// Add this provider definition
final settingsProvider =
    StateNotifierProvider<SettingsController, BreathingSettings>((ref) {
  return SettingsController();
});
