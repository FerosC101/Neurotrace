import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/reaction_time_result.dart';

enum ReactionTestState {
  instructions,
  ready,
  waiting,
  tap,
  result,
  completed,
}

class ReactionTimeProvider with ChangeNotifier {
  ReactionTestState _state = ReactionTestState.instructions;
  final List<int> _reactionTimes = [];
  int _falseStarts = 0;
  int _currentRound = 0;
  final int _totalRounds = 5;
  Stopwatch? _stopwatch;
  DateTime? _stimulusStartTime;
  ReactionTimeResult? _finalResult;

  // Getters
  ReactionTestState get state => _state;
  List<int> get reactionTimes => List.unmodifiable(_reactionTimes);
  int get falseStarts => _falseStarts;
  int get currentRound => _currentRound;
  int get totalRounds => _totalRounds;
  ReactionTimeResult? get finalResult => _finalResult;
  double get progress => _currentRound / _totalRounds;

  void startTest() {
    _state = ReactionTestState.ready;
    _reactionTimes.clear();
    _falseStarts = 0;
    _currentRound = 0;
    _finalResult = null;
    notifyListeners();
  }

  void beginRound() {
    if (_currentRound >= _totalRounds) {
      _completeTest();
      return;
    }

    _state = ReactionTestState.waiting;
    _stopwatch = Stopwatch();
    notifyListeners();

    // Random delay between 2-5 seconds
    final delay = Duration(milliseconds: 2000 + (DateTime.now().millisecond % 3000));
    
    Future.delayed(delay, () {
      if (_state == ReactionTestState.waiting) {
        _showStimulus();
      }
    });
  }

  void _showStimulus() {
    _state = ReactionTestState.tap;
    _stimulusStartTime = DateTime.now();
    _stopwatch?.start();
    notifyListeners();
  }

  void onTap() {
    if (_state == ReactionTestState.waiting) {
      // False start - tapped before stimulus appeared
      _falseStarts++;
      _state = ReactionTestState.result;
      notifyListeners();
      
      // Move to next round after showing false start message
      Future.delayed(const Duration(seconds: 2), () {
        _currentRound++;
        if (_currentRound < _totalRounds) {
          beginRound();
        } else {
          _completeTest();
        }
      });
      return;
    }

    if (_state == ReactionTestState.tap) {
      _stopwatch?.stop();
      final reactionTime = _stopwatch?.elapsedMilliseconds ?? 0;
      _reactionTimes.add(reactionTime);
      _state = ReactionTestState.result;
      _currentRound++;
      notifyListeners();

      // Auto-advance to next round after showing result
      Future.delayed(const Duration(seconds: 1), () {
        if (_currentRound < _totalRounds) {
          beginRound();
        } else {
          _completeTest();
        }
      });
    }
  }

  void _completeTest() {
    _finalResult = ReactionTimeResult.fromReactionTimes(
      id: const Uuid().v4(),
      userId: 'current_user', // TODO: Get from auth provider
      times: _reactionTimes,
      falseStarts: _falseStarts,
    );
    _state = ReactionTestState.completed;
    notifyListeners();

    // TODO: Save result to local storage
    // TODO: Upload result to backend
  }

  void reset() {
    _state = ReactionTestState.instructions;
    _reactionTimes.clear();
    _falseStarts = 0;
    _currentRound = 0;
    _stopwatch = null;
    _stimulusStartTime = null;
    _finalResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopwatch?.stop();
    super.dispose();
  }
}
