// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/password_recovery_screen.dart';
import 'package:bundle_app/src/feature/autentification/presentation/registration_screen.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/language_service.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_field_with_icon.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();

  void _showAuthError(dynamic error) {
    String errorMessage = _getErrorMessage(error);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Palette.lightGreenBlue,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Kein Benutzer mit dieser Email gefunden';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Ungültige Email oder Passwort';
        case 'invalid-email':
          return 'Ungültige Email-Adresse';
        case 'user-disabled':
          return 'Dieser Account wurde deaktiviert';
        case 'too-many-requests':
          return 'Zu viele Anmeldeversuche. Versuche es später erneut';
        case 'network-request-failed':
          return 'Netzwerkfehler. Überprüfe deine Internetverbindung';
        default:
          return 'Unbekannter Fehler: ${error.message}';
      }
    }
    return 'Unbekannter Fehler ist aufgetreten';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    context.watch<DatabaseRepository>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.asset(
                    "assets/images/appicon.png",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text("Bundle", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 20),
              Text(
                "Willkommen !",
                style: Theme.of(
                  context,
                ).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Consumer<LanguageService>(
                    builder: (context, languageService, child) {
                      return MiniLanguageButton(
                        languageService: languageService,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormFieldWithoutIcon(
                          autofillHints: [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bitte gib eine Emailadresse ein";
                            } else if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            ).hasMatch(value)) {
                              return "Bitte gib eine gültige Emailadresse ein";
                            } else if (value.length < 5) {
                              return "Emailadresse muss mindestens 5 Zeichen lang sein";
                            } else if (value.length > 50) {
                              return "Emailadresse darf maximal 50 Zeichen lang sein";
                            }
                            return null;
                          },
                          labelText: "Email",
                          hintText: "Emailadresse eingeben",
                        ),
                        SizedBox(height: 24),
                        TextFieldWithIcon(
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bitte gib ein Passwort ein";
                            } else if (value.length < 6) {
                              return "Passwort muss mindestens 6 Zeichen lang sein";
                            } else if (value.length > 10) {
                              return "Passwort darf maximal 10 Zeichen lang sein";
                            } else if (value.contains(" ")) {
                              return "Passwort darf keine Leerzeichen enthalten";
                            } else
                              return null;
                          },

                          labelText: "Passwort",
                          hintText: "Passwort eingeben",
                          iconButton: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          obscureText: _isObscured,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PasswordRecoveryScreen(),
                                ),
                              );
                            },
                            child: Text("Passwort vergessen?"),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              try {
                                await auth.signInWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                                if (mounted) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                _showAuthError(e);
                              }
                            },

                            child: Text("Login"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                spacing: 16,
                children: [
                  Expanded(child: Divider(color: Palette.textWhite)),
                  Text("Oder mit"),
                  Expanded(child: Divider(color: Palette.textWhite)),
                ],
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton.icon(
                    onPressed: () {},
                    label: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.apple), Text("Login with Apple")],
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Image.asset("assets/images/google.png", height: 24),
                          Text("Login with Google"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text("Noch kein Konto?"),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      });
                    },
                    child: Text("Registrieren"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
