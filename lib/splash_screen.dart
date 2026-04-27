import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'core/theme/colors.dart';
import 'core/theme/text_styles.dart';
import 'app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _iconFade;
  late final Animation<double> _iconScale;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _iconFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _iconScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _titleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
    );
    _taglineFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const AppShell(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemporaColors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Amber weather icon with glow + scale
            FadeTransition(
              opacity: _iconFade,
              child: ScaleTransition(
                scale: _iconScale,
                child: Icon(
                  Symbols.partly_cloudy_day,
                  size: 80,
                  color: TemporaColors.amber,
                  weight: 200,
                  fill: 0,
                  shadows: const [
                    Shadow(color: TemporaColors.amberGlow, blurRadius: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // App name in Noto Serif
            FadeTransition(
              opacity: _titleFade,
              child: Text(
                'ZEPHYR',
                style: TemporaTextStyles.brandDisplay(),
              ),
            ),
            const SizedBox(height: 10),

            // Tagline
            FadeTransition(
              opacity: _taglineFade,
              child: Text(
                'weather in the moment',
                style: TemporaTextStyles.bodyMd(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
