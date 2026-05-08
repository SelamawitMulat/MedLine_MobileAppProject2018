import 'package:flutter/material.dart';

class AppColors {
  // --- BRAND COLORS ---
  static const Color primaryBlue = Color(0xFF1A56BE);
  static const Color accentBlue = Color(0xFFE8F0FE);

  // --- WIDGET SPECIFIC (Fixes the Red Lines) ---
  static const Color cardWhite = Colors.white; // Fixes RoleBenefitCard
  static const Color white = Colors.white; // General use
  static const Color successGreen = Color(
    0xFF4CAF50,
  ); // Fixes RoleBenefitCard checkmarks
  static const Color heartBeatGreen = Color(0xFF4CAF50); // For Doctor cards

  // --- BACKGROUND & NEUTRALS ---
  static const Color scaffoldBg = Color(0xFFF8F9FA);
  static const Color textGrey = Color(0xFF6C757D);

  // --- TEXT VARIATIONS ---
  static const Color darkText = Color(0xFF212529);
  static const Color textDark = Color(0xFF212529); // Fixes FeatureInfoCard
}
