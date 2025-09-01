import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session.dart';
import 'settings_controller.dart';

import 'session_controller.dart';

// Current breathing phase
enum BreathPhase { inhale, hold, exhale, rest }

// Animation control command
enum AnimationCommand { forward, reverse, stop }

// Breath counter for the active session
final breathCountProvider = StateProvider<int>((ref) => 0);

// Seconds left in the current phase
final phaseCountdownProvider = StateProvider<int>((ref) => 0);

// Total elapsed seconds in session
final sessionDurationProvider = StateProvider<int>((ref) => 0);

// Animation command + optional duration (in seconds)
final animCommandProvider = StateProvider<(AnimationCommand, int?)>(
    (ref) => (AnimationCommand.stop, null));

// Paused state
final isPausedProvider = StateProvider<bool>((ref) => false);

// // Session history
// final sessionHistoryProvider =
//     StateNotifierProvider<SessionHistoryController, List<Session>>(
//         (ref) => SessionHistoryController());

// class SessionHistoryController extends StateNotifier<List<Session>> {
//   SessionHistoryController() : super([]);

//   void add(Session session) {
//     state = [...state, session];
//   }

//   void removeAt(int index) {
//     final list = [...state];
//     list.removeAt(index);
//     state = list;
//   }

//   void clear() {
//     state = [];
//   }
// }

class BreatheController extends StateNotifier<BreathPhase> {
  BreatheController() : super(BreathPhase.inhale);

  final _audioPlayer = AudioPlayer();
  Timer? _sessionTimer;
  Timer? _phaseTimer;
  int _elapsedSeconds = 0;
  int _phaseIndex = 0;
  bool _isPaused = false;
  bool _isSessionActive = false;
  late int _totalDurationSec;
  late List<(BreathPhase, int, String)> _phases;

  bool get isPaused => _isPaused;
  bool get isSessionActive => _isSessionActive;

  void startSession(WidgetRef ref, int totalDurationSec) {
    _totalDurationSec = totalDurationSec;
    final settings = ref.read(settingsProvider);

    _phases = [
      (BreathPhase.inhale, settings.inhaleSeconds, 'sounds/inhale.mp3'),
      (BreathPhase.hold, settings.holdSeconds, 'sounds/hold.mp3'),
      (BreathPhase.exhale, settings.exhaleSeconds, 'sounds/exhale.mp3'),
      (BreathPhase.rest, settings.restSeconds, 'sounds/rest.mp3'),
    ];

    _elapsedSeconds = 0;
    _phaseIndex = 0;
    _isPaused = false;
    _isSessionActive = true;

    ref.read(breathCountProvider.notifier).state = 0;
    ref.read(phaseCountdownProvider.notifier).state = 0;
    ref.read(sessionDurationProvider.notifier).state = 0;
    ref.read(isPausedProvider.notifier).state = false;

    _startSessionTimer(ref);
    _startPhase(ref);
  }

  void pause(WidgetRef ref) {
    _isPaused = true;
    _sessionTimer?.cancel();
    _phaseTimer?.cancel();
    _audioPlayer.pause();
    ref.read(animCommandProvider.notifier).state =
        (AnimationCommand.stop, null);
    ref.read(isPausedProvider.notifier).state = true;
  }

  void resume(WidgetRef ref) {
    _isPaused = false;
    _startSessionTimer(ref);
    final currentPhaseTime = ref.read(phaseCountdownProvider);
    _startPhase(ref, currentPhaseTime);
    ref.read(isPausedProvider.notifier).state = false;
  }

  void _startSessionTimer(WidgetRef ref) {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        _elapsedSeconds++;
        ref.read(sessionDurationProvider.notifier).state = _elapsedSeconds;
        if (_elapsedSeconds >= _totalDurationSec) {
          endSession(ref: ref);
        }
      }
    });
  }

  void _startPhase(WidgetRef ref, [int? startFrom]) {
    final (phase, duration, sound) = _phases[_phaseIndex];
    state = phase;

    if (!_isPaused) {
      _playCue(sound);
    }

    final startTime = startFrom ?? duration;
    ref.read(phaseCountdownProvider.notifier).state = startTime;

    if (phase == BreathPhase.rest && startFrom == null) {
      ref.read(breathCountProvider.notifier).state++;
    }

    // ✅ FIX: Properly trigger animation commands
    if (!_isPaused) {
      switch (phase) {
        case BreathPhase.inhale:
          print("🫁 INHALE - Triggering FORWARD animation for ${duration}s");
          ref.read(animCommandProvider.notifier).state =
              (AnimationCommand.forward, duration);
          break;
        case BreathPhase.exhale:
          print("💨 EXHALE - Triggering REVERSE animation for ${duration}s");
          ref.read(animCommandProvider.notifier).state =
              (AnimationCommand.reverse, duration);
          break;
        case BreathPhase.hold:
          print("🫷 HOLD - Stopping animation");
          ref.read(animCommandProvider.notifier).state =
              (AnimationCommand.stop, null);
          break;
        case BreathPhase.rest:
          print("😌 REST - Stopping animation");
          ref.read(animCommandProvider.notifier).state =
              (AnimationCommand.stop, null);
          break;
      }
    }

    _phaseTimer?.cancel();
    int secondsLeft = startTime;
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isPaused) {
        t.cancel();
        return;
      }
      secondsLeft--;
      if (secondsLeft >= 0) {
        ref.read(phaseCountdownProvider.notifier).state = secondsLeft;
      }
      if (secondsLeft <= 0) {
        t.cancel();
        if (_elapsedSeconds >= _totalDurationSec) {
          endSession(ref: ref);
          return;
        }
        _phaseIndex = (_phaseIndex + 1) % _phases.length;
        _startPhase(ref);
      }
    });
  }

  Future<void> _playCue(String assetPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void endSession({WidgetRef? ref}) {
    _isSessionActive = false;
    _isPaused = false;
    _sessionTimer?.cancel();
    _phaseTimer?.cancel();
    _audioPlayer.stop();
    if (ref != null) {
      ref.read(phaseCountdownProvider.notifier).state = 0;
      ref.read(isPausedProvider.notifier).state = false;
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _phaseTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

final breathePhaseProvider =
    StateNotifierProvider<BreatheController, BreathPhase>((ref) {
  return BreatheController();
});
