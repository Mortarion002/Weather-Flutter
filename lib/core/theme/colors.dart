import 'package:flutter/material.dart';

class TemporaColors {
  TemporaColors._();

  // Base canvas — absolute black for OLED
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFF131313);

  // Glass surface layers
  static const Color surface = Color(0xFF121212);
  static const Color surfaceContainer = Color(0xFF1F1F1F);
  static const Color surfaceContainerLow = Color(0xFF1B1B1B);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceVariant = Color(0xFF353535);
  static const Color surfaceBright = Color(0xFF393939);

  // Typography
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFCFC4C5);

  // Outline / borders
  static const Color outline = Color(0xFF988E90);
  static const Color outlineVariant = Color(0xFF4C4546);

  // Glass rim light — top/left edge highlight at ~15% white
  static const Color rimLight = Color(0x26FFFFFF);

  // Semantic accents
  static const Color amber = Color(0xFFFFBF00); // clear sky / solar / warm
  static const Color cyan = Color(0xFF00FFFF);  // rain / cold / moisture

  // Glow variants for box shadows
  static const Color amberGlow = Color(0x4DFFBF00);
  static const Color cyanGlow = Color(0x4D00FFFF);

  // Error palette
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Inverse surface (search button fill)
  static const Color inverseSurface = Color(0xFFE2E2E2);
  static const Color inverseOnSurface = Color(0xFF303030);
}
