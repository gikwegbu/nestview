// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ──────────────────────── Heading Family (Bricolage Grotesque) ────────────────────────
  static TextStyle get displayLarge => GoogleFonts.bricolageGrotesque(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.1,
        letterSpacing: -1.0,
      );

  static TextStyle get displayMedium => GoogleFonts.bricolageGrotesque(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineLarge => GoogleFonts.bricolageGrotesque(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.bricolageGrotesque(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.bricolageGrotesque(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  // ──────────────────────── Price Displays ────────────────────────
  static TextStyle get priceDisplay => GoogleFonts.bricolageGrotesque(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.secondary,
        height: 1.1,
        letterSpacing: -0.5,
      );

  static TextStyle get priceCard => GoogleFonts.bricolageGrotesque(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        height: 1.2,
      );

  // ──────────────────────── Body Family (Nunito Sans via Google Fonts) ────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.55,
      );

  static TextStyle get bodySmall => GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodyMediumSecondary => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.55,
      );

  // ──────────────────────── Labels ────────────────────────
  static TextStyle get labelLarge => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.nunitoSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // ──────────────────────── Buttons ────────────────────────
  static TextStyle get buttonLarge => GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.3,
      );

  static TextStyle get buttonMedium => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.2,
      );

  // ──────────────────────── Navigation ────────────────────────
  static TextStyle get navLabel => GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  // ──────────────────────── Chips ────────────────────────
  static TextStyle get chip => GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  // ──────────────────────── Special ────────────────────────
  static TextStyle get badgePremium => GoogleFonts.bricolageGrotesque(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 0.5,
      );
}
