import 'package:bundle_app/src/common/app_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyContractsScreen extends StatelessWidget {
  const MyContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                FilledButton.icon(
                    onPressed: () {},
                    label: Row(
                      children: [
                        Icon(Icons.close),
                        Text("Abbrechen"),
                      ],
                    )),
                FilledButton.icon(
                    onPressed: () {},
                    label: Row(
                      children: [
                        Icon(Icons.close),
                        Text("Hinzufügen"),
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
