import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class TemporaTextStyles {
  TemporaTextStyles._();

  // Brand display — Noto Serif, splash screen and city headers on error screen
  static TextStyle brandDisplay({Color color = TemporaColors.onSurface}) =>
      GoogleFonts.notoSerif(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.02 * 48,
        color: color,
      );

  // Data huge — massive temperature readout (64px, ultra-light)
  static TextStyle dataHuge({Color color = TemporaColors.onSurface}) =>
      GoogleFonts.manrope(
        fontSize: 64,
        fontWeight: FontWeight.w200,
        height: 1.0,
        letterSpacing: -0.04 * 64,
        color: color,
      );

  // Heading large — section titles, city name (24px, semibold)
  static TextStyle headingLg({Color color = TemporaColors.onSurface}) =>
      GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.02 * 24,
        color: color,
      );

  // Body medium — descriptions, subtitles (16px, regular)
  static TextStyle bodyMd({Color color = TemporaColors.onSurfaceVariant}) =>
      GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0,
        color: color,
      );

  // Label caps — metric labels, UPPERCASE (12px, bold, wide tracking)
  static TextStyle labelCaps({Color color = TemporaColors.onSurfaceVariant}) =>
      GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0.1 * 12,
        color: color,
      );

  // Data mono — secondary values, coordinates, times (14px, medium)
  static TextStyle dataMono({Color color = TemporaColors.onSurfaceVariant}) =>
      GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: 0.05 * 14,
        color: color,
      );

  // App bar title — "METAR_STATION" branding
  static TextStyle appBarTitle({Color color = TemporaColors.onSurface}) =>
      GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2 * 14,
        color: color,
      );
}
