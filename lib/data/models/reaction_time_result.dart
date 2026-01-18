import 'dart:math';

class ReactionTimeResult {
  final String id;
  final String userId;
  final DateTime timestamp;
  final List<int> reactionTimes; // in milliseconds
  final double averageTime;
  final int fastestTime;
  final int slowestTime;
  final double standardDeviation;
  final int falseStarts;
  final int totalAttempts;

  ReactionTimeResult({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.reactionTimes,
    required this.averageTime,
    required this.fastestTime,
    required this.slowestTime,
    required this.standardDeviation,
    required this.falseStarts,
    required this.totalAttempts,
  });

  factory ReactionTimeResult.fromReactionTimes({
    required String id,
    required String userId,
    required List<int> times,
    required int falseStarts,
  }) {
    final average = times.isEmpty ? 0.0 : times.reduce((a, b) => a + b) / times.length;
    final fastest = times.isEmpty ? 0 : times.reduce(min);
    final slowest = times.isEmpty ? 0 : times.reduce(max);
    
    double stdDev = 0.0;
    if (times.length > 1) {
      final variance = times.map((t) => pow(t - average, 2)).reduce((a, b) => a + b) / times.length;
      stdDev = sqrt(variance);
    }

    return ReactionTimeResult(
      id: id,
      userId: userId,
      timestamp: DateTime.now(),
      reactionTimes: times,
      averageTime: average,
      fastestTime: fastest,
      slowestTime: slowest,
      standardDeviation: stdDev,
      falseStarts: falseStarts,
      totalAttempts: times.length + falseStarts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'reactionTimes': reactionTimes,
      'averageTime': averageTime,
      'fastestTime': fastestTime,
      'slowestTime': slowestTime,
      'standardDeviation': standardDeviation,
      'falseStarts': falseStarts,
      'totalAttempts': totalAttempts,
    };
  }

  factory ReactionTimeResult.fromJson(Map<String, dynamic> json) {
    return ReactionTimeResult(
      id: json['id'] as String,
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reactionTimes: List<int>.from(json['reactionTimes']),
      averageTime: (json['averageTime'] as num).toDouble(),
      fastestTime: json['fastestTime'] as int,
      slowestTime: json['slowestTime'] as int,
      standardDeviation: (json['standardDeviation'] as num).toDouble(),
      falseStarts: json['falseStarts'] as int,
      totalAttempts: json['totalAttempts'] as int,
    );
  }
}
