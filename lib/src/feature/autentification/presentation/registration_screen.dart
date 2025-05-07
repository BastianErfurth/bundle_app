import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_field_with_icon.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                "Nur kurz registrieren, dann gehts los...",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormFieldWithoutIcon(
                        labelText: "Username", hintText: "Username"),
                    TextFormFieldWithoutIcon(
                        labelText: "Email", hintText: "Email"),
                    TextFieldWithIcon(
                        labelText: "Passwort festlegen",
                        hintText: "Passwort festlegen",
                        iconButton: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: Icon(Icons.visibility_off)),
                        obscureText: _isObscured),
                    TextFieldWithIcon(
                        labelText: "Passwort wiederholen",
                        hintText: "Passwort wiederholen",
                        iconButton: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: Icon(Icons.visibility_off)),
                        obscureText: _isObscured),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {},
                        child: Text(
                          "Registrieren",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
