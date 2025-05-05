import 'package:bundle_app/src/common/app_navigation_bar.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Palette.backgroundGreenBlue,
      bottomNavigationBar: AppNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  "assets/images/appicon.png",
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Willkommen !",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
