import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        width: 250,
        color: Palette.mediumGreenBlue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("Settings Screen Placeholder")),
        ),
      ),
    );
  }
}
