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
              ),
              label: "Home"),
          NavigationDestination(
              icon: Icon(
                Icons.attach_file,
              ),
              label: "Kosten"),
          NavigationDestination(
              icon: Icon(
                Icons.euro,
              ),
              label: "Verträge"),
          NavigationDestination(
              icon: Icon(
                Icons.calendar_month_rounded,
              ),
              label: "Kalender"),
          NavigationDestination(
              icon: Icon(
                Icons.settings,
                size: 28,
              ),
              label: "Settings"),
        ],
      ),
    );
  }
}
