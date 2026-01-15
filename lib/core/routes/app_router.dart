import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/tests/reaction_time/reaction_time_screen.dart';
import '../../presentation/screens/tests/cognitive/cognitive_test_screen.dart';
import '../../presentation/screens/tests/motor/motor_test_screen.dart';
import '../../presentation/screens/tests/speech/speech_test_screen.dart';
import '../../presentation/screens/survey/survey_screen.dart';
import '../../presentation/screens/results/results_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';

/// Application routing configuration
class AppRouter {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String reactionTime = '/tests/reaction-time';
  static const String cognitive = '/tests/cognitive';
  static const String motor = '/tests/motor';
  static const String speech = '/tests/speech';
  static const String survey = '/survey';
  static const String results = '/results';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: reactionTime,
        builder: (context, state) => const ReactionTimeScreen(),
      ),
      GoRoute(
        path: cognitive,
        builder: (context, state) => const CognitiveTestScreen(),
      ),
      GoRoute(
        path: motor,
        builder: (context, state) => const MotorTestScreen(),
      ),
      GoRoute(
        path: speech,
        builder: (context, state) => const SpeechTestScreen(),
      ),
      GoRoute(
        path: survey,
        builder: (context, state) => const SurveyScreen(),
      ),
      GoRoute(
        path: results,
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
