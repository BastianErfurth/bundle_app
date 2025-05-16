import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/login_screen.dart';
import 'package:bundle_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  final DatabaseRepository db;
  const MainApp(this.db, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: LogInScreen(db),
    );
  }
}
