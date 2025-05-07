import 'package:bundle_app/src/common/app_navigation_bar.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppNavigationBar(),
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
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Palette.lightGreenBlue,
                          Palette.darkGreenblue
                        ]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Palette.textWhite),
                          hintText: "Email eingeben",
                          hintStyle: TextStyle(color: Palette.textWhite),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Palette.lightGreenBlue,
                          Palette.darkGreenblue
                        ]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                              icon: Icon(_isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          labelText: "Passwort",
                          labelStyle: TextStyle(color: Palette.textWhite),
                          hintText: "Passwort eingeben",
                          hintStyle: TextStyle(color: Palette.textWhite),
                          suffixIconColor: Palette.textWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        obscureText: _isObscured,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Passwort vergessen?",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {},
                        child: Text(
                          "Login",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                      child: Divider(
                    color: Palette.textWhite,
                  )),
                  Text("Oder mit"),
                  Expanded(
                      child: Divider(
                    color: Palette.textWhite,
                  )),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton.icon(
                      onPressed: () {},
                      label: Center(
                        child: Row(children: [
                          Icon(Icons.apple),
                          //Text("Login with Apple")
                        ]),
                      )),
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
                      )),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text("Noch kein Konto?"),
                  TextButton(
                    onPressed: () {},
                    child: Text("Registrieren"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
