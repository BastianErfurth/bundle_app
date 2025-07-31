import 'package:bundle_app/src/common/bottom_navbar.dart';
import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/calender/presentation/calender_test_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_content.dart';
import 'package:bundle_app/src/feature/contracts/presentation/my_contracts_screen.dart';
import 'package:bundle_app/src/feature/costs/presentation/cost_screen.dart';
import 'package:bundle_app/src/feature/settings/presentation/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  late List<Widget> myScreens;

  @override
  void initState() {
    super.initState();
    myScreens = [
      HomeContent(),
      //CostScreenTest(widget.db, widget.auth),
      CostScreen(),
      //CostTestScreen(widget.db, widget.auth),
      MyContractsScreen(),
      CalenderTestScreen(),
      SettingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthRepository>();
    context.watch<DatabaseRepository>();
    return Scaffold(
      //appBar: AppBar(backgroundColor: Palette.backgroundGreenBlue),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: AppBottomNavigationBar(
          selectedIndex: _pageIndex,
          onItemSelected: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
        ),
      ),
      body: SafeArea(child: myScreens[_pageIndex]),
    );
  }
}
