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
    textTheme: ThemeData.light()
        .textTheme
        .copyWith(
          titleLarge: ThemeData.light().textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Palette.textWhite,
              ),
        )
        .apply(
          bodyColor: Palette.textWhite,
          displayColor: Palette.textWhite,
        ),
    scaffoldBackgroundColor: Palette.backgroundGreenBlue,
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Palette.textWhite),
          foregroundColor: WidgetStatePropertyAll(Palette.darkGreenblue),
          shadowColor: WidgetStatePropertyAll(Palette.textWhite),
          elevation: WidgetStatePropertyAll(2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )),
    ),
  );

  static final darkTheme = ThemeData(
    iconTheme: IconThemeData(color: Palette.textWhite),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Palette.mediumGreenBlue,
    ),
  ).copyWith(
    textTheme: ThemeData.dark()
        .textTheme
        .copyWith(
          titleLarge: ThemeData.dark().textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Palette.textWhite,
              ),
        )
        .apply(
          bodyColor: Palette.textWhite,
          displayColor: Palette.textWhite,
        ),
    scaffoldBackgroundColor: Palette.backgroundGreenBlue,
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Palette.textWhite),
          foregroundColor: WidgetStatePropertyAll(Palette.darkGreenblue),
          shadowColor: WidgetStatePropertyAll(Palette.textWhite),
          elevation: WidgetStatePropertyAll(2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )),
    ),
  );
}
