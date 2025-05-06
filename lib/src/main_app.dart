import 'package:bundle_app/src/feature/autentification/presentation/login_scree.dart';
import 'package:bundle_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const LogInScreen(),
    );
  }
}
