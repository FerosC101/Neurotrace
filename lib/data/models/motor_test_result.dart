import 'dart:math';

class MotorTestResult {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String hand; // 'left' or 'right'
  final int totalTaps;
  final double tapsPerSecond;
  final List<int> tapIntervals; // milliseconds between taps
  final double consistency; // standard deviation of intervals
  final double rhythm; // coefficient of variation

  MotorTestResult({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.hand,
    required this.totalTaps,
    required this.tapsPerSecond,
    required this.tapIntervals,
    required this.consistency,
    required this.rhythm,
  });

  factory MotorTestResult.fromTapData({
    required String id,
    required String userId,
    required String hand,
    required List<DateTime> tapTimes,
    required int durationMs,
  }) {
    final totalTaps = tapTimes.length;
    final tapsPerSecond = totalTaps / (durationMs / 1000.0);

    // Calculate intervals between consecutive taps
    final intervals = <int>[];
    for (int i = 1; i < tapTimes.length; i++) {
      final interval = tapTimes[i].difference(tapTimes[i - 1]).inMilliseconds;
      intervals.add(interval);
    }

    // Calculate consistency (standard deviation of intervals)
    double stdDev = 0.0;
    double avgInterval = 0.0;
    if (intervals.isNotEmpty) {
      avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      if (intervals.length > 1) {
        final variance = intervals
            .map((interval) => pow(interval - avgInterval, 2))
            .reduce((a, b) => a + b) / intervals.length;
        stdDev = sqrt(variance);
      }
    }

    // Calculate rhythm (coefficient of variation)
    final rhythm = avgInterval > 0 ? stdDev / avgInterval : 0.0;

    return MotorTestResult(
      id: id,
      userId: userId,
      timestamp: DateTime.now(),
      hand: hand,
      totalTaps: totalTaps,
      tapsPerSecond: tapsPerSecond,
      tapIntervals: intervals,
      consistency: stdDev,
      rhythm: rhythm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'hand': hand,
      'totalTaps': totalTaps,
      'tapsPerSecond': tapsPerSecond,
      'tapIntervals': tapIntervals,
      'consistency': consistency,
      'rhythm': rhythm,
    };
  }

  factory MotorTestResult.fromJson(Map<String, dynamic> json) {
    return MotorTestResult(
      id: json['id'] as String,
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      hand: json['hand'] as String,
      totalTaps: json['totalTaps'] as int,
      tapsPerSecond: (json['tapsPerSecond'] as num).toDouble(),
      tapIntervals: List<int>.from(json['tapIntervals']),
      consistency: (json['consistency'] as num).toDouble(),
      rhythm: (json['rhythm'] as num).toDouble(),
    );
  }
}
