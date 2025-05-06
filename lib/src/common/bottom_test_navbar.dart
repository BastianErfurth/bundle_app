import 'package:flutter/material.dart';
import 'package:bundle_app/src/theme/palette.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: Palette.mediumGreenBlue,
        indicatorColor:
            Colors.white.withAlpha(20), // heller Hintergrund für aktiven Tab
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white);
          }
          return IconThemeData(color: Palette.buttonTextGreenBlue);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600);
          }
          return TextStyle(color: Palette.buttonTextGreenBlue);
        }),
      ),
      child: NavigationBar(
        height: 70,
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.euro), label: "Kosten"),
          NavigationDestination(
              icon: Icon(Icons.insert_drive_file), label: "Documents"),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: "Kalender"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
