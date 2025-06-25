import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/registration_screen.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_field_with_icon.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  final DatabaseRepository db;
  const LogInScreen(this.db, {super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormFieldWithoutIcon(
                        autofillHints: const [AutofillHints.email],
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
                          } else if (value.length < 8) {
                            return "Passwort muss mindestens 6 Zeichen lang sein";
                          } else if (value.length > 50) {
                            return "Passwort darf maximal 50 Zeichen lang sein";
                          } else if (!RegExp(
                            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$",
                          ).hasMatch(value)) {
                            return "Passwort muss mindestens 8 Zeichen lang sein und mindestens einen Großbuchstaben, einen Kleinbuchstaben und eine Zahl enthalten";
                          } else if (value.contains(" ")) {
                            return "Passwort darf keine Leerzeichen enthalten";
                          }
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
                          onPressed: () {},
                          child: Text("Passwort vergessen?"),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(widget.db),
                              ),
                            );
                          },
                          child: Text("Login"),
                        ),
                      ),
                    ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton.icon(
                    onPressed: () {},
                    label: Center(
                      child: Row(
                        children: [
                          Icon(Icons.apple),
                          //Text("Login with Apple")
                        ],
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: Center(
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.facebook),
                          //Text("Login with Facebook")
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
                            builder: (context) => RegistrationScreen(widget.db),
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
