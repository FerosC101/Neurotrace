import 'package:json_annotation/json_annotation.dart';

part 'test_result.g.dart';

/// Base test result model
@JsonSerializable()
class TestResult {
  final String id;
  final String userId;
  final String testType;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final double? score;

  TestResult({
    required this.id,
    required this.userId,
    required this.testType,
    required this.timestamp,
    required this.data,
    this.score,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) =>
      _$TestResultFromJson(json);

  Map<String, dynamic> toJson() => _$TestResultToJson(this);
}

/// Reaction time test result
@JsonSerializable()
class ReactionTimeResult {
  final List<int> reactionTimes; // in milliseconds
  final double averageTime;
  final double standardDeviation;
  final int correctResponses;
  final int totalAttempts;

  ReactionTimeResult({
    required this.reactionTimes,
    required this.averageTime,
    required this.standardDeviation,
    required this.correctResponses,
    required this.totalAttempts,
  });

  factory ReactionTimeResult.fromJson(Map<String, dynamic> json) =>
      _$ReactionTimeResultFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionTimeResultToJson(this);
}

/// Cognitive test result
@JsonSerializable()
class CognitiveResult {
  final int correctAnswers;
  final int totalQuestions;
  final double accuracy;
  final List<int> responseTimes; // in milliseconds
  final String testType; // e.g., "n-back", "memory"

  CognitiveResult({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.accuracy,
    required this.responseTimes,
    required this.testType,
  });

  factory CognitiveResult.fromJson(Map<String, dynamic> json) =>
      _$CognitiveResultFromJson(json);

  Map<String, dynamic> toJson() => _$CognitiveResultToJson(this);
}

/// Motor test result
@JsonSerializable()
class MotorResult {
  final List<Map<String, double>> touchPoints; // x, y coordinates
  final double precision;
  final double speed;
  final int duration; // in seconds
  final String testType; // e.g., "path-tracing", "tapping"

  MotorResult({
    required this.touchPoints,
    required this.precision,
    required this.speed,
    required this.duration,
    required this.testType,
  });

  factory MotorResult.fromJson(Map<String, dynamic> json) =>
      _$MotorResultFromJson(json);

  Map<String, dynamic> toJson() => _$MotorResultToJson(this);
}

/// Speech test result
@JsonSerializable()
class SpeechResult {
  final String audioFilePath;
  final int duration; // in seconds
  final Map<String, dynamic> features; // MFCCs, pitch, jitter, shimmer
  final double? qualityScore;

  SpeechResult({
    required this.audioFilePath,
    required this.duration,
    required this.features,
    this.qualityScore,
  });

  factory SpeechResult.fromJson(Map<String, dynamic> json) =>
      _$SpeechResultFromJson(json);

  Map<String, dynamic> toJson() => _$SpeechResultToJson(this);
}
