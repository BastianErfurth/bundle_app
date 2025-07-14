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

class CostTestScreen extends StatefulWidget {
  final DatabaseRepository db;
  final AuthRepository auth;
  const CostTestScreen(this.db, this.auth, {super.key});

  @override
  State<CostTestScreen> createState() => _CostTestScreenState();
}

class _CostTestScreenState extends State<CostTestScreen> {
  String _zahlungsintervall = "Zahlungsintervall wählen";
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.euro, size: 32),
                          SizedBox(width: 16),
                          Text(
                            "1440,00",
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

                  return SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 800,
                        child: BarChart(
                          BarChartData(
                            maxY: 200,
                            barGroups: List.generate(12, (index) {
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: costs[index].sum.toDouble() / 100,
                                    color: Palette.lightGreenBlue,
                                  ),
                                ],
                              );
                            }),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    var style = const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    );

                                    DateTime now = DateTime.now();
                                    int currentMonth = now.month;

                                    int monthIndex =
                                        ((currentMonth - 1) + value.toInt()) %
                                        12;
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

                                    return Text(
                                      months[monthIndex],
                                      style: style,
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
                                    if (index < 0 || index >= costs.length)
                                      return const SizedBox.shrink();

                                    double costValue =
                                        costs[index].sum.toDouble() / 100;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4,
                                      ), // etwas Abstand zum Balken
                                      child: Text(
                                        costValue.toStringAsFixed(2) + " €",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
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

    final List<CostPerMonth> costs = List.generate(
      12,
      (index) => CostPerMonth(index + 1, 0),
    );

    for (final contract in contracts) {
      final firstDate = contract.contractCostRoutine.firstCostDate;
      final costInCents = contract.contractCostRoutine.costsInCents;
      final repeatInterval = contract.contractCostRoutine.costRepeatInterval;

      if (firstDate == null) continue;

      switch (repeatInterval) {
        case CostRepeatInterval.day:
          // Kosten aufs Jahr hochrechnen und gleichmäßig auf Monate verteilen
          final dailyCost = costInCents;
          final monthlyCost = (dailyCost * 365 / 12).round();
          for (final costPerMonth in costs) {
            costPerMonth.sum += monthlyCost;
          }
          break;

        case CostRepeatInterval.week:
          // Wöchentliche Kosten aufs Jahr hochrechnen und auf Monate verteilen
          final weeklyCost = costInCents;
          final monthlyCost = (weeklyCost * 52 / 12).round();
          for (final costPerMonth in costs) {
            costPerMonth.sum += monthlyCost;
          }
          break;

        case CostRepeatInterval.month:
          // Jeden Monat wird der Betrag fällig
          for (final costPerMonth in costs) {
            costPerMonth.sum += costInCents;
          }
          break;

        case CostRepeatInterval.quarter:
          // Nur alle 3 Monate fällig (ab dem Startmonat)
          for (int i = 0; i < 12; i++) {
            final currentMonth = i + 1;
            final diff = (currentMonth - firstDate.month + 12) % 12;
            if (diff % 3 == 0) {
              costs[i].sum += costInCents;
            }
          }
          break;

        case CostRepeatInterval.halfyear:
          // Nur alle 6 Monate fällig (ab dem Startmonat)
          for (int i = 0; i < 12; i++) {
            final currentMonth = i + 1;
            final diff = (currentMonth - firstDate.month + 12) % 12;
            if (diff % 6 == 0) {
              costs[i].sum += costInCents;
            }
          }
          break;

        case CostRepeatInterval.year:
          // Nur im Startmonat fällig
          costs[firstDate.month - 1].sum += costInCents;
          break;
      }
    }

    return costs;
  }
}
// aktuelle Version ohne funktionierendem BarChart