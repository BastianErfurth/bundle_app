import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final lightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Palette.mediumGreenBlue,
    ),
  );

  static final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark, seedColor: Palette.mediumGreenBlue),
  );
}
