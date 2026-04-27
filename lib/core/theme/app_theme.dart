import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: TemporaColors.black,
        colorScheme: const ColorScheme.dark(
          surface: TemporaColors.background,
          onSurface: TemporaColors.onSurface,
          surfaceContainerHighest: TemporaColors.surfaceVariant,
          primary: TemporaColors.onSurface,
          onPrimary: TemporaColors.inverseOnSurface,
          error: TemporaColors.error,
          errorContainer: TemporaColors.errorContainer,
          onError: TemporaColors.onError,
          onErrorContainer: TemporaColors.onErrorContainer,
          outline: TemporaColors.outline,
          outlineVariant: TemporaColors.outlineVariant,
        ),
        textTheme: TextTheme(
          displayLarge: TemporaTextStyles.brandDisplay(),
          titleLarge: TemporaTextStyles.headingLg(),
          bodyMedium: TemporaTextStyles.bodyMd(),
          labelSmall: TemporaTextStyles.labelCaps(),
          bodySmall: TemporaTextStyles.dataMono(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
          ),
          titleTextStyle: TemporaTextStyles.appBarTitle(),
          iconTheme: const IconThemeData(color: TemporaColors.onSurface),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          contentTextStyle: TemporaTextStyles.bodyMd(),
        ),
        dividerColor: TemporaColors.outlineVariant,
        splashColor: Colors.white.withAlpha(10),
        highlightColor: Colors.white.withAlpha(6),
      );
}
