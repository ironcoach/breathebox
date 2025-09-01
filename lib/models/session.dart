class Session {
  final DateTime date;
  final int breathsTaken;
  final int durationInSeconds;

  const Session({
    required this.date,
    required this.breathsTaken,
    required this.durationInSeconds,
  });

  // Convert session to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'breathsTaken': breathsTaken,
      'durationInSeconds': durationInSeconds,
    };
  }

  // Create session from a map (for loading from storage)
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      date: DateTime.parse(map['date'] as String),
      breathsTaken: map['breathsTaken'] as int,
      durationInSeconds: map['durationInSeconds'] as int,
    );
  }

  // Helper method to format duration as MM:SS
  String get formattedDuration {
    final minutes = durationInSeconds ~/ 60;
    final seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Helper method to format date
  String get formattedDate {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Copy with method for immutability
  Session copyWith({
    DateTime? date,
    int? breathsTaken,
    int? durationInSeconds,
  }) {
    return Session(
      date: date ?? this.date,
      breathsTaken: breathsTaken ?? this.breathsTaken,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
    );
  }

  @override
  String toString() {
    return 'Session(date: $formattedDate, breaths: $breathsTaken, duration: $formattedDuration)';
  }
}
