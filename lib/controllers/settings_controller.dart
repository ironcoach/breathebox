import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'inhaleSeconds': inhaleSeconds,
      'holdSeconds': holdSeconds,
      'exhaleSeconds': exhaleSeconds,
      'restSeconds': restSeconds,
      'sessionDurationSeconds': sessionDurationSeconds,
      'showPhaseCountdown': showPhaseCountdown,
    };
  }

  factory BreathingSettings.fromMap(Map<String, dynamic> map) {
    return BreathingSettings(
      inhaleSeconds: map['inhaleSeconds'] ?? 4,
      holdSeconds: map['holdSeconds'] ?? 4,
      exhaleSeconds: map['exhaleSeconds'] ?? 4,
      restSeconds: map['restSeconds'] ?? 4,
      sessionDurationSeconds: map['sessionDurationSeconds'] ?? 300,
      showPhaseCountdown: map['showPhaseCountdown'] ?? true,
    );
  }
}

class SettingsController extends StateNotifier<BreathingSettings> {
  final LocalStorageService _storage;
  static const _key = 'breathing_settings';

  SettingsController(this._storage)
      : super(const BreathingSettings(
          inhaleSeconds: 4,
          holdSeconds: 4,
          exhaleSeconds: 4,
          restSeconds: 4,
          sessionDurationSeconds: 300,
          showPhaseCountdown: true,
        )) {
    _loadSettings();
  }

  void _loadSettings() async {
    final jsonString = await _storage.readString(_key);
    if (jsonString != null) {
      try {
        final map = json.decode(jsonString) as Map<String, dynamic>;
        state = BreathingSettings.fromMap(map);
      } catch (e) {
        print('Error loading settings: $e');
      }
    }
  }

  void updateSettings({
    int? inhaleSeconds,
    int? holdSeconds,
    int? exhaleSeconds,
    int? restSeconds,
    int? sessionDurationSeconds,
    bool? showPhaseCountdown,
  }) {
    state = state.copyWith(
      inhaleSeconds: inhaleSeconds,
      holdSeconds: holdSeconds,
      exhaleSeconds: exhaleSeconds,
      restSeconds: restSeconds,
      sessionDurationSeconds: sessionDurationSeconds,
      showPhaseCountdown: showPhaseCountdown,
    );
    _saveSettings();
  }

  void _saveSettings() async {
    try {
      await _storage.saveString(_key, json.encode(state.toMap()));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }
}

// Update provider to inject LocalStorageService
final settingsProvider =
    StateNotifierProvider<SettingsController, BreathingSettings>((ref) {
  return SettingsController(LocalStorageService());
});
