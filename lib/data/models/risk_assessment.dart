import 'package:json_annotation/json_annotation.dart';

part 'risk_assessment.g.dart';

/// Risk assessment model
@JsonSerializable()
class RiskAssessment {
  final String id;
  final String userId;
  final double riskScore; // 0-100
  final RiskLevel riskLevel;
  final DateTime assessmentDate;
  final Map<String, double> categoryScores; // Cognitive, motor, speech, etc.
  final List<String> recommendations;
  final Map<String, dynamic>? detailedAnalysis;

  RiskAssessment({
    required this.id,
    required this.userId,
    required this.riskScore,
    required this.riskLevel,
    required this.assessmentDate,
    required this.categoryScores,
    required this.recommendations,
    this.detailedAnalysis,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) =>
      _$RiskAssessmentFromJson(json);

  Map<String, dynamic> toJson() => _$RiskAssessmentToJson(this);
}

/// Risk level enum
@JsonEnum()
enum RiskLevel {
  @JsonValue('low')
  low,
  @JsonValue('moderate')
  moderate,
  @JsonValue('high')
  high,
}

extension RiskLevelExtension on RiskLevel {
  String get displayName {
    switch (this) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.moderate:
        return 'Moderate Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }

  String get description {
    switch (this) {
      case RiskLevel.low:
        return 'Your results indicate minimal neurological risk';
      case RiskLevel.moderate:
        return 'Your results show some indicators that warrant monitoring';
      case RiskLevel.high:
        return 'Your results suggest elevated risk - consider consulting a healthcare professional';
    }
  }
}
