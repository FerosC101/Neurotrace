/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'NeuroTrace AI';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.neurotrace.ai'; // Update with your backend URL
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Test Configuration
  static const int reactionTimeTestCount = 10;
  static const int cognitiveTestRounds = 5;
  static const int motorTestDuration = 60; // seconds
  static const int speechRecordingDuration = 30; // seconds
  
  // Storage Keys
  static const String userIdKey = 'user_id';
  static const String tokenKey = 'auth_token';
  static const String hasCompletedOnboardingKey = 'has_completed_onboarding';
  
  // Risk Score Thresholds
  static const double lowRiskThreshold = 33.0;
  static const double moderateRiskThreshold = 66.0;
  static const double highRiskThreshold = 100.0;
  
  // Audio Settings
  static const int audioSampleRate = 16000; // 16 kHz
  static const int audioBitDepth = 16;
  
  // Pagination
  static const int defaultPageSize = 20;
}
