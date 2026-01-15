/// API endpoint constants
class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  
  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  
  // Tests
  static const String submitReactionTime = '/tests/reaction-time';
  static const String submitCognitive = '/tests/cognitive';
  static const String submitMotor = '/tests/motor';
  static const String submitSpeech = '/tests/speech';
  
  // Survey
  static const String submitSurvey = '/survey/submit';
  static const String getSurveyQuestions = '/survey/questions';
  
  // Results
  static const String getRiskScore = '/results/risk-score';
  static const String getTestHistory = '/results/history';
  static const String getDetailedAnalysis = '/results/analysis';
  
  // Feature Extraction
  static const String extractFeatures = '/features/extract';
  
  // ML Prediction
  static const String predictRisk = '/ml/predict';
}
