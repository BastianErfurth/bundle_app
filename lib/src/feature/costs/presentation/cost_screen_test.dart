import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/dropdown_select_field.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';

class CostScreenTest extends StatefulWidget {
  final DatabaseRepository db;
  final AuthRepository auth;
  const CostScreenTest(this.db, this.auth, {super.key});

  @override
  State<CostScreenTest> createState() => _CostScreenTestState();
}

class _CostScreenTestState extends State<CostScreenTest> {
  String _zahlungsintervall = "Zahlungsintervall wählen";
  ContractCategory? _selectedContractCategory;
  Contract? _selectedContract;

  List<Contract> _allContracts = [];

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    final contracts = await widget.db.getMyContracts();
    setState(() {
      _allContracts = contracts;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter Verträge nach Kategorie
    List<Contract> filteredContracts = _allContracts.where((contract) {
      if (_selectedContractCategory == null) return true;
      return contract.category == _selectedContractCategory;
    }).toList();

    // Wenn ein Vertrag ausgewählt ist, nur diesen anzeigen
    if (_selectedContract != null) {
      filteredContracts = filteredContracts
          .where((c) => c.id == _selectedContract!.id)
          .toList();
    }

    // Berechne monatliche Kosten aus den gefilterten Verträgen
    final monthlyCosts = _calculateMonthlyCosts(filteredContracts);

    // Gesamtkosten im Jahr berechnen (Summe der Monatswerte)
    final gesamt = monthlyCosts.fold(0.0, (prev, e) => prev + e);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopicHeadline(
                topicIcon: Icon(Icons.euro),
                topicText: "Meine Kosten",
              ),
              SizedBox(height: 16),
              DropDownSelectField<ContractCategory?>(
                labelText: "Kategorie wählen",
                values: [null, ...ContractCategory.values],
                itemLabel: (ContractCategory? category) =>
                    category == null ? "Alle Kategorien" : category.label,
                selectedValue: _selectedContractCategory,
                onChanged: (ContractCategory? newValue) {
                  setState(() {
                    _selectedContractCategory = newValue;
                    _selectedContract = null;
                  });
                },
              ),
              SizedBox(height: 8),
              FutureBuilder<List<Contract>>(
                future: widget.db.getMyContracts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Fehler beim Laden der Verträge');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Keine Verträge gefunden');
                  } else {
                    final allContracts = snapshot.data!;
                    final filteredContractsDropdown =
                        _selectedContractCategory == null
                        ? [null, ...allContracts]
                        : [
                            null,
                            ...allContracts.where(
                              (c) => c.category == _selectedContractCategory,
                            ),
                          ];

                    return DropDownSelectField<Contract?>(
                      values: filteredContractsDropdown,
                      labelText: "Vertrag auswählen",
                      selectedValue: _selectedContract,
                      itemLabel: (Contract? contract) {
                        if (contract == null) return "Alle Verträge";
                        return '${contract.keyword} - ${contract.contractPartnerProfile.companyName}';
                      },
                      onChanged: (Contract? newValue) {
                        setState(() {
                          _selectedContract = newValue;
                        });
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 4),
              ContractAttributes(
                textTopic: "Zahlungsintervall",
                valueText: _zahlungsintervall,
                trailing: IconButton(
                  onPressed: showpayIntervalPicker,
                  icon: Icon(Icons.expand_more),
                ),
              ),
              SizedBox(height: 24),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Palette.textWhite, width: 0.4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.euro, size: 32),
                          SizedBox(width: 16),
                          Text(
                            (gesamt / 100).toStringAsFixed(2),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Gesamtsumme",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 280, // Größere Höhe für größere Balken
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 900,
                    child: BarChart(
                      BarChartData(
                        maxY: monthlyCosts.isNotEmpty
                            ? (monthlyCosts.reduce((a, b) => a > b ? a : b) *
                                      1.3)
                                  .clamp(10, double.infinity)
                            : 10,
                        barGroups: List.generate(12, (index) {
                          return BarChartGroupData(
                            x: index,
                            barsSpace: 6, // Abstand zwischen Balken in Gruppe
                            barRods: [
                              BarChartRodData(
                                fromY: 0,
                                toY: monthlyCosts[index] / 100, // Cent in Euro
                                color: Palette.lightGreenBlue,
                                width: 24, // Breitere Balken
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY:
                                      (monthlyCosts.reduce(
                                            (a, b) => a > b ? a : b,
                                          ) *
                                          1.3) /
                                      100,
                                  color: Palette.darkGreenblue.withOpacity(0.3),
                                ),
                              ),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                var style = TextStyle(
                                  color: Palette.textWhite,
                                  fontWeight: FontWeight.bold,
                                );
                                const months = [
                                  "Jan",
                                  "Feb",
                                  "Mar",
                                  "Apr",
                                  "Mai",
                                  "Jun",
                                  "Jul",
                                  "Aug",
                                  "Sep",
                                  "Okt",
                                  "Nov",
                                  "Dez",
                                ];
                                if (value.toInt() < months.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      months[value.toInt()],
                                      style: style,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        backgroundColor: Palette.darkGreenblue,
                        gridData: FlGridData(show: false),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {},
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded),
                      SizedBox(width: 4),
                      Text("Kostenübersicht versenden"),
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

  List<double> _calculateMonthlyCosts(List<Contract> contracts) {
    final List<double> monthlyCosts = List.filled(12, 0.0);
    final int currentYear = DateTime.now().year;

    for (var contract in contracts) {
      final start = contract.contractCostRoutine.firstCostDate;
      if (start == null) continue;

      final interval = contract.contractCostRoutine.costRepeatInterval;

      // Filter nach globalem Zahlungsintervall-String
      if (!_matchesFilter(interval, _zahlungsintervall)) continue;

      final cost = contract.contractCostRoutine.costsInCents.toDouble();

      final stepMonths = _stepMonthsFromInterval(interval);

      for (int m = 0; m < 12; m++) {
        final current = DateTime(currentYear, m + 1);

        // Zahlung erst ab dem Startdatum (Monat) berücksichtigen
        if (current.isBefore(DateTime(start.year, start.month))) continue;

        // Berechne die Differenz in Monaten zwischen aktuellem Monat und Startmonat
        int diffMonths =
            (current.year - start.year) * 12 + (current.month - start.month);

        // Wenn die Differenz modulo Intervall = 0, dann Zahlung in diesem Monat
        if (diffMonths % stepMonths == 0) {
          monthlyCosts[m] += cost;
        }
      }
    }

    return monthlyCosts;
  }

  int _stepMonthsFromInterval(CostRepeatInterval interval) {
    switch (interval) {
      case CostRepeatInterval.day:
        return 1; // täglich als monatlich zählen (vereinfachend)
      case CostRepeatInterval.week:
        return 1; // wöchentlich als monatlich zählen (vereinfachend)
      case CostRepeatInterval.month:
        return 1;
      case CostRepeatInterval.quarter:
        return 3;
      case CostRepeatInterval.halfyear:
        return 6;
      case CostRepeatInterval.year:
        return 12;
    }
  }

  bool _matchesFilter(CostRepeatInterval interval, String filter) {
    if (filter == 'Zahlungsintervall wählen') return true;

    switch (filter.toLowerCase()) {
      case 'monatlich':
        return interval == CostRepeatInterval.month;
      case 'vierteljährlich':
        return interval == CostRepeatInterval.quarter;
      case 'halbjährlich':
        return interval == CostRepeatInterval.halfyear;
      case 'jährlich':
        return interval == CostRepeatInterval.year;
      case 'täglich':
        return interval == CostRepeatInterval.day;
      case 'wöchentlich':
        return interval == CostRepeatInterval.week;
      default:
        return true;
    }
  }
}
