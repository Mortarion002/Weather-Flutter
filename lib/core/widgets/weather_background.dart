import 'package:flutter/material.dart';
import '../theme/colors.dart';

class WeatherBackground extends StatelessWidget {
  const WeatherBackground({super.key, required this.child, this.accentColor});

  final Widget child;
  final Color? accentColor;

  static const _defaultAccent = Color(0xFF1A2C4A);

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? _defaultAccent;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.65),
          radius: 1.4,
          colors: [accent.withAlpha(90), TemporaColors.black],
        ),
      ),
      child: child,
    );
  }
}
