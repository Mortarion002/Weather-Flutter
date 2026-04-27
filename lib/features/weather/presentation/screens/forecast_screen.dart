import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

// Full implementation in Phase 4
class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemporaColors.black,
      body: Center(
        child: Text(
          'Forecast — coming in Phase 4',
          style: TemporaTextStyles.bodyMd(),
        ),
      ),
    );
  }
}
