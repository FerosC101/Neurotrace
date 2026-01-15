import 'package:json_annotation/json_annotation.dart';

part 'survey.g.dart';

/// Survey question model
@JsonSerializable()
class SurveyQuestion {
  final String id;
  final String question;
  final QuestionType type;
  final List<String>? options;
  final bool required;

  SurveyQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    this.required = true,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyQuestionToJson(this);
}

/// Survey response model
@JsonSerializable()
class SurveyResponse {
  final String userId;
  final DateTime timestamp;
  final Map<String, dynamic> responses;
  final double? microplasticExposureIndex;

  SurveyResponse({
    required this.userId,
    required this.timestamp,
    required this.responses,
    this.microplasticExposureIndex,
  });

  factory SurveyResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyResponseToJson(this);
}

/// Question type enum
@JsonEnum()
enum QuestionType {
  @JsonValue('multiple_choice')
  multipleChoice,
  @JsonValue('single_choice')
  singleChoice,
  @JsonValue('text')
  text,
  @JsonValue('number')
  number,
  @JsonValue('scale')
  scale,
}
