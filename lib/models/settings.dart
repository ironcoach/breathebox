// lib/models/settings.dart
class Settings {
  final int sessionDurationSeconds;
  final bool darkMode;

  // Phase durations (seconds)
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int restSeconds;

  const Settings({
    this.sessionDurationSeconds = 60,
    this.darkMode = false,
    this.inhaleSeconds = 4,
    this.holdSeconds = 2,
    this.exhaleSeconds = 4,
    this.restSeconds = 2,
  });

  Settings copyWith({
    int? sessionDurationSeconds,
    bool? darkMode,
    int? inhaleSeconds,
    int? holdSeconds,
    int? exhaleSeconds,
    int? restSeconds,
  }) {
    return Settings(
      sessionDurationSeconds:
          sessionDurationSeconds ?? this.sessionDurationSeconds,
      darkMode: darkMode ?? this.darkMode,
      inhaleSeconds: inhaleSeconds ?? this.inhaleSeconds,
      holdSeconds: holdSeconds ?? this.holdSeconds,
      exhaleSeconds: exhaleSeconds ?? this.exhaleSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  Map<String, dynamic> toMap() => {
        'sessionDuration': sessionDurationSeconds,
        'darkMode': darkMode,
        'inhaleSeconds': inhaleSeconds,
        'holdSeconds': holdSeconds,
        'exhaleSeconds': exhaleSeconds,
        'restSeconds': restSeconds,
      };

  factory Settings.fromMap(Map<String, dynamic> map) => Settings(
        sessionDurationSeconds: map['sessionDuration'] ?? 60,
        darkMode: map['darkMode'] ?? false,
        inhaleSeconds: map['inhaleSeconds'] ?? 4,
        holdSeconds: map['holdSeconds'] ?? 2,
        exhaleSeconds: map['exhaleSeconds'] ?? 4,
        restSeconds: map['restSeconds'] ?? 2,
      );
}
