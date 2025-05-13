import 'package:bundle_app/src/feature/calender/presentation/calender_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_content.dart';
import 'package:bundle_app/src/feature/contracts/presentation/my_contracts_screen.dart';
import 'package:bundle_app/src/feature/costs/presentation/cost_screen.dart';
import 'package:bundle_app/src/feature/settings/presentation/setting_screen.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  List<Widget> myScreens = [
    HomeContent(),
    CostScreen(),
    MyContractsScreen(),
    CalenderScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: NavigationBar(
          backgroundColor: Palette.mediumGreenBlue,
          onDestinationSelected: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          destinations: [
            NavigationDestination(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            NavigationDestination(
                icon: Icon(
                  Icons.euro_outlined,
                ),
                label: "Kosten"),
            NavigationDestination(
                icon: Icon(
                  Icons.description_outlined,
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
      ),
      body: SafeArea(
        child: myScreens[_pageIndex],
      ),
    );
  }
}
