import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breathing Square',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFF1A1A1A),
        cardColor: Color(0xFF2D2D2D),
      ),
      themeMode: ThemeMode.system,
      home: SetupScreen(),
    );
  }
}

class BreathingPreset {
  final String name;
  final String description;
  final int inhale;
  final int holdAfterInhale;
  final int exhale;
  final int holdAfterExhale;
  final Color color;

  BreathingPreset({
    required this.name,
    required this.description,
    required this.inhale,
    required this.holdAfterInhale,
    required this.exhale,
    required this.holdAfterExhale,
    required this.color,
  });
}

class BreathingSettings {
  int inhaleDuration = 4;
  int holdAfterInhaleDuration = 2;
  int exhaleDuration = 4;
  int holdAfterExhaleDuration = 2;

  int transitionInhaleDuration = 3;
  int transitionHoldAfterInhaleDuration = 1;
  int transitionExhaleDuration = 3;
  int transitionHoldAfterExhaleDuration = 1;

  bool useTransition = false;
  int totalDurationMinutes = 5;

  // Warmup settings
  bool useWarmup = false;
  int warmupDurationMinutes = 1;
  int warmupInhaleDuration = 3;
  int warmupHoldAfterInhaleDuration = 1;
  int warmupExhaleDuration = 3;
  int warmupHoldAfterExhaleDuration = 1;

  // Audio settings
  bool enableAudio = true;
  bool enableVoiceGuide = false;
  double audioVolume = 0.7;
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final BreathingSettings settings = BreathingSettings();

  final List<BreathingPreset> presets = [
    BreathingPreset(
      name: 'Relaxation',
      description: 'Equal breathing for calm relaxation',
      inhale: 4,
      holdAfterInhale: 4,
      exhale: 4,
      holdAfterExhale: 4,
      color: Colors.blue,
    ),
    BreathingPreset(
      name: 'Stress Relief',
      description: 'Extended exhale for anxiety reduction',
      inhale: 4,
      holdAfterInhale: 7,
      exhale: 8,
      holdAfterExhale: 0,
      color: Colors.green,
    ),
    BreathingPreset(
      name: 'Focus',
      description: 'Energizing breath for concentration',
      inhale: 6,
      holdAfterInhale: 2,
      exhale: 6,
      holdAfterExhale: 2,
      color: Colors.orange,
    ),
    BreathingPreset(
      name: 'Deep Calm',
      description: 'Slow, deep breathing for meditation',
      inhale: 6,
      holdAfterInhale: 6,
      exhale: 6,
      holdAfterExhale: 6,
      color: Colors.purple,
    ),
    BreathingPreset(
      name: 'Beginner',
      description: 'Gentle pattern for new users',
      inhale: 3,
      holdAfterInhale: 1,
      exhale: 3,
      holdAfterExhale: 1,
      color: Colors.teal,
    ),
  ];

  void _applyPreset(BreathingPreset preset) {
    setState(() {
      settings.inhaleDuration = preset.inhale;
      settings.holdAfterInhaleDuration = preset.holdAfterInhale;
      settings.exhaleDuration = preset.exhale;
      settings.holdAfterExhaleDuration = preset.holdAfterExhale;
    });
  }

