// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:flutter/material.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/data/database_repository.dart';

class NewSettingScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;

  const NewSettingScreen({super.key, required this.databaseRepository});

  @override
  State<NewSettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<NewSettingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<UserProfile> _userProfiles = [];
  List<ContractPartnerProfile> _contractPartnerProfiles = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final users = await widget.databaseRepository.getUserProfiles();
    final partners = await widget.databaseRepository.getContractors();
    setState(() {
      _userProfiles = users;
      _contractPartnerProfiles = partners;
      _loading = false;
    });
  }

  Future<void> _addUserProfile(UserProfile profile) async {
    await widget.databaseRepository.addUserProfile(profile);
    await _loadData();
  }

  Future<void> _addContractPartnerProfile(
    ContractPartnerProfile profile,
  ) async {
    await widget.databaseRepository.addContractPartnerProfile(profile);
    await _loadData();
  }

  Future<void> _deleteUserProfile(UserProfile profile) async {
    await widget.databaseRepository.deleteUserProfile(profile);
    await _loadData();
  }

  Future<void> _deleteContractPartnerProfile(
    ContractPartnerProfile profile,
  ) async {
    await widget.databaseRepository.deleteContractPartnerProfile(profile);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Einstellungen"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Benutzerprofile"),
            Tab(text: "Vertragspartner"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUserProfilesTab(), _buildContractPartnerProfilesTab()],
      ),
    );
  }

  Widget _buildUserProfilesTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _userProfiles.length,
            itemBuilder: (context, index) {
              final profile = _userProfiles[index];
              return ListTile(
                title: Text("${profile.firstName} ${profile.lastName}"),
                subtitle: Text(
                  "${profile.street} ${profile.houseNumber}, ${profile.zipCode} ${profile.city}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUserProfile(profile),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Neues Benutzerprofil anlegen"),
            onPressed: _showUserProfileDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildContractPartnerProfilesTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _contractPartnerProfiles.length,
            itemBuilder: (context, index) {
              final partner = _contractPartnerProfiles[index];
              return ListTile(
                title: Text(partner.companyName),
                subtitle: Text(
                  "${partner.street} ${partner.houseNumber}, ${partner.zipCode} ${partner.city}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteContractPartnerProfile(partner),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Neuer Vertragspartner"),
            onPressed: () => _showContractPartnerProfileDialog(context),
          ),
        ),
      ],
    );
  }

  void _showUserProfileDialog() {
    final formKey = GlobalKey<FormState>();

    bool isPrivate = false;

    final TextEditingController _firstNameController = TextEditingController();
    final TextEditingController _lastNameController = TextEditingController();
    final TextEditingController _streetController = TextEditingController();
    final TextEditingController _houseNumberController =
        TextEditingController();
    final TextEditingController _zipCodeController = TextEditingController();
    final TextEditingController _cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Benutzerprofil hinzufügen"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormFieldWithoutIcon(
                    labelText: "Vorname",
                    hintText: "Vorname eingeben",
                    controller: _firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Vorname eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Nachname",
                    hintText: "Nachname eingeben",
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Nachname eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Straße",
                    hintText: "Straße eingeben",
                    controller: _streetController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Straße eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Hausnummer",
                    hintText: "Hausnummer eingeben",
                    controller: _houseNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Hausnummer eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "PLZ",
                    hintText: "PLZ eingeben",
                    controller: _zipCodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte PLZ eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Stadt",
                    hintText: "Stadt eingeben",
                    controller: _cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Stadt eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  SwitchListTile(
                    title: const Text("Profil privat"),
                    value: isPrivate,
                    onChanged: (val) {
                      setState(() {
                        isPrivate = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Speichern"),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newProfile = UserProfile(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    street: _streetController.text,
                    houseNumber: _houseNumberController.text,
                    zipCode: _zipCodeController.text,
                    city: _cityController.text,
                    isPrivate: isPrivate,
                  );
                  await _addUserProfile(newProfile);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContractPartnerProfileDialog(BuildContext parentContext) {
    final formKey = GlobalKey<FormState>();

    bool isInContractList = false;

    final TextEditingController _companyNameController =
        TextEditingController();
    final TextEditingController _contactPersonController =
        TextEditingController();
    final TextEditingController _streetController = TextEditingController();
    final TextEditingController _houseNumberController =
        TextEditingController();
    final TextEditingController _zipCodeController = TextEditingController();
    final TextEditingController _cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Vertragspartner hinzufügen"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormFieldWithoutIcon(
                    labelText: "Firmenname",
                    hintText: "Firmenname eingeben",
                    controller: _companyNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Firmenname eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Ansprechpartner",
                    hintText: "Ansprechpartner eingeben",
                    controller: _contactPersonController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Ansprechpartner eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Straße",
                    hintText: "Straße eingeben",
                    controller: _streetController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Straße eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Hausnummer",
                    hintText: "Hausnummer eingeben",
                    controller: _houseNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Hausnummer eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "PLZ",
                    hintText: "PLZ eingeben",
                    controller: _zipCodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte PLZ eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  const SizedBox(height: 8),
                  TextFormFieldWithoutIcon(
                    labelText: "Stadt",
                    hintText: "Stadt eingeben",
                    controller: _cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Stadt eingeben';
                      }
                      return null;
                    },
                    autofillHints: [],
                  ),
                  SwitchListTile(
                    title: const Text("In Vertragsliste"),
                    value: isInContractList,
                    onChanged: (val) {
                      setState(() {
                        isInContractList = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Speichern"),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newPartnerProfile = ContractPartnerProfile(
                    companyName: _companyNameController.text,
                    contactPersonName: _contactPersonController.text,
                    street: _streetController.text,
                    houseNumber: _houseNumberController.text,
                    zipCode: _zipCodeController.text,
                    city: _cityController.text,
                    isInContractList: isInContractList,
                  );
                  await _addContractPartnerProfile(newPartnerProfile);

                  // Snackbar anzeigen (wichtig: parentContext benutzen!)
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(
                      content: Text("Vertragspartner gespeichert"),
                    ),
                  );

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
