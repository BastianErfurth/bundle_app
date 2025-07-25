import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';
import 'package:bundle_app/src/feature/contracts/presentation/add_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_list_container.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_piechart.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/dropdown_select_field.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyContractsScreen extends StatefulWidget {
  const MyContractsScreen({super.key});

  @override
  State<MyContractsScreen> createState() => _MyContractsScreenState();
}

class _MyContractsScreenState extends State<MyContractsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<UserProfile> _userProfiles = [];
  UserProfile? _selectedUserProfile;
  ContractCategory? _selectedContractCategory;

  Future<List<Contract>>? _filteredContracts;

  @override
  void initState() {
    super.initState();
    _loadUserProfiles();
    _applyFilters(Provider.of<DatabaseRepository>(context, listen: false));
    _searchController.addListener(() {
      _applyFilters(Provider.of<DatabaseRepository>(context, listen: false));
    });
  }

  void _loadUserProfiles() async {
    final profiles = await Provider.of<DatabaseRepository>(
      context,
      listen: false,
    ).getUserProfiles();
    setState(() {
      _userProfiles = profiles;
    });
  }

  void _applyFilters(DatabaseRepository db) {
    setState(() {
      _filteredContracts = _getFilteredContracts(db);
    });
  }

  Future<List<Contract>> _getFilteredContracts(DatabaseRepository db) async {
    final allContracts = await db.getMyContracts();
    final searchText = _searchController.text.toLowerCase();

    return allContracts.where((contract) {
      final matchesUser =
          _selectedUserProfile == null ||
          contract.userProfile == _selectedUserProfile;
      final matchesCategory =
          _selectedContractCategory == null ||
          contract.category == _selectedContractCategory;

      final keyword = contract.keyword;

      final matchesSearch =
          searchText.isEmpty || keyword.toLowerCase().contains(searchText);

      return matchesUser && matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthRepository>();
    final db = context.watch<DatabaseRepository>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    label: Row(
                      children: [Icon(Icons.close), Text("Abbrechen")],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => AddContractScreen(),
                            ),
                          )
                          .then((result) {
                            if (result == true) {
                              _applyFilters(db);

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Vertrag erfolgreich gespeichert',
                                  ),
                                ),
                              );
                            }
                          });
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
              SizedBox(height: 8),

              DropDownSelectField<UserProfile?>(
                labelText: "Profil wählen",
                values: [null, ..._userProfiles],
                itemLabel: (profile) => profile == null
                    ? "Alle Profile"
                    : '${profile.firstName} ${profile.lastName}',
                selectedValue: _selectedUserProfile,
                onChanged: (UserProfile? newValue) {
                  setState(() {
                    _selectedUserProfile = newValue;
                    _applyFilters(db);
                  });
                },
              ),
              SizedBox(height: 4),

              TextFormFieldWithoutIcon(
                labelText: "Suchbegriff eingeben",
                hintText: "Stichwort",
                controller: _searchController,
                validator: (_) => null,
                autofillHints: [],
              ),
              SizedBox(height: 4),

              DropDownSelectField<ContractCategory?>(
                labelText: "Kategorie wählen",
                values: [null, ...ContractCategory.values],
                itemLabel: (category) =>
                    category == null ? "Alle Kategorien" : category.label,
                selectedValue: _selectedContractCategory,
                onChanged: (ContractCategory? newValue) {
                  setState(() {
                    _selectedContractCategory = newValue;
                    _applyFilters(db);
                  });
                },
              ),
              SizedBox(height: 16),

              FutureBuilder<List<Contract>>(
                future: _filteredContracts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: ContractPieChart(contracts: snapshot.data!),
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
                child: FutureBuilder<List<Contract>>(
                  future: _filteredContracts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Fehler: ${snapshot.error}"));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final contracts = snapshot.data!;
                      return ListView.builder(
                        itemCount: contracts.length,
                        itemBuilder: (context, index) {
                          final contract = contracts[index];
                          return Column(
                            children: [
                              ContractListContainer(
                                contract: contract,
                                db: db,
                                onDelete: () {
                                  _applyFilters(db);
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
}
