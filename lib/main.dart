import 'package:bundle_app/firebase_options.dart';
import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/data/firebase_auth_repository.dart';
import 'package:bundle_app/src/data/firebase_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/language_service.dart';
import 'package:bundle_app/src/main_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AuthRepository auth = FirebaseAuthRepository();
  final DatabaseRepository db = FirebaseRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => auth),
        Provider<DatabaseRepository>(create: (_) => db),
        ChangeNotifierProvider(
          create: (_) => LanguageService()..loadSavedLanguage(),
        ),
      ],
      child: MainApp(),
    ),
  );
}
