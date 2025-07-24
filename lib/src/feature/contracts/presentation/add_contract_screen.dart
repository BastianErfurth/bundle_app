// ignore_for_file: use_build_context_synchronously

import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/autentification/presentation/widgets/text_form_field_without_icon.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_quit_interval.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_runtime.dart';
import 'package:bundle_app/src/feature/contracts/domain/extra_contract_information.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';
import 'package:bundle_app/src/feature/contracts/presentation/home_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/dropdown_select_field.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/feature/settings/presentation/setting_screen.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:intl/intl.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:provider/provider.dart';

class AddContractScreen extends StatefulWidget {
  const AddContractScreen({super.key});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

// Extension for CostRepeatInterval to provide fromLabel factory
extension CostRepeatIntervalExtension on CostRepeatInterval {
  static CostRepeatInterval fromLabel(String label) {
    return CostRepeatInterval.values.firstWhere(
      (e) => e.label.toLowerCase() == label.toLowerCase(),
      orElse: () => CostRepeatInterval.month,
    );
  }
}

class _AddContractScreenState extends State<AddContractScreen> {
  final TextEditingController _keywordcontroller = TextEditingController();
  final TextEditingController _contractNumberController =
      TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _extraInformationController =
      TextEditingController();

  UserProfile? _selectedUserProfile;

  DateTime? _startDate;
  DateTime? _firstPaymentDate;
  String _laufzeit = "Laufzeit";
  bool _autoVerlaengerung = false;
  bool _kuendigungserinnerung = false;
  String _kuendigungsfrist = "Kündigungsfrist";
  String _zahlungsintervall = "Zahlungsintervall";

  Future<List<UserProfile>>? _userProfilesFuture;
  Future<List<ContractPartnerProfile>>? _contractPartnerProfilesFuture;
  ContractPartnerProfile? _selectedContractPartnerProfile;
  ContractCategory? _selectedContractCategory;