  Widget _buildPresetCard(BreathingPreset preset) {
    return Card(
      child: InkWell(
        onTap: () => _applyPreset(preset),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: preset.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            preset.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        preset.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${preset.inhale}-${preset.holdAfterInhale}-${preset.exhale}-${preset.holdAfterExhale}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: preset.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSlider(
      String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value}s'),
        Slider(
          value: value.toDouble(),
          min: 1.0,
          max: 15.0,
          divisions: 14,
          onChanged: (double newValue) => onChanged(newValue.round()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathing Square - Setup'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Breathing Presets
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Start Presets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap a preset to apply its breathing pattern',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: presets.length,
                          itemBuilder: (context, index) =>
                              _buildPresetCard(presets[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Audio Settings
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Enable Audio Cues'),
                        Spacer(),
                        Switch(
                          value: settings.enableAudio,
                          onChanged: (value) {
                            setState(() => settings.enableAudio = value);
                          },
                        ),
                      ],
                    ),
                    if (settings.enableAudio) ...[
                      Row(
                        children: [
                          Text('Voice Guidance'),
                          Spacer(),
                          Switch(
                            value: settings.enableVoiceGuide,
                            onChanged: (value) {
                              setState(() => settings.enableVoiceGuide = value);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Audio Volume: ${(settings.audioVolume * 100).round()}%'),
                      Slider(
                        value: settings.audioVolume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() => settings.audioVolume = value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Main Phase Durations
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Phase Durations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildDurationSlider('Inhale', settings.inhaleDuration,
                        (value) {
                      setState(() => settings.inhaleDuration = value);
                    }),
                    _buildDurationSlider(
                        'Hold (after inhale)', settings.holdAfterInhaleDuration,
                        (value) {
                      setState(() => settings.holdAfterInhaleDuration = value);
                    }),
                    _buildDurationSlider('Exhale', settings.exhaleDuration,
                        (value) {
                      setState(() => settings.exhaleDuration = value);
                    }),
                    _buildDurationSlider(
                        'Hold (after exhale)', settings.holdAfterExhaleDuration,
                        (value) {
                      setState(() => settings.holdAfterExhaleDuration = value);
                    }),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Warmup settings
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Warmup Period',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: settings.useWarmup,
                          onChanged: (value) {
                            setState(() => settings.useWarmup = value);
                          },
                        ),
                      ],
                    ),
                    if (settings.useWarmup) ...[
                      Text(
                        'Start with shorter durations, then transition to main durations',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Warmup Duration: ${settings.warmupDurationMinutes} minutes',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Slider(
                        value: settings.warmupDurationMinutes.toDouble(),
                        min: 1.0,
                        max: 5.0,
                        divisions: 4,
                        onChanged: (value) {
                          setState(() =>
                              settings.warmupDurationMinutes = value.round());
                        },
                      ),
                      SizedBox(height: 8),
                      _buildDurationSlider(
                          'Warmup Inhale', settings.warmupInhaleDuration,
                          (value) {
                        setState(() => settings.warmupInhaleDuration = value);
                      }),
                      _buildDurationSlider('Warmup Hold (after inhale)',
                          settings.warmupHoldAfterInhaleDuration, (value) {
                        setState(() =>
                            settings.warmupHoldAfterInhaleDuration = value);
                      }),
                      _buildDurationSlider(
                          'Warmup Exhale', settings.warmupExhaleDuration,
                          (value) {
                        setState(() => settings.warmupExhaleDuration = value);
                      }),
                      _buildDurationSlider('Warmup Hold (after exhale)',
                          settings.warmupHoldAfterExhaleDuration, (value) {
                        setState(() =>
                            settings.warmupHoldAfterExhaleDuration = value);
                      }),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Transition settings
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mid-Session Transition',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: settings.useTransition,
                          onChanged: (value) {
                            setState(() => settings.useTransition = value);
                          },
                        ),
                      ],
                    ),
                    if (settings.useTransition) ...[
                      Text(
                        'These durations will be used in the second half of the session',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 8),
                      _buildDurationSlider('Transition Inhale',
                          settings.transitionInhaleDuration, (value) {
                        setState(
                            () => settings.transitionInhaleDuration = value);
                      }),
                      _buildDurationSlider('Transition Hold (after inhale)',
                          settings.transitionHoldAfterInhaleDuration, (value) {
                        setState(() =>
                            settings.transitionHoldAfterInhaleDuration = value);
                      }),
                      _buildDurationSlider('Transition Exhale',
                          settings.transitionExhaleDuration, (value) {
                        setState(
                            () => settings.transitionExhaleDuration = value);
                      }),
                      _buildDurationSlider('Transition Hold (after exhale)',
                          settings.transitionHoldAfterExhaleDuration, (value) {
                        setState(() =>
                            settings.transitionHoldAfterExhaleDuration = value);
                      }),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Total duration
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Session Duration: ${settings.totalDurationMinutes} minutes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: settings.totalDurationMinutes.toDouble(),
                      min: 1.0,
                      max: 30.0,
                      divisions: 29,
                      onChanged: (value) {
                        setState(() =>
                            settings.totalDurationMinutes = value.round());
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          BreathingSquareScreen(settings: settings),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Start Breathing Session',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreathingSquareScreen extends StatefulWidget {
  final BreathingSettings settings;

  const BreathingSquareScreen({super.key, required this.settings});

  @override
  _BreathingSquareScreenState createState() => _BreathingSquareScreenState();
}

class _BreathingSquareScreenState extends State<BreathingSquareScreen>
    with TickerProviderStateMixin {
  late AnimationController _sizeAnimationController;
  late AnimationController _progressAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  Timer? _phaseTimer;
  Timer? _totalTimer;

  // Animation state
  bool _isAnimating = false;
  bool _isPaused = false;
  int _currentPhase = 0; // 0: inhale, 1: hold, 2: exhale, 3: hold
  String _currentPhaseName = 'Ready';
  String _phaseInstruction = 'Press Start to Begin';
  int _remainingMinutes = 0;
  int _remainingSeconds = 0;
  int _elapsedTimeSeconds = 0;
  int _phaseRemainingSeconds = 0;
  int _completedCycles = 0;

  // Square size constraints
  final double _minSize = 100.0;
  final double _maxSize = 200.0;

  @override
  void initState() {
    super.initState();
    _sizeAnimationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(
      begin: _minSize,
      end: _maxSize,
    ).animate(CurvedAnimation(
      parent: _sizeAnimationController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimationController.repeat(reverse: true);
    _startBreathing();
  }

  @override
  void dispose() {
    _sizeAnimationController.dispose();
    _progressAnimationController.dispose();
    _pulseAnimationController.dispose();
    _phaseTimer?.cancel();
    _totalTimer?.cancel();
    super.dispose();
  }

  void _playAudioCue(String phase) {
    if (!widget.settings.enableAudio) return;

    // Simulate audio feedback - in a real app, you'd use audio plugins
    // For now, we'll use haptic feedback as a placeholder
    // Haptics.light();

    if (widget.settings.enableVoiceGuide) {
      // Voice guidance would be implemented here
      print('Voice: $phase'); // Debug placeholder
    }
  }

  bool _isInWarmupPeriod() {
    return widget.settings.useWarmup &&
        _elapsedTimeSeconds < (widget.settings.warmupDurationMinutes * 60);
  }

  bool _isInTransitionPeriod() {
    if (!widget.settings.useTransition) return false;

    int totalSeconds = widget.settings.totalDurationMinutes * 60;
    int warmupSeconds = widget.settings.useWarmup
        ? widget.settings.warmupDurationMinutes * 60
        : 0;
    int remainingAfterWarmup = totalSeconds - warmupSeconds;
    int elapsedAfterWarmup = _elapsedTimeSeconds - warmupSeconds;

    return elapsedAfterWarmup > (remainingAfterWarmup ~/ 2);
  }

  int _getCurrentPhaseDuration(int phase) {
    if (_isInWarmupPeriod()) {
      switch (phase) {
        case 0:
          return widget.settings.warmupInhaleDuration;
        case 1:
          return widget.settings.warmupHoldAfterInhaleDuration;
        case 2:
          return widget.settings.warmupExhaleDuration;
        case 3:
          return widget.settings.warmupHoldAfterExhaleDuration;
        default:
          return 4;
      }
    } else if (_isInTransitionPeriod()) {
      switch (phase) {
        case 0:
          return widget.settings.transitionInhaleDuration;
        case 1:
          return widget.settings.transitionHoldAfterInhaleDuration;
        case 2:
          return widget.settings.transitionExhaleDuration;
        case 3:
          return widget.settings.transitionHoldAfterExhaleDuration;
        default:
          return 4;
      }
    } else {
      switch (phase) {
        case 0:
          return widget.settings.inhaleDuration;
        case 1:
          return widget.settings.holdAfterInhaleDuration;
        case 2:
          return widget.settings.exhaleDuration;
        case 3:
          return widget.settings.holdAfterExhaleDuration;
        default:
          return 4;
      }
    }
  }

  void _startBreathing() {
    if (_isPaused) {
      _resumeBreathing();
      return;
    }

    if (_isAnimating) {
      _pauseBreathing();
      return;
    }

    setState(() {
      _isAnimating = true;
      _isPaused = false;
      _currentPhase = 0;
      _currentPhaseName = 'Inhale';
      _phaseInstruction = 'Breathe in slowly and deeply';
      _elapsedTimeSeconds = 0;
      _completedCycles = 0;
    });

    _startTotalTimer();
    _runBreathingCycle();
  }

  void _pauseBreathing() {
    setState(() {
      _isPaused = true;
      _phaseInstruction = 'Session Paused';
    });

    _phaseTimer?.cancel();
    _totalTimer?.cancel();
    _sizeAnimationController.stop();
    _progressAnimationController.stop();
  }

  void _resumeBreathing() {
    setState(() {
      _isPaused = false;
      _isAnimating = true;
    });

    _startTotalTimer();
    _runBreathingCycle();
  }

  void _stopBreathing() {
    setState(() {
      _isAnimating = false;
      _isPaused = false;
      _currentPhaseName = 'Session Complete';
      _phaseInstruction = 'Well done! Session completed successfully.';
    });

    _phaseTimer?.cancel();
    _totalTimer?.cancel();
    _sizeAnimationController.stop();
    _progressAnimationController.stop();
    _sizeAnimationController.reset();
    _progressAnimationController.reset();
  }

  void _startTotalTimer() {
    int totalSeconds = (widget.settings.totalDurationMinutes * 60);

    _totalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          totalSeconds--;
          _elapsedTimeSeconds++;
          _remainingMinutes = totalSeconds ~/ 60;
          _remainingSeconds = totalSeconds % 60;

          // Update phase remaining seconds
          if (_phaseRemainingSeconds > 0) {
            _phaseRemainingSeconds--;
          }
        });

        if (totalSeconds <= 0) {
          _stopBreathing();
        }
      }
    });

    // Set initial display
    setState(() {
      _remainingMinutes = totalSeconds ~/ 60;
      _remainingSeconds = totalSeconds % 60;
    });
  }

  void _runBreathingCycle() {
    if (!_isAnimating || _isPaused) return;

    switch (_currentPhase) {
      case 0: // Inhale
        _inhale();
        break;
      case 1: // Hold after inhale
        _holdAfterInhale();
        break;
      case 2: // Exhale
        _exhale();
        break;
      case 3: // Hold after exhale
        _holdAfterExhale();
        break;
    }
  }

  void _inhale() {
    int duration = _getCurrentPhaseDuration(0);

    setState(() {
      _phaseRemainingSeconds = duration;
      _phaseInstruction = 'Breathe in slowly and deeply';
    });

    _playAudioCue('inhale');

    _sizeAnimationController.duration =
        Duration(milliseconds: (duration * 1000));
    _progressAnimationController.duration =
        Duration(milliseconds: (duration * 1000));

    _sizeAnimationController.forward(from: 0);
    _progressAnimationController.forward(from: 0);

    _phaseTimer = Timer(Duration(milliseconds: (duration * 1000)), () {
      if (_isAnimating && !_isPaused) {
        setState(() {
          _currentPhase = 1;
          _currentPhaseName = 'Hold';
        });
        _runBreathingCycle();
      }
    });
  }

  void _holdAfterInhale() {
    int duration = _getCurrentPhaseDuration(1);

    setState(() {
      _phaseRemainingSeconds = duration;
      _phaseInstruction =
          duration > 0 ? 'Hold your breath gently' : 'Preparing to exhale';
    });

    if (duration > 0) _playAudioCue('hold');

    _progressAnimationController.duration =
        Duration(milliseconds: (duration * 1000));
    _progressAnimationController.forward(from: 0);

    _phaseTimer = Timer(Duration(milliseconds: (duration * 1000)), () {
      if (_isAnimating && !_isPaused) {
        setState(() {
          _currentPhase = 2;
          _currentPhaseName = 'Exhale';
        });
        _runBreathingCycle();
      }
    });
  }

  void _exhale() {
    int duration = _getCurrentPhaseDuration(2);

    setState(() {
      _phaseRemainingSeconds = duration;
      _phaseInstruction = 'Release and let go completely';
    });

    _playAudioCue('exhale');

    _sizeAnimationController.duration =
        Duration(milliseconds: (duration * 1000));
    _progressAnimationController.duration =
        Duration(milliseconds: (duration * 1000));

    _sizeAnimationController.reverse(from: 1);
    _progressAnimationController.forward(from: 0);

    _phaseTimer = Timer(Duration(milliseconds: (duration * 1000)), () {
      if (_isAnimating && !_isPaused) {
        setState(() {
          _currentPhase = 3;
          _currentPhaseName = 'Hold';
        });
        _runBreathingCycle();
      }
    });
  }

  void _holdAfterExhale() {
    int duration = _getCurrentPhaseDuration(3);

    setState(() {
      _phaseRemainingSeconds = duration;
      _phaseInstruction =
          duration > 0 ? 'Rest in stillness' : 'Preparing next breath';
    });

    if (duration > 0) _playAudioCue('hold');

    _progressAnimationController.duration =
        Duration(milliseconds: (duration * 1000));
    _progressAnimationController.forward(from: 0);

    _phaseTimer = Timer(Duration(milliseconds: (duration * 1000)), () {
      if (_isAnimating && !_isPaused) {
        setState(() {
          _currentPhase = 0;
          _currentPhaseName = 'Inhale';
          _completedCycles++;
        });
        _runBreathingCycle();
      }
    });
  }

  String _getCurrentPeriodText() {
    if (_isInWarmupPeriod()) {
      return 'Warmup Period';
    } else if (_isInTransitionPeriod()) {
      return 'Extended Phase';
    } else {
      return 'Main Phase';
    }
  }

  Color _getCurrentPhaseColor() {
    switch (_currentPhase) {
      case 0:
        return Colors.blue; // Inhale
      case 1:
        return Colors.purple; // Hold
      case 2:
        return Colors.green; // Exhale
      case 3:
        return Colors.orange; // Hold
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          title: Text('Breathing Session'),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.blue.shade100,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            if (_isAnimating || _isPaused)
              IconButton(
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                onPressed: _startBreathing,
                tooltip: _isPaused ? 'Resume' : 'Pause',
              ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [Color(0xFF1A1A1A), Color(0xFF2D2D2D)]
                  : [Colors.blue.shade50, Colors.white],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Period indicator and cycle counter
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _getCurrentPhaseColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _getCurrentPhaseColor()),
                          ),
                          child: Text(
                            _getCurrentPeriodText(),
                            style: TextStyle(
                              fontSize: 14,
                              color: _getCurrentPhaseColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (_completedCycles > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh,
                                    size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 4),
                                Text(
                                  '$_completedCycles cycles',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Circular progress ring
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double size = math.min(constraints.maxWidth - 40, 320);
                      return SizedBox(
                        width: size,
                        height: size,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circle
                            CustomPaint(
                              painter: CircularProgressPainter(
                                progress: 1.0,
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 6,
                              ),
                              size: Size(size, size),
                            ),
                            // Session progress circle
                            CustomPaint(
                              painter: CircularProgressPainter(
                                progress: (_elapsedTimeSeconds /
                                        (widget.settings.totalDurationMinutes *
                                            60))
                                    .clamp(0.0, 1.0),
                                color: _getCurrentPhaseColor().withOpacity(0.4),
                                strokeWidth: 6,
                              ),
                              size: Size(size, size),
                            ),
                            // Phase progress circle
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: CircularProgressPainter(
                                    progress: _progressAnimation.value,
                                    color: _getCurrentPhaseColor(),
                                    strokeWidth: 8,
                                  ),
                                  size: Size(size - 20, size - 20),
                                );
                              },
                            ),

                            // Animation area with progress line
                            SizedBox(
                              width: size - 40,
                              height: size - 40,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Animated square with pulse effect
                                  AnimatedBuilder(
                                    animation: Listenable.merge(
                                        [_sizeAnimation, _pulseAnimation]),
                                    builder: (context, child) {
                                      double pulseScale = (_currentPhase == 1 ||
                                              _currentPhase == 3)
                                          ? _pulseAnimation.value
                                          : 1.0;
                                      double adjustedSize = math.min(
                                          _sizeAnimation.value,
                                          (size - 80) * 0.7);
                                      return Transform.scale(
                                        scale: pulseScale,
                                        child: Container(
                                          width: adjustedSize,
                                          height: adjustedSize,
                                          decoration: BoxDecoration(
                                            color: _getCurrentPhaseColor()
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _getCurrentPhaseColor()
                                                    .withOpacity(0.4),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 30),

                  // Phase name with countdown
                  Text(
                    _currentPhaseName,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _getCurrentPhaseColor(),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Phase instruction
                  Container(
                    constraints: BoxConstraints(maxWidth: 280),
                    child: Text(
                      _phaseInstruction,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Phase countdown
                  if (_isAnimating && !_isPaused)
                    Text(
                      '${_phaseRemainingSeconds}s',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: _getCurrentPhaseColor(),
                      ),
                    ),

                  SizedBox(height: 20),

                  // Session timer
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 20,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '$_remainingMinutes:${_remainingSeconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Start/Pause/Resume button
                      ElevatedButton(
                        onPressed: _startBreathing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPaused
                              ? Colors.green
                              : _isAnimating
                                  ? Colors.orange
                                  : Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPaused
                                  ? Icons.play_arrow
                                  : _isAnimating
                                      ? Icons.pause
                                      : Icons.play_arrow,
                            ),
                            SizedBox(width: 8),
                            Text(
                              _isPaused
                                  ? 'Resume'
                                  : _isAnimating
                                      ? 'Pause'
                                      : 'Start',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      // Stop button
                      if (_isAnimating || _isPaused)
                        ElevatedButton(
                          onPressed: _stopBreathing,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stop),
                              SizedBox(width: 8),
                              Text(
                                'Stop',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc from top, clockwise
    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ProgressLinePainter extends CustomPainter {
  final double progress;
  final int phase;
  final double squareSize;

  ProgressLinePainter({
    required this.progress,
    required this.phase,
    required this.squareSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final halfSize = squareSize / 2 + 10; // 10px padding around square

    // Define the four corners of the square path
    final topLeft = Offset(center.dx - halfSize, center.dy - halfSize);
    final topRight = Offset(center.dx + halfSize, center.dy - halfSize);
    final bottomRight = Offset(center.dx + halfSize, center.dy + halfSize);
    final bottomLeft = Offset(center.dx - halfSize, center.dy + halfSize);

    final path = Path();

    // Calculate progress along the perimeter based on phase
    double totalProgress = (phase + progress) / 4.0;
    if (totalProgress > 1.0) totalProgress = totalProgress - 1.0;

    // Draw the progress line around the square perimeter
    path.moveTo(topLeft.dx, topLeft.dy);

    double perimeterProgress = totalProgress * 4;

    if (perimeterProgress <= 1.0) {
      // Top edge
      double x = topLeft.dx + (topRight.dx - topLeft.dx) * perimeterProgress;
      path.lineTo(x, topLeft.dy);
    } else if (perimeterProgress <= 2.0) {
      // Top edge complete, right edge
      path.lineTo(topRight.dx, topRight.dy);
      double y = topRight.dy +
          (bottomRight.dy - topRight.dy) * (perimeterProgress - 1.0);
      path.lineTo(topRight.dx, y);
    } else if (perimeterProgress <= 3.0) {
      // Top and right edges complete, bottom edge
      path.lineTo(topRight.dx, topRight.dy);
      path.lineTo(bottomRight.dx, bottomRight.dy);
      double x = bottomRight.dx -
          (bottomRight.dx - bottomLeft.dx) * (perimeterProgress - 2.0);
      path.lineTo(x, bottomRight.dy);
    } else {
      // Top, right, and bottom edges complete, left edge
      path.lineTo(topRight.dx, topRight.dy);
      path.lineTo(bottomRight.dx, bottomRight.dy);
      path.lineTo(bottomLeft.dx, bottomLeft.dy);
      double y = bottomLeft.dy -
          (bottomLeft.dy - topLeft.dy) * (perimeterProgress - 3.0);
      path.lineTo(bottomLeft.dx, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
