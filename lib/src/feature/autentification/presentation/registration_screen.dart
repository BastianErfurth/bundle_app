// ignore_for_file: use_build_context_synchronously

import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/login_screen.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_field_with_icon.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    context.watch<DatabaseRepository>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: AutofillGroup(
              child: Column(
                spacing: 8,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.asset(
                        "assets/images/appicon.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Bundle",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nur kurz registrieren, dann gehts los...",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),

                  TextFormFieldWithoutIcon(
                    autofillHints: [AutofillHints.username],
                    keyboardType: TextInputType.text,
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bitte gib einen Benutzernamen ein";
                      } else if (value.length < 3) {
                        return "Der Benutzername muss mindestens 3 Zeichen lang sein";
                      } else if (value.length > 20) {
                        return "Der Benutzername darf maximal 20 Zeichen lang sein";
                      } else if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value)) {
                        return "Der Benutzername darf nur Buchstaben, Zahlen und Unterstriche enthalten";
                      } else
                        // ignore: curly_braces_in_flow_control_structures
                        return null;
                    },
                    labelText: "Username",
                    hintText: "Username",
                  ),
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
                    hintText: "Email",
                  ),
                  TextFieldWithIcon(
                    autofillHints: [AutofillHints.password],
                    keyboardType: TextInputType.visiblePassword,
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
                      }
                      return null;
                    },
                    labelText: "Passwort festlegen",
                    hintText: "Passwort festlegen",
                    iconButton: IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    obscureText: _isObscured,
                  ),
                  TextFieldWithIcon(
                    autofillHints: [AutofillHints.newPassword],
                    keyboardType: TextInputType.visiblePassword,
                    controller: _repeatPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bitte wiederhole das Passwort";
                      } else if (value != _passwordController.text) {
                        return "Die Passwörter stimmen nicht überein";
                      }
                      return null;
                    },
                    labelText: "Passwort wiederholen",
                    hintText: "Passwort wiederholen",
                    iconButton: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    obscureText: _isObscured,
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        try {
                          // Registrierung (User wird direkt angemeldet)
                          await auth.createUserWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );

                          // Aktuellen User holen
                          final user = FirebaseAuth.instance.currentUser;

                          if (user != null && !user.emailVerified) {
                            // Verifikationsmail senden
                            await user.sendEmailVerification();

                            // Snackbar mit Hinweis
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Bitte bestätige deine E-Mail-Adresse. "
                                  "Ein Link wurde an ${_emailController.text.trim()} gesendet.",
                                ),
                              ),
                            );

                            // User ausloggen, damit er sich nach Verifikation neu einloggen muss
                            await auth.signOut();

                            if (mounted) {
                              // Navigation zum LoginScreen oder einem VerificationScreen
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => LogInScreen(),
                                ),
                              );
                            }
                          } else {
                            // Falls User schon verifiziert ist (sehr unwahrscheinlich hier)
                            if (mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => LogInScreen(),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Registrierung fehlgeschlagen: ${e.toString()}",
                              ),
                            ),
                          );
                        }
                      },

                      child: Text("Registrieren"),
                    ),
                  ),

                  Row(
                    spacing: 16,
                    children: [
                      Expanded(child: Divider(color: Palette.textWhite)),
                      Text("Oder mit"),
                      Expanded(child: Divider(color: Palette.textWhite)),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
                        label: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.apple),
                              Text("Login with Apple"),
                            ],
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
                              Image.asset(
                                "assets/images/google.png",
                                height: 24,
                              ),
                              Text("Login with Google"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text("Du bist bereits registriert?"),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text("Login jetzt"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }
}
