import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';
import 'package:bundle_app/src/feature/contracts/presentation/add_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_list_container.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/dropdown_select_field.dart';
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
  ContractCategory? _selectedContractCategory;

  List<UserProfile> _userProfiles = [];
  UserProfile? _selectedUserProfile;

  @override
  void initState() {
    super.initState();
    _myContracts = widget.db.getMyContracts();
    widget.db.getUserProfiles().then((profiles) {
      setState(() {
        _userProfiles = profiles;
        if (_userProfiles.isNotEmpty) {
          _selectedUserProfile = _userProfiles.first;
        }
      });
    });
  }

  List<PieChartSectionData> _buildPieChartSections(List<Contract> contracts) {
    final Map<ContractCategory, int> categoryCounts = {};
    for (var contract in contracts) {
      categoryCounts[contract.category] =
          (categoryCounts[contract.category] ?? 0) + 1;
    }

    final total = categoryCounts.values.fold(0, (a, b) => a + b);
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.brown,
    ];

    int colorIndex = 0;
    return categoryCounts.entries.map((entry) {
      final category = entry.key;
      final count = entry.value;
      final percentage = (count / total) * 100;
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        value: count.toDouble(),
        title: '${category.label}\n${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 40,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                    label: Row(children: [Icon(Icons.add), Text("Hinzufügen")]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TopicHeadline(
                topicIcon: Icon(Icons.description),
                topicText: "Meine Verträge",
              ),
              FutureBuilder<List<UserProfile>>(
                future: widget.db.getUserProfiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Fehler: \${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    final profiles = snapshot.data ?? [];
                    return DropDownSelectField<UserProfile>(
                      labelText: "Profil wählen",
                      values: profiles,
                      itemLabel: (UserProfile profile) =>
                          '${profile.firstName} ${profile.lastName}',
                      selectedValue: _selectedUserProfile,
                      onChanged: (UserProfile? newValue) {
                        setState(() {
                          _selectedUserProfile = newValue;
                        });
                      },
                    );
                  } else {
                    return Center(child: Text("Keine Profile gefunden"));
                  }
                },
              ),
              SizedBox(height: 4),
              TextFormFieldWithoutIcon(
                labelText: "Suchbegriff eingeben",
                hintText: "Stichwort",
                controller: _searchController,
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: 4),
              DropDownSelectField<ContractCategory?>(
                labelText: "Kategorie wählen",
                values: [null, ...ContractCategory.values],
                itemLabel: (ContractCategory? category) =>
                    category == null ? "Alle Kategorien" : category.label,
                selectedValue: _selectedContractCategory,
                onChanged: (ContractCategory? newValue) {
                  setState(() {
                    _selectedContractCategory = newValue;
                  });
                },
              ),
              SizedBox(height: 16),
              FutureBuilder<List<Contract>>(
                future: _myContracts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final contracts = snapshot.data!;
                    final pieSections = _buildPieChartSections(contracts);
                    return Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: PieChart(
                            PieChartData(
                              sections: pieSections,
                              sectionsSpace: 2,
                              centerSpaceRadius: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: _myContracts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Fehler:\${snapshot.error.toString()}"),
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
                                ContractListContainer(
                                  contract: contract,
                                  db: widget.db,
                                  onDelete: () {
                                    setState(() {
                                      _myContracts = widget.db.getMyContracts();
                                    });
                                  },
                                ),
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
                    children: [
                      Icon(Icons.send_rounded),
                      SizedBox(width: 4),
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
