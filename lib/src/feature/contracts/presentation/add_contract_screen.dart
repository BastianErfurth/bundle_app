import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/data/mock_database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/dropdown_select_field.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/feature/settings/presentation/new_setting_screen.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

class AddContractScreen extends StatefulWidget {
  final DatabaseRepository db;
  const AddContractScreen(this.db, {super.key});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final TextEditingController _keywordcontroller = TextEditingController();
  final TextEditingController _contractNumberController =
      TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _extraInformationController =
      TextEditingController();

  DateTime? _startDate;
  DateTime? _firstPaymentDate;
  String _laufzeit = "Laufzeit";
  bool _autoVerlaengerung = false;
  bool _kuendigungserinnerung = false;
  String _kuendigungsfrist = "Kündigungsfrist";
  String _zahlungsintervall = "Zahlungsintervall";

  List<UserProfile> _userProfiles = [];
  List<ContractPartnerProfile> _contractPartnerProfiles = [];
  UserProfile? _selectedUserProfile;
  ContractPartnerProfile? _selectedContractPartnerProfile;
  ContractCategory? _selectedContractCategory;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _keywordcontroller.dispose();
    _contractNumberController.dispose();
    _costController.dispose();
    _extraInformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IgnorePointer(
              child: Center(
                child: Icon(
                  Icons.attach_file,
                  size: 400,
                  color: Palette.darkGreenblue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Row(
                            children: [Icon(Icons.close), Text("Abbrechen")],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(widget.db),
                              ),
                            );
                          },
                          label: Row(
                            children: [
                              Icon(Icons.add_box_outlined),
                              Text("Hinzufügen"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    TopicHeadline(
                      topicIcon: Icon(Icons.description_outlined),
                      topicText: "Struktur",
                    ),
                    DropDownSelectField<ContractCategory>(
                      labelText: "Kategorie wählen",
                      values: ContractCategory.values,
                      itemLabel: (ContractCategory category) => category.label,
                      selectedValue: _selectedContractCategory,
                      onChanged: (ContractCategory? newValue) {
                        setState(() {
                          _selectedContractCategory = newValue;
                        });
                      },
                    ), // Old implementation
                    SizedBox(height: 6),
                    TextFormFieldWithoutIcon(
                      labelText: "Stichwort eingeben",
                      hintText: "Stichwort",
                      controller: _keywordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte Stichwort eingeben";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    SizedBox(height: 16),
                    TopicHeadline(
                      topicIcon: Icon(Icons.description_outlined),
                      topicText: "Vertragsparteien",
                    ),
                    FutureBuilder<List<UserProfile>>(
                      future: (widget.db as MockDatabaseRepository)
                          .getUserProfiles(), // Explicit cast to MockDatabaseRepository
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          _userProfiles = snapshot.data!;
                          return DropDownSelectField<UserProfile>(
                            labelText: "Profil wählen",
                            values: _userProfiles,
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
                          return Text('No user profiles found');
                        }
                      },
                    ),
                    SizedBox(height: 6),
                    FutureBuilder<List<ContractPartnerProfile>>(
                      future: (widget.db as MockDatabaseRepository)
                          .getContractors(), // Explicit cast to MockDatabaseRepository
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          _contractPartnerProfiles = snapshot.data!;
                          return DropDownSelectField<ContractPartnerProfile>(
                            labelText: "Vertragspartner wählen",
                            values: _contractPartnerProfiles,
                            itemLabel: (ContractPartnerProfile profile) =>
                                profile.companyName,
                            selectedValue: _selectedContractPartnerProfile,
                            onChanged: (ContractPartnerProfile? newValue) {
                              setState(() {
                                _selectedContractPartnerProfile = newValue;
                              });
                            },
                          );
                        } else {
                          return Text('No contract partners found');
                        }
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormFieldWithoutIcon(
                      labelText: "Vertragnummer eingeben",
                      hintText: "Vertragsnummer",
                      controller: _contractNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte Vertragnummer eingeben";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                      topicIcon: Icon(Icons.access_time_rounded),
                      topicText: "Laufzeiten",
                    ),

                    ContractAttributes(
                      textTopic: "Vertragsstart",
                      valueText: _startDate != null
                          ? DateFormat('dd.MM.yyyy').format(_startDate!)
                          : "Startdatum wählen",
                      iconButton: IconButton(
                        onPressed: datePickingStart,
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "Laufzeit wählen",
                      valueText: _laufzeit,
                      iconButton: IconButton(
                        onPressed: () {
                          showLaufzeitPicker();
                        },
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "Automatische Verlängerung",
                      iconButton: IconButton(
                        icon: Icon(
                          _autoVerlaengerung
                              ? Icons.toggle_on
                              : Icons.toggle_off,
                          color: _autoVerlaengerung
                              ? Palette.lightGreenBlue
                              : Palette.buttonBackgroundUnused2,
                        ),
                        onPressed: () {
                          setState(() {
                            _autoVerlaengerung = !_autoVerlaengerung;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                      topicIcon: Icon(Icons.close),
                      topicText: "Kündigung",
                    ),
                    ContractAttributes(
                      textTopic: "Kündigungsfrist",
                      valueText: _kuendigungsfrist,
                      iconButton: IconButton(
                        onPressed: () {
                          showCancelPeriodPicker();
                        },
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "Kündigungserinnerung",
                      iconButton: IconButton(
                        onPressed: () {
                          setState(() {
                            _kuendigungserinnerung = !_kuendigungserinnerung;
                          });
                        },
                        icon: Icon(
                          _kuendigungserinnerung
                              ? Icons.toggle_on
                              : Icons.toggle_off,
                          color: _kuendigungserinnerung
                              ? Palette.lightGreenBlue
                              : Palette.buttonBackgroundUnused2,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                      topicIcon: Icon(Icons.euro_symbol_outlined),
                      topicText: "Kosten",
                    ),
                    TextFormFieldWithoutIcon(
                      labelText: "Kosten eingeben",
                      hintText: "Kosten in EUR",
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte Kosten eingeben";
                        } else if (double.tryParse(value) == null) {
                          return "Bitte eine gültige Zahl eingeben";
                        }
                        final cost = double.parse(value);
                        if (cost < 0) {
                          return "Kosten dürfen nicht negativ sein";
                        }
                        if (cost > 1000000) {
                          return "Kosten dürfen nicht mehr als 1.000.000 EUR betragen";
                        }
                        if (cost > 10000) {
                          return "Kosten sollten realistisch sein";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "erste Abbuchung",
                      valueText: _firstPaymentDate != null
                          ? DateFormat('dd.MM.yyyy').format(_firstPaymentDate!)
                          : "wählen",
                      iconButton: IconButton(
                        onPressed: () {
                          datePickingIntervall();
                        },
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "Zahlungsintervall",
                      valueText: _zahlungsintervall,
                      iconButton: IconButton(
                        onPressed: () {
                          showpayIntervalPicker();
                        },
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                      topicIcon: Icon(Icons.add_box_outlined),
                      topicText: "Sonstiges",
                    ),
                    TextFormFieldWithoutIcon(
                      labelText: "Zusatzinformationen eingeben",
                      hintText: "Zusatzinformationen",
                      controller: _extraInformationController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NewSettingScreen(
                                  databaseRepository: widget.db,
                                ),
                              ),
                            );
                          },
                          label: Row(
                            children: [
                              Icon(Icons.upload_file_outlined),
                              Text("Dokument hochladen"),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () {},
                          label: Row(
                            children: [
                              Icon(Icons.save_alt_outlined),
                              Text("Speichern"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void datePickingStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  void datePickingIntervall() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _firstPaymentDate = pickedDate;
        // Hier kannst du auch das Zahlungsintervall setzen, falls nötig
        // Zum Beispiel: _zahlungsintervall = 'monatlich';
      });
    }
  }

  void showLaufzeitPicker() {
    Picker picker = Picker(
      backgroundColor: Palette.backgroundGreenBlue,
      adapter: PickerDataAdapter<String>(
        pickerData: [
          List.generate(31, (index) => '${index + 1}'),
          ['Tag(e)', 'Woche(n)', 'Monat(e)', 'Jahr(e)', 'Unbegrenzt'],
        ],
        isArray: true,
      ),
      hideHeader: false,
      title: Text(
        'Laufzeit wählen',
        style: TextStyle(color: Palette.textWhite),
      ),
      selecteds: [0, 2],
      textStyle: TextStyle(color: Palette.textWhite, fontSize: 18),
      onConfirm: (picker, selecteds) {
        final zahl = picker.getSelectedValues()[0];
        final einheit = picker.getSelectedValues()[1];

        setState(() {
          _laufzeit = einheit == 'Unbegrenzt' ? 'Unbegrenzt' : '$zahl $einheit';
        });
      },
    );

    // Zeige den Picker im Dialog manuell
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Palette.backgroundGreenBlue,
          child: SizedBox(
            height: 250, // oder gewünschte Höhe
            child: picker.makePicker(),
          ),
        );
      },
    );
  }

  void showCancelPeriodPicker() {
    Picker picker = Picker(
      backgroundColor: Palette.backgroundGreenBlue,
      adapter: PickerDataAdapter<String>(
        pickerData: [
          List.generate(31, (index) => '${index + 1}'),
          ['Tag(e)', 'Woche(n)', 'Monat(e)', 'Jahr(e)', 'Unbegrenzt'],
        ],
        isArray: true,
      ),
      hideHeader: false,
      title: Text(
        'Laufzeit wählen',
        style: TextStyle(color: Palette.textWhite),
      ),
      selecteds: [0, 2],
      textStyle: TextStyle(color: Palette.textWhite, fontSize: 18),
      onConfirm: (picker, selecteds) {
        final zahl = picker.getSelectedValues()[0];
        final einheit = picker.getSelectedValues()[1];

        setState(() {
          _kuendigungsfrist = einheit == 'Unbegrenzt'
              ? 'Unbegrenzt'
              : '$zahl $einheit';
        });
      },
    );

    // Zeige den Picker im Dialog manuell
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Palette.backgroundGreenBlue,
          child: SizedBox(
            height: 250, // oder gewünschte Höhe
            child: picker.makePicker(),
          ),
        );
      },
    );
  }

  void showpayIntervalPicker() {
    final List<String> laufzeitOptionen = [
      'täglich',
      'wöchentlich',
      'monatlich',
      'vierteljährlich',
      'halbjährlich',
      'jährlich',
    ];

    Picker picker = Picker(
      backgroundColor: Palette.backgroundGreenBlue,
      adapter: PickerDataAdapter<String>(pickerData: laufzeitOptionen),
      hideHeader: false,
      title: Text(
        'Zahlungsintervall wählen',
        style: TextStyle(color: Palette.textWhite),
      ),
      selecteds: [
        laufzeitOptionen.contains(_zahlungsintervall)
            ? laufzeitOptionen.indexOf(_zahlungsintervall)
            : 2,
      ], // Auswahl merken
      textStyle: TextStyle(color: Palette.textWhite, fontSize: 18),
      onConfirm: (picker, selecteds) {
        setState(() {
          _zahlungsintervall = laufzeitOptionen[selecteds.first];
          // Hier kannst du auch das Datum der ersten Abbuchung setzen, falls nötig
          // Zum Beispiel: _firstPaymentDate = DateTime.now();
        });
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Palette.backgroundGreenBlue,
          child: SizedBox(height: 250, child: picker.makePicker()),
        );
      },
    );
  }
}
