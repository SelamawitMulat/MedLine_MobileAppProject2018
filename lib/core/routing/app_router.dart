import 'package:flutter/material.dart';

class AppColors {
  // --- PRIMARY BRAND COLORS ---
  // The main blue used for buttons, logos, and primary accents
  static const Color primaryBlue = Color(0xFF1A56BE);

  // A softer blue for icon backgrounds or secondary highlights
  static const Color accentBlue = Color(0xFFE8F0FE);

  // --- SECONDARY / STATUS COLORS ---
  // Used for the "Doctor" benefit cards or health icons
  static const Color heartBeatGreen = Color(0xFF4CAF50);

  // Potential colors for warnings or pending status
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFE53935);

  // --- NEUTRAL COLORS ---
  // The light grey background for the whole screen
  static const Color scaffoldBg = Color(0xFFF8F9FA);

  // For secondary text, hints, and subtitles
  static const Color textGrey = Color(0xFF6C757D);

  // --- TEXT COLORS (Handling both naming variations) ---
  // Pure dark text for headings and high-contrast elements
  static const Color darkText = Color(0xFF212529);
  static const Color textDark = Color(
    0xFF212529,
  ); // Added to fix feature_info_card.dart

  // White for cards and button text
  static const Color white = Colors.white;
}
