import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: NavigationBar(
        backgroundColor: Palette.mediumGreenBlue,
        onDestinationSelected: (value) {},
        destinations: [
          NavigationDestination(
              icon: Icon(
                Icons.home,
                color: Palette.buttonTextGreenBlue,
              ),
              label: "Home"),
          NavigationDestination(
              icon: Icon(
                Icons.attach_file,
                color: Palette.buttonTextGreenBlue,
              ),
              label: "Kosten"),
          NavigationDestination(
              icon: Icon(
                Icons.euro,
                color: Palette.buttonTextGreenBlue,
              ),
              label: "Verträge"),
          NavigationDestination(
              icon: Icon(
                Icons.calendar_month_rounded,
                color: Palette.buttonTextGreenBlue,
              ),
              label: "Kalender"),
          NavigationDestination(
              icon: Icon(
                Icons.settings,
                color: Palette.buttonTextGreenBlue,
              ),
              label: "Settings"),
        ],
      ),
    );
  }
}
