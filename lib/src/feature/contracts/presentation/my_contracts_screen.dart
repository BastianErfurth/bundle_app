import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/presentation/add_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_list_container.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyContractsScreen extends StatefulWidget {
  final DatabaseRepository db;
  const MyContractsScreen(this.db, {super.key});

  @override
  State<MyContractsScreen> createState() => _MyContractsScreenState();
}

class _MyContractsScreenState extends State<MyContractsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Contract>>? _myContracts;
  @override
  void initState() {
    super.initState();
    _myContracts = widget.db.getMyContracts();
  }

  @override
  Widget build(BuildContext context) {
    //List<Contract> contracts = widget.db.getMyContracts();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(widget.db),
                        ),
                      );
                    },
                    label: Row(
                      children: [Icon(Icons.close), Text("Abbrechen")],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddContractScreen(widget.db),
                        ),
                      );
                    },
                    label: Row(
                      children: [Icon(Icons.close), Text("Hinzufügen")],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TopicHeadline(
                topicIcon: Icon(Icons.description),
                topicText: "Meine Verträge",
              ),
              ContractAttributes(
                textTopic: "Meine Profile",
                iconButton: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.expand_more),
                ),
              ),
              SizedBox(height: 4),
              TextFormFieldWithoutIcon(
                controller: _searchController,
                labelText: "Suchbegriff eingeben",
                hintText: "Suchbegriff eingeben",
              ),
              SizedBox(height: 16),
              ContractAttributes(
                textTopic: "Alle Verträge",
                iconButton: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.expand_more),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: 1),
                      //PieChartSectionData(value: 20),
                      //PieChartSectionData(value: 20),
                      //PieChartSectionData(value: 20),
                      //PieChartSectionData(value: 20),
                      //PieChartSectionData(value: 20),
                      //PieChartSectionData(value: 20),
                    ],
                  ),
                  duration: Duration(milliseconds: 150),
                  curve: Curves.linear,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future: _myContracts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Fehler:${snapshot.error.toString()}"),
                        );
                      } else if (snapshot.hasData) {
                        List<Contract> contracts = snapshot.data ?? [];
                        if (contracts.isEmpty) {
                          return Center(child: Text("Keine Verträge gefunden"));
                        }
                        return ListView.builder(
                          itemCount: contracts.length,
                          itemBuilder: (context, index) {
                            final contract = contracts[index];
                            return Column(
                              children: [
                                ContractListContainer(contract: contract),
                                SizedBox(height: 4),
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(child: Text("Keine Verträge gefunden"));
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Icon(Icons.send_rounded),
                      Text("Vertragsübersicht versenden"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
