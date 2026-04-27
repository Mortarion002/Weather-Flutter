import 'package:flutter/material.dart';
import '../theme/colors.dart';

class WeatherBackground extends StatelessWidget {
  const WeatherBackground({super.key, required this.child, this.accentColor});

  final Widget child;
  final Color? accentColor;

  static const _defaultAccent = Color(0xFF4A6A8A);

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? _defaultAccent;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.7),
          radius: 1.2,
          colors: [accent.withAlpha(130), TemporaColors.black],
          stops: const [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}
