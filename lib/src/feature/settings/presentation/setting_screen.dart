import 'package:flutter/material.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/data/database_repository.dart';

class SettingScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;

  const SettingScreen({super.key, required this.databaseRepository});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _userFormKey = GlobalKey<FormState>();
  final _partnerFormKey = GlobalKey<FormState>();

  List<UserProfile> _userProfiles = [];
  List<ContractPartnerProfile> _contractPartners = [];

  late UserProfile _newUser;
  late ContractPartnerProfile _newPartner;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final users = await widget.databaseRepository.getUserProfiles();
    final partners = await widget.databaseRepository.getContractors();
    setState(() {
      _userProfiles = users;
      _contractPartners = partners;
      _newUser = _emptyUserProfile();
      _newPartner = _emptyPartnerProfile();
      _loading = false;
    });
  }

  UserProfile _emptyUserProfile() => UserProfile(
    firstName: '',
    lastName: '',
    street: '',
    houseNumber: '',
    zipCode: '',
    city: '',
    isPrivate: false,
  );

  ContractPartnerProfile _emptyPartnerProfile() => ContractPartnerProfile(
    companyName: '',
    contactPersonName: '',
    street: '',
    houseNumber: '',
    zipCode: '',
    city: '',
    isInContractList: false,
  );

  Future<void> _saveUserProfile() async {
    if (_userFormKey.currentState!.validate()) {
      _userFormKey.currentState!.save();
      await widget.databaseRepository.addUserProfile(_newUser);
      await _loadProfiles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Benutzerprofil gespeichert")),
      );
    }
  }

  Future<void> _savePartnerProfile() async {
    if (_partnerFormKey.currentState!.validate()) {
      _partnerFormKey.currentState!.save();
      await widget.databaseRepository.addContractPartnerProfile(_newPartner);
      await _loadProfiles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Partnerprofil gespeichert")),
      );
    }
  }

  Future<void> _deleteUserProfile(UserProfile user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Profil löschen"),
        content: Text(
          "Möchtest du das Profil von ${user.firstName} ${user.lastName} wirklich löschen?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.databaseRepository.deleteUserProfile(user);
      await _loadProfiles();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Benutzerprofil gelöscht")));
    }
  }

  Future<void> _deletePartnerProfile(ContractPartnerProfile partner) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Partnerprofil löschen"),
        content: Text(
          "Möchtest du das Partnerprofil von ${partner.companyName} wirklich löschen?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.databaseRepository.deleteContractPartnerProfile(partner);
      await _loadProfiles();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Partnerprofil gelöscht")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Einstellungen")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Deine Profile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._userProfiles.map(
              (user) => ListTile(
                title: Text("${user.firstName} ${user.lastName}"),
                subtitle: Text(
                  "${user.street} ${user.houseNumber}, ${user.zipCode} ${user.city}",
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Palette.lightGreenBlue),
                  onPressed: () => _deleteUserProfile(user),
                ),
              ),
            ),

            Form(
              key: _userFormKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildTextField(
                    "Vorname",
                    (val) => _newUser = _newUser.copyWith(firstName: val),
                  ),
                  _buildTextField(
                    "Nachname",
                    (val) => _newUser = _newUser.copyWith(lastName: val),
                  ),
                  _buildTextField(
                    "Straße",
                    (val) => _newUser = _newUser.copyWith(street: val),
                  ),
                  _buildTextField(
                    "Hausnummer",
                    (val) => _newUser = _newUser.copyWith(houseNumber: val),
                  ),
                  _buildTextField(
                    "PLZ",
                    (val) => _newUser = _newUser.copyWith(zipCode: val),
                  ),
                  _buildTextField(
                    "Stadt",
                    (val) => _newUser = _newUser.copyWith(city: val),
                  ),
                  SwitchListTile(
                    title: const Text("Privates Profil"),
                    value: _newUser.isPrivate,
                    onChanged: (val) => setState(() {
                      _newUser = _newUser.copyWith(isPrivate: val);
                    }),
                  ),
                  ElevatedButton(
                    onPressed: _saveUserProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.mediumGreenBlue,
                    ),
                    child: const Text("Benutzerprofil hinzufügen"),
                  ),
                ],
              ),
            ),

            const Divider(height: 40),

            const Text(
              "Vertragspartnerprofile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._contractPartners.map(
              (p) => ListTile(
                title: Text(p.companyName),
                subtitle: Text("Ansprechperson: ${p.contactPersonName}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Palette.lightGreenBlue),
                  onPressed: () => _deletePartnerProfile(p),
                ),
              ),
            ),

            Form(
              key: _partnerFormKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildTextField(
                    "Firmenname",
                    (val) =>
                        _newPartner = _newPartner.copyWith(companyName: val),
                  ),
                  _buildTextField(
                    "Ansprechperson",
                    (val) => _newPartner = _newPartner.copyWith(
                      contactPersonName: val,
                    ),
                  ),
                  _buildTextField(
                    "Straße",
                    (val) => _newPartner = _newPartner.copyWith(street: val),
                  ),
                  _buildTextField(
                    "Hausnummer",
                    (val) =>
                        _newPartner = _newPartner.copyWith(houseNumber: val),
                  ),
                  _buildTextField(
                    "PLZ",
                    (val) => _newPartner = _newPartner.copyWith(zipCode: val),
                  ),
                  _buildTextField(
                    "Stadt",
                    (val) => _newPartner = _newPartner.copyWith(city: val),
                  ),
                  SwitchListTile(
                    title: const Text("Teil der Vertragsliste"),
                    value: _newPartner.isInContractList,
                    onChanged: (val) => setState(() {
                      _newPartner = _newPartner.copyWith(isInContractList: val);
                    }),
                  ),
                  ElevatedButton(
                    onPressed: _savePartnerProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.mediumGreenBlue,
                    ),
                    child: const Text("Partnerprofil hinzufügen"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    Function(String) onSaved, {
    String? initialValue,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label darf nicht leer sein';
        }
        return null;
      },
      onSaved: (newValue) {
        if (newValue != null) onSaved(newValue);
      },
    );
  }
}
