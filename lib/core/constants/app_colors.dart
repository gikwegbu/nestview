// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF1A1A2E);
  static const Color secondary = Color(0xFFE94560);
  static const Color accent = Color(0xFFF5A623);

  // Background
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE94560);
  static const Color info = Color(0xFF3B82F6);

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Card Shadow
  static const Color cardShadow = Color(0x14000000); // rgba(0,0,0,0.08)

  // LTV color coding
  static const Color ltvGood = Color(0xFF27AE60);    // < 60%
  static const Color ltvMedium = Color(0xFFF5A623);  // 60–80%
  static const Color ltvHigh = Color(0xFFE94560);    // > 80%

  // Property types
  static const Color detached = Color(0xFF3B82F6);
  static const Color semiDetached = Color(0xFF8B5CF6);
  static const Color terraced = Color(0xFF10B981);
  static const Color flat = Color(0xFFF59E0B);
  static const Color bungalow = Color(0xFFEF4444);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A2E), Color(0xFF2D2D5E)],
  );

  static const LinearGradient cardImageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE94560), Color(0xFFFF6B85)],
  );
}
