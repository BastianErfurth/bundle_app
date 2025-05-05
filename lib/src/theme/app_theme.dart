import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Palette.mediumGreenBlue,
    ),
    scaffoldBackgroundColor: Palette.backgroundGreenBlue,
  ).copyWith(
    textTheme: ThemeData.light().textTheme.copyWith(
          displaySmall:
              TextStyle(color: Palette.textWhite, fontWeight: FontWeight.bold),
        ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Palette.mediumGreenBlue,
    ),
    scaffoldBackgroundColor: Palette.backgroundGreenBlue,
  ).copyWith(
    textTheme: ThemeData.dark().textTheme.copyWith(
          displaySmall: TextStyle(color: Palette.textWhite),
        ),
  );
}
