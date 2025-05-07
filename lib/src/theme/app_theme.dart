import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final lightTheme = ThemeData(
    iconTheme: IconThemeData(color: Palette.textWhite),
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Palette.mediumGreenBlue,
    ),
  ).copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Palette.textWhite,
          displayColor: Palette.textWhite,
        ),
    scaffoldBackgroundColor: Palette.backgroundGreenBlue,
  );

  static final darkTheme = ThemeData(
    iconTheme: IconThemeData(color: Palette.textWhite),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Palette.mediumGreenBlue,
    ),
  ).copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Palette.textWhite,
          displayColor: Palette.textWhite,
        ),
    scaffoldBackgroundColor: Palette.backgroundGreenBlue,
  );
}
