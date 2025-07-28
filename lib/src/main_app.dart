import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/login_screen.dart';
import 'package:bundle_app/src/feature/autentification/presentation/verification_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    context.watch<DatabaseRepository>();
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp(
          key: Key(
            (snapshot.data?.uid ?? "nor_user") +
                (snapshot.data?.emailVerified ?? false).toString(),
          ),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: _getScreen(snapshot.data),
        );
      },
    );
  }

  Widget _getScreen(User? currentUser) {
    if (currentUser == null) {
      return LogInScreen();
    } else {
      if (!currentUser.emailVerified) {
        return VerificationScreen();
      } else {
        return HomeScreen();
      }
    }
  }
}
