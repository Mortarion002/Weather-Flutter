import 'package:flutter/material.dart';
import '../theme/colors.dart';

class WeatherBackground extends StatelessWidget {
  const WeatherBackground({super.key, required this.child, this.accentColor});

  final Widget child;
  final Color? accentColor;

  static const _defaultAccent = Color(0xFF213560);

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? _defaultAccent;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accent.withAlpha(80),
            TemporaColors.background,
            TemporaColors.black,
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: child,
    );
  }
}