  @override
  void initState() {
    DatabaseRepository db = Provider.of<DatabaseRepository>(
      context,
      listen: false,
    );
    super.initState();
    _userProfilesFuture = db.getUserProfiles();
    _contractPartnerProfilesFuture = (db)
        .getContractors(); // Future für Vertragspartner laden
    // Future für UserProfile laden
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          label: Row(
                            children: [Icon(Icons.close), Text("Abbrechen")],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop(true);
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
                    ),
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
                      autofillHints: [],
                    ),
                    SizedBox(height: 6),
                    SizedBox(height: 16),
                    TopicHeadline(
                      topicIcon: Icon(Icons.description_outlined),
                      topicText: "Vertragsparteien",
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<UserProfile>>(
                          future: _userProfilesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return DropDownSelectField<UserProfile>(
                                labelText: "Profil wählen",
                                values: snapshot.data!, // Hier direkt verwenden
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
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => SettingScreen(),
                                    ),
                                  )
                                  .then((_) {
                                    final db = Provider.of<DatabaseRepository>(
                                      context,
                                      listen: false,
                                    );
                                    setState(() {
                                      _userProfilesFuture = db
                                          .getUserProfiles();
                                      _contractPartnerProfilesFuture = db
                                          .getContractors();
                                    });
                                  });
                            },
                            icon: Icon(Icons.add),
                            label: Text("Profil hinzufügen"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<ContractPartnerProfile>>(
                          future: _contractPartnerProfilesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return DropDownSelectField<
                                ContractPartnerProfile
                              >(
                                labelText: "Vertragspartner wählen",
                                values: snapshot.data!,
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
                              return Text('Keine Vertragspartner gefunden');
                            }
                          },
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => SettingScreen(),
                                    ),
                                  )
                                  .then((_) {
                                    final db = Provider.of<DatabaseRepository>(
                                      context,
                                      listen: false,
                                    );
                                    setState(() {
                                      _userProfilesFuture = db
                                          .getUserProfiles();
                                      _contractPartnerProfilesFuture = db
                                          .getContractors();
                                    });
                                  });
                            },
                            icon: Icon(Icons.add),
                            label: Text("Vertragspartner hinzufügen"),
                          ),
                        ),
                      ],
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
                      autofillHints: [],
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
                      trailing: IconButton(
                        onPressed: datePickingStart,
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "Laufzeit wählen",
                      valueText: _laufzeit,
                      trailing: IconButton(
                        onPressed: () {
                          showLaufzeitPicker();
                        },
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "Automatische Verlängerung",
                      trailing: IconButton(
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
                      trailing: IconButton(
                        onPressed: () {
                          showCancelPeriodPicker();
                        },
                        icon: Icon(Icons.expand_more),
                      ),
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "Kündigungserinnerung",
                      trailing: IconButton(
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
                      textInputAction: TextInputAction.done,
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
                      autofillHints: [],
                    ),
                    SizedBox(height: 6),
                    ContractAttributes(
                      textTopic: "erste Abbuchung",
                      valueText: _firstPaymentDate != null
                          ? DateFormat('dd.MM.yyyy').format(_firstPaymentDate!)
                          : "wählen",
                      trailing: IconButton(
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
                      trailing: IconButton(
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
                      autofillHints: [],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SettingScreen(),
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
                          onPressed: _addContract,
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
          ['Tag(e)', 'Woche(n)', 'Monat(e)', 'Jahr(e)', 'unbegrenzt'],
        ],
        isArray: true,
      ),
      hideHeader: false,
      title: Text(
        'Laufzeit wählen',
        style: TextStyle(color: Palette.textWhite),
      ),
      selecteds: [0, 3], // z. B. 1 Jahr vorausgewählt
      textStyle: TextStyle(color: Palette.textWhite, fontSize: 18),
      onConfirm: (picker, selecteds) {
        final einheit = picker.getSelectedValues()[1];

        setState(() {
          if (selecteds[1] == 4) {
            // "unbegrenzt" wurde gewählt
            _laufzeit = 'unbegrenzt';
            _autoVerlaengerung = false; // Optional deaktivieren
          } else {
            final zahl = picker.getSelectedValues()[0];
            _laufzeit = '$zahl $einheit';

            // Optional: Auto-Verlängerung aktivieren, z. B. bei "1 Jahr(e)"
            if (einheit == 'Jahr(e)' && zahl == '1') {
              _autoVerlaengerung = true;
            }
          }
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

  void showCancelPeriodPicker() {
    Picker picker = Picker(
      backgroundColor: Palette.backgroundGreenBlue,
      adapter: PickerDataAdapter<String>(
        pickerData: [
          List.generate(31, (index) => '${index + 1}'),
          ['Tag(e)', 'Woche(n)', 'Monat(e)', 'Jahr(e)', 'unbegrenzt'],
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
    final List<String> zahlungsintervallOptionen = [
      'täglich',
      'wöchentlich',
      'monatlich',
      'vierteljährlich',
      'halbjährlich',
      'jährlich',
      'einmalig',
    ];

    Picker picker = Picker(
      backgroundColor: Palette.backgroundGreenBlue,
      adapter: PickerDataAdapter<String>(pickerData: zahlungsintervallOptionen),
      hideHeader: false,
      title: Text(
        'Zahlungsintervall wählen',
        style: TextStyle(color: Palette.textWhite),
      ),
      selecteds: [
        zahlungsintervallOptionen.contains(_zahlungsintervall)
            ? zahlungsintervallOptionen.indexOf(_zahlungsintervall)
            : 2, // Default 'monatlich'
      ],
      textStyle: TextStyle(color: Palette.textWhite, fontSize: 18),
      onConfirm: (picker, selecteds) {
        setState(() {
          _zahlungsintervall = zahlungsintervallOptionen[selecteds.first]
              .trim()
              .toLowerCase();
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

  void _addContract() async {
    // Validierung der Eingaben
    if (_selectedContractCategory == null ||
        _selectedUserProfile == null ||
        _selectedContractPartnerProfile == null ||
        _contractNumberController.text.trim().isEmpty ||
        _keywordcontroller.text.trim().isEmpty ||
        _startDate == null ||
        _firstPaymentDate == null ||
        _costController.text.trim().isEmpty ||
        _laufzeit == "Laufzeit" ||
        _kuendigungsfrist == "Kündigungsfrist" ||
        _zahlungsintervall == "Zahlungsintervall") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte alle Pflichtfelder korrekt ausfüllen.')),
      );
      return;
    }

    // Laufzeit prüfen (z.B. "1 Jahr")
    final laufzeitNormalized = _laufzeit.toLowerCase().trim();
    if (laufzeitNormalized != 'unbegrenzt') {
      final parts = laufzeitNormalized.split(' ');
      if (parts.length != 2 || int.tryParse(parts[0]) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte eine gültige Laufzeit auswählen.')),
        );
        return;
      }
    }

    // Kündigungsfrist prüfen (z.B. "3 Monate")
    final kuendigungsfristParts = _kuendigungsfrist.split(' ');
    if (kuendigungsfristParts.length != 2 ||
        int.tryParse(kuendigungsfristParts[0]) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bitte eine gültige Kündigungsfrist auswählen.'),
        ),
      );
      return;
    }

    // Kosten prüfen
    final cost = double.tryParse(_costController.text.trim());
    if (cost == null || cost < 0 || cost > 1000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bitte gültige Kosten eingeben (0 - 1.000.000 EUR).'),
        ),
      );
      return;
    }

    // Zahlungsintervall prüfen
    try {} catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte ein gültiges Zahlungsintervall wählen.')),
      );
      return;
    }

    // ContractRuntime zusammenbauen

    final contractRuntime = _laufzeit.toLowerCase().trim() == "unbegrenzt"
        ? ContractRuntime(
            dt: _startDate!,
            howManyinInterval: 0,
            interval: Interval.month,
            isAutomaticExtend: _autoVerlaengerung,
          )
        : () {
            final laufzeitParts = _laufzeit.split(' ');
            return ContractRuntime(
              dt: _startDate!,
              howManyinInterval: int.parse(laufzeitParts[0]),
              interval: Interval.values.firstWhere(
                (e) => e.label == laufzeitParts[1],
                orElse: () => Interval.month,
              ),
              isAutomaticExtend: _autoVerlaengerung,
            );
          }();

    // ContractQuitInterval zusammenbauen
    final contractQuitInterval = ContractQuitInterval(
      howManyInQuitUnits: int.parse(kuendigungsfristParts[0]),
      quitInterval: QuitInterval.values.firstWhere(
        (e) => e.label == kuendigungsfristParts[1],
        orElse: () => QuitInterval.month,
      ),
      isQuitReminderAlertSet: _kuendigungserinnerung,
    );

    // ContractCostRoutine zusammenbauen
    final contractCostRoutine = ContractCostRoutine(
      costsInCents: (cost * 100).toInt(),
      firstCostDate: _firstPaymentDate!,
      costRepeatInterval: CostRepeatInterval.values.firstWhere(
        (e) => e.label == _zahlungsintervall,
        orElse: () => CostRepeatInterval.month,
      ),
    );

    // ExtraContractInformation zusammenbauen
    final extraContractInformation = ExtraContractInformation(
      _extraInformationController.text.trim(),
      "",
    );

    // Neues Contract-Objekt erstellen
    final newContract = Contract(
      category: _selectedContractCategory!,
      keyword: _keywordcontroller.text.trim(),
      userProfile: _selectedUserProfile!,
      contractPartnerProfile: _selectedContractPartnerProfile!,
      contractNumber: _contractNumberController.text.trim(),
      contractRuntime: contractRuntime,
      contractQuitInterval: contractQuitInterval,
      contractCostRoutine: contractCostRoutine,
      extraContractInformations: extraContractInformation,
    );

    try {
      await Provider.of<DatabaseRepository>(
        context,
        listen: false,
      ).addContract(newContract);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vertrag erfolgreich hinzugefügt.')),
      );

      Navigator.of(context).pop(true); // Zurück zur vorherigen Ansicht
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern des Vertrags: $e')),
      );
    }
  }
}
