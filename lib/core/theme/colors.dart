import 'package:flutter/material.dart';

class TemporaColors {
  TemporaColors._();

  // Deep navy base
  static const Color black = Color(0xFF0F1829);
  static const Color background = Color(0xFF1A2744);

  // Navy surface layers
  static const Color surface = Color(0xFF1D2E52);
  static const Color surfaceContainer = Color(0xFF213560);
  static const Color surfaceContainerLow = Color(0xFF172040);
  static const Color surfaceContainerHigh = Color(0xFF273D6E);
  static const Color surfaceVariant = Color(0xFF2D4578);
  static const Color surfaceBright = Color(0xFF344D85);

  // Typography
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFF8AAEC4);

  // Outline / borders
  static const Color outline = Color(0xFF2A3E6A);
  static const Color outlineVariant = Color(0xFF1D2E52);

  // Rim light — very subtle on navy
  static const Color rimLight = Color(0x14FFFFFF);

  // Semantic accents
  static const Color amber = Color(0xFFFFBF00);   // clear sky / solar / warm
  static const Color cyan = Color(0xFF4DD0E1);    // rain / cold / moisture

  // Glow variants for box shadows
  static const Color amberGlow = Color(0x4DFFBF00);
  static const Color cyanGlow = Color(0x4D4DD0E1);

  // AQI / air quality accent
  static const Color aqiGreen = Color(0xFF4CAF50);

  // Primary blue — nav active state, selected elements
  static const Color primaryBlue = Color(0xFF5BB5FF);
  static const Color primaryBlueGlow = Color(0x4D5BB5FF);

  // Error palette
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Inverse surface (search button fill)
  static const Color inverseSurface = Color(0xFFE2E2E2);
  static const Color inverseOnSurface = Color(0xFF303030);
}
