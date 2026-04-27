import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

// Full implementation in Phase 6
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemporaColors.black,
      body: Center(
        child: Text(
          'Settings — coming soon',
          style: TemporaTextStyles.bodyMd(),
        ),
      ),
    );
  }
}
