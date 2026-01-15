import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42CC);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF00D9B5);
  static const Color secondaryLight = Color(0xFF4DFFE8);
  static const Color secondaryDark = Color(0xFF00A68A);
  
  // Neutral Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFFADB5BD);
  
  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Risk Level Colors
  static const Color lowRisk = Color(0xFF28A745);
  static const Color moderateRisk = Color(0xFFFFC107);
  static const Color highRisk = Color(0xFFDC3545);
  
  // Test Type Colors
  static const Color reactionTime = Color(0xFF6C63FF);
  static const Color cognitive = Color(0xFF00D9B5);
  static const Color motor = Color(0xFFFF6B9D);
  static const Color speech = Color(0xFFFFA94D);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
