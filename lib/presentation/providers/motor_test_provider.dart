import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/motor_test_result.dart';

enum MotorTestState {
  instructions,
  selectHand,
  countdown,
  testing,
  results,
  bothHandsComplete,
}

class MotorTestProvider with ChangeNotifier {
  MotorTestState _state = MotorTestState.instructions;
  String? _selectedHand;
  final List<DateTime> _tapTimes = [];
  Timer? _testTimer;
  int _remainingSeconds = 10;
  final int _testDuration = 10;
  MotorTestResult? _leftHandResult;
  MotorTestResult? _rightHandResult;

  // Getters
  MotorTestState get state => _state;
  String? get selectedHand => _selectedHand;
  List<DateTime> get tapTimes => List.unmodifiable(_tapTimes);
  int get remainingSeconds => _remainingSeconds;
  int get testDuration => _testDuration;
  int get tapCount => _tapTimes.length;
  MotorTestResult? get leftHandResult => _leftHandResult;
  MotorTestResult? get rightHandResult => _rightHandResult;
  
  bool get hasLeftResult => _leftHandResult != null;
  bool get hasRightResult => _rightHandResult != null;
  bool get bothHandsComplete => _leftHandResult != null && _rightHandResult != null;

  double get currentTapsPerSecond {
    if (_tapTimes.isEmpty) return 0.0;
    final elapsed = _testDuration - _remainingSeconds;
    if (elapsed == 0) return 0.0;
    return _tapTimes.length / elapsed;
  }

  void startTest() {
    _state = MotorTestState.selectHand;
    _leftHandResult = null;
    _rightHandResult = null;
    notifyListeners();
  }

  void selectHand(String hand) {
    _selectedHand = hand;
    _state = MotorTestState.countdown;
    notifyListeners();

    // Start countdown
    _startCountdown();
  }

  void _startCountdown() {
    int countdown = 3;
    
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown--;
      if (countdown <= 0) {
        timer.cancel();
        _beginTest();
      }
    });
  }

  void _beginTest() {
    _state = MotorTestState.testing;
    _tapTimes.clear();
    _remainingSeconds = _testDuration;
    notifyListeners();

    // Start test timer
    _testTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      notifyListeners();

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _completeTest();
      }
    });
  }

  void onTap() {
    if (_state == MotorTestState.testing) {
      _tapTimes.add(DateTime.now());
      notifyListeners();
    }
  }

  void _completeTest() {
    _testTimer?.cancel();

    final result = MotorTestResult.fromTapData(
      id: const Uuid().v4(),
      userId: 'current_user', // TODO: Get from auth provider
      hand: _selectedHand!,
      tapTimes: _tapTimes,
      durationMs: _testDuration * 1000,
    );

    if (_selectedHand == 'left') {
      _leftHandResult = result;
    } else {
      _rightHandResult = result;
    }

    _state = MotorTestState.results;
    notifyListeners();

    // TODO: Save result to local storage
    // TODO: Upload result to backend
  }

  void testOtherHand() {
    _state = MotorTestState.selectHand;
    _selectedHand = null;
    notifyListeners();
  }

  void viewBothResults() {
    _state = MotorTestState.bothHandsComplete;
    notifyListeners();
  }

  void reset() {
    _state = MotorTestState.instructions;
    _selectedHand = null;
    _tapTimes.clear();
    _testTimer?.cancel();
    _remainingSeconds = _testDuration;
    _leftHandResult = null;
    _rightHandResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _testTimer?.cancel();
    super.dispose();
  }
}
