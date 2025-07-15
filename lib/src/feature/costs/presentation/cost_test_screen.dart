import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/data/mock_database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/dropdown_select_field.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/feature/costs/domain/cost_per_month.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:intl/intl.dart';

class CostTestScreen extends StatefulWidget {
  final DatabaseRepository db;
  final AuthRepository auth;
  const CostTestScreen(this.db, this.auth, {super.key});

  @override
  State<CostTestScreen> createState() => _CostTestScreenState();
}

class _CostTestScreenState extends State<CostTestScreen> {
  String _zahlungsintervall = "monatlich";
  ContractCategory? _selectedContractCategory;
  Contract? _selectedContract;

  @override
  Widget build(BuildContext context) {
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
                    final filteredContracts = _selectedContractCategory == null
                        ? [null, ...allContracts]
                        : [
                            null,
                            ...allContracts.where(
                              (c) => c.category == _selectedContractCategory,
                            ),
                          ];

                    return DropDownSelectField<Contract?>(
                      values: filteredContracts,
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
                  child: FutureBuilder<List<CostPerMonth>>(
                    future: getCostList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("Keine Kosten vorhanden"));
                      }

                      final costs = snapshot.data!;
                      final currentYear = DateTime.now().year;
                      final totalCostForYear = calculateTotalCostForYear(
                        costs,
                        currentYear,
                      );
                      final totalCostText = totalCostForYear.toStringAsFixed(2);

                      return Column(
                        children: [
                          Text(
                            'Gesamtsumme $currentYear:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '$totalCostText €',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          // ... hier dein BarChart Widget usw.
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              FutureBuilder<List<CostPerMonth>>(
                future: getCostList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Keine Daten"));
                  }

                  List<CostPerMonth> costs = snapshot.data!;

                  // Hilfsfunktion: Dreht die Liste, sodass der erste Eintrag der aktuelle Monat ist
                  List<CostPerMonth> rotateCostsToCurrentMonth(
                    List<CostPerMonth> costs,
                  ) {
                    int currentMonth = DateTime.now().month; // 1..12
                    int rotateIndex = currentMonth - 1; // index 0..11

                    return List.generate(12, (i) {
                      return costs[(rotateIndex + i) % 12];
                    });
                  }

                  // Anwenden der Rotation
                  costs = rotateCostsToCurrentMonth(costs);
                  double maxCost =
                      costs.map((c) => c.sum).fold(0, (a, b) => a > b ? a : b) /
                      100;
                  double totalSum2025 = 0;
                  for (var cost in costs) {
                    // Monat in Jahr/Monat-Format umwandeln
                    int year = cost.monthNumber ~/ 100;
                    if (year == 2025) {
                      totalSum2025 += cost.sum;
                    }
                  }

                  return SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 800,
                        child: BarChart(
                          BarChartData(
                            maxY: maxCost > 0 ? maxCost * 1.3 : 200,
                            barGroups: List.generate(12, (index) {
                              DateTime now = DateTime.now();
                              int monthOffset =
                                  (now.month - 1) %
                                  12; // z. B. Juli -> 6 (indexbasiert)

                              // Daten ebenfalls rotieren
                              int rotatedIndex = (index + monthOffset) % 12;

                              return BarChartGroupData(
                                x: index, // Beschriftung & Daten sind jetzt synchron
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY:
                                        costs[rotatedIndex].sum.toDouble() /
                                        100,
                                    color: Palette.lightGreenBlue,
                                    width: 16,
                                  ),
                                ],
                              );
                            }),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= 12)
                                      return SizedBox.shrink();

                                    DateTime now = DateTime.now();
                                    DateTime monthDate = DateTime(
                                      now.year,
                                      now.month + index,
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

                                    String label =
                                        "${months[monthDate.month - 1]} ${monthDate.year % 100}";

                                    return Text(
                                      label,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    );
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
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= 12)
                                      return SizedBox.shrink();

                                    DateTime now = DateTime.now();
                                    int monthOffset = (now.month - 1) % 12;
                                    int rotatedIndex =
                                        (index + monthOffset) % 12;

                                    double costValue =
                                        costs[rotatedIndex].sum.toDouble() /
                                        100;

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        "${costValue.toStringAsFixed(2)} €",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            backgroundColor: Palette.darkGreenblue,
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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

  List<String> generateMonthLabels() {
    List<String> labels = [];
    DateTime chartStart = DateTime(DateTime.now().year, DateTime.now().month);

    for (int i = 0; i < 12; i++) {
      DateTime month = DateTime(chartStart.year, chartStart.month + i);
      String label = DateFormat('MMM yyyy').format(month); // z. B. "Jul 2025"
      labels.add(label);
    }

    return labels;
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
        'wählen', // nur Anzeigetext. monatlich ist by default ausgewählt
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

  double calculateTotalCostForYear(List<CostPerMonth> costs, int year) {
    double total = 0;
    for (final cost in costs) {
      // cost.monthNumber ist z.B. 202501 für Jan 2025, 202512 für Dez 2025
      int costYear = cost.monthNumber ~/ 100; // Integer-Division
      if (costYear == year) {
        total += cost.sum;
      }
    }
    return total / 100; // in Euro, wenn sum in Cent ist
  }

  // Future<List<CostPerMonth>> getCostList() async {
  //   final List<Contract> contracts = await widget.db.getMyContracts();
  //   final List<CostPerMonth> costs = [
  //     CostPerMonth(1, 0),
  //     CostPerMonth(2, 0),
  //     CostPerMonth(3, 0),
  //     CostPerMonth(4, 0),
  //     CostPerMonth(5, 0),
  //     CostPerMonth(6, 0),
  //     CostPerMonth(7, 0),
  //     CostPerMonth(8, 0),
  //     CostPerMonth(9, 0),
  //     CostPerMonth(10, 0),
  //     CostPerMonth(11, 0),
  //     CostPerMonth(12, 0),
  //   ];
  //   for (final contract in contracts) {
  //     int index = costs.indexWhere(
  //       (element) =>
  //           element.monthNumber ==
  //           contract.contractCostRoutine.firstCostDate?.month,
  //     );

  //     switch (contract.contractCostRoutine.costRepeatInterval) {
  //       case CostRepeatInterval.day:
  //         // TODO: Handle this case.
  //         throw UnimplementedError();
  //       case CostRepeatInterval.week:
  //         // TODO: Handle this case.
  //         throw UnimplementedError();
  //       case CostRepeatInterval.month:
  //         for (int i = 0; i < costs.length; i++)
  //         {
  //           costs[i].sum = contract.contractCostRoutine.costsInCents;
  //         }

  //       case CostRepeatInterval.quarter:
  //         // TODO: Handle this case.
  //         throw UnimplementedError();
  //       case CostRepeatInterval.halfyear:
  //         // TODO: Handle this case.
  //         throw UnimplementedError();
  //       case CostRepeatInterval.year:
  //         // TODO: Handle this case.
  //         throw UnimplementedError();
  //     }

  //     costs[index].sum += contract.contractCostRoutine.costsInCents;
  //   }

  //   return costs;
  // }
  Future<List<CostPerMonth>> getCostList() async {
    final List<Contract> contracts = await widget.db.getMyContracts();

    DateTime now = DateTime.now();
    DateTime chartStart = DateTime(now.year, now.month);

    final List<CostPerMonth> costs = List.generate(12, (index) {
      DateTime month = DateTime(chartStart.year, chartStart.month + index);
      int monthNumber = month.year * 100 + month.month;
      return CostPerMonth(monthNumber, 0);
    });

    for (final contract in contracts) {
      final firstDate = contract.contractCostRoutine.firstCostDate!;
      final costInCents = contract.contractCostRoutine.costsInCents;
      final repeatInterval = contract.contractCostRoutine.costRepeatInterval;

      for (int i = 0; i < costs.length; i++) {
        DateTime monthDate = DateTime(
          costs[i].monthNumber ~/ 100,
          costs[i].monthNumber % 100,
        );

        if (monthDate.isBefore(DateTime(firstDate.year, firstDate.month))) {
          continue;
        }

        bool addCost = false;

        switch (repeatInterval) {
          case CostRepeatInterval.month:
            addCost = true;
            break;

          case CostRepeatInterval.quarter:
            int diffInMonths =
                (monthDate.year - firstDate.year) * 12 +
                (monthDate.month - firstDate.month);
            if (diffInMonths % 3 == 0) addCost = true;
            break;

          case CostRepeatInterval.halfyear:
            int diffInMonths =
                (monthDate.year - firstDate.year) * 12 +
                (monthDate.month - firstDate.month);
            if (diffInMonths % 6 == 0) addCost = true;
            break;

          case CostRepeatInterval.year:
            if (monthDate.month == firstDate.month &&
                monthDate.year >= firstDate.year)
              addCost = true;
            break;

          default:
            break;
        }

        if (addCost) costs[i].sum += costInCents;
      }
    }

    return costs;
  }

  // List<double> rotateCostsToCurrentMonth(List<double> costs) {
  //   // Aktuellen Monat holen (1=Januar, 12=Dezember)
  //   int currentMonth = DateTime.now().month;

  //   // Index der Rotation berechnen (0-basiert)
  //   int rotateIndex = currentMonth - 1;

  //   // Liste aufteilen und neu zusammensetzen
  //   List<double> rotated = [
  //     ...costs.sublist(rotateIndex), // Ab aktuellem Monat bis Ende
  //     ...costs.sublist(0, rotateIndex), // Von Anfang bis Monat davor
  //   ];

  //   return rotated;
  // }

  List<BarChartGroupData> rotateBarsToCurrentMonth(
    List<BarChartGroupData> originalBars,
  ) {
    int currentMonth = DateTime.now().month; // 7 für Juli

    // In Flutter: Januar = 1, daher:
    // Index von Juli: 6 (0-basiert)
    int startIndex = currentMonth - 1;

    // Balken neu anordnen
    List<BarChartGroupData> rotatedBars = [
      ...originalBars.sublist(startIndex),
      ...originalBars.sublist(0, startIndex),
    ];

    return rotatedBars;
  }
}


// aktuelle Version mit funktionierendem BarChart nach 1to1 mit Ban und KI