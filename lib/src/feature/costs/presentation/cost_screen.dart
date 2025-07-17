import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
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
import 'package:provider/provider.dart';

class CostScreen extends StatefulWidget {
  const CostScreen({super.key});

  @override
  State<CostScreen> createState() => _CostScreenState();
}

class _CostScreenState extends State<CostScreen> {
  String _zahlungsintervall = "monatlich";
  ContractCategory? _selectedContractCategory;
  Contract? _selectedContract;
  String _auswahljahr = "2025";

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DatabaseRepository>();
    context.watch<AuthRepository>();
    return Scaffold(
      //appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
              SizedBox(height: 4),
              FutureBuilder<List<Contract>>(
                future: db.getMyContracts(),
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
              SizedBox(height: 8),
              Container(
                width: 250,
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
                      final selectedYear = int.parse(_auswahljahr);
                      final totalCostForYear = calculateTotalCostForYear(
                        costs,
                        selectedYear,
                      );
                      final totalCostText = totalCostForYear.toStringAsFixed(2);

                      return Column(
                        children: [
                          Text(
                            'Gesamtsumme $selectedYear:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '$totalCostText €',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          // Hier kannst du dein BarChart Widget hinzufügen
                        ],
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 8),
              ContractAttributes(
                textTopic: "Jahr wählen",
                valueText: _auswahljahr.toString(),
                trailing: IconButton(
                  icon: Icon(Icons.expand_more),
                  onPressed: showYearPicker,
                ),
              ),
              SizedBox(height: 40),
              FutureBuilder<List<CostPerMonth>>(
                future: getCostList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("Keine Daten");
                  }

                  List<CostPerMonth> costs = snapshot.data!;

                  double maxCost =
                      costs.map((c) => c.sum).fold(0, (a, b) => a > b ? a : b) /
                      100;

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
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: costs[index].sum.toDouble() / 100,
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
                                    if (index < 0 || index >= 12) {
                                      return SizedBox.shrink();
                                    }

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

                                    // Hole die letzten zwei Ziffern vom Jahr, z.B. "2025" -> "25"
                                    String yearSuffix = _auswahljahr.substring(
                                      2,
                                    );

                                    String label =
                                        "${months[index]}$yearSuffix";

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
                                    if (index < 0 || index >= 12) {
                                      return SizedBox.shrink();
                                    }

                                    double costValue =
                                        costs[index].sum.toDouble() / 100;

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

  Future<int?> showCustomYearPicker({
    required BuildContext context,
    required int selectedYear,
    required int firstYear,
    required int lastYear,
  }) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Jahr auswählen"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: lastYear - firstYear + 1,
              itemBuilder: (BuildContext context, int index) {
                final year = firstYear + index;
                return ListTile(
                  title: Text(year.toString()),
                  selected: year == selectedYear,
                  onTap: () {
                    Navigator.of(context).pop(year);
                  },
                );
              },
            ),
          ),
        );
      },
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

  Future<void> showYearPicker() async {
    final List<String> years = List.generate(
      15,
      (index) => (2022 + index).toString(),
    );

    int selectedIndex = years.indexOf(_auswahljahr);

    Picker picker = Picker(
      backgroundColor: Palette.backgroundGreenBlue,
      adapter: PickerDataAdapter<String>(pickerData: years),
      hideHeader: false,
      title: Text('Jahr wählen', style: TextStyle(color: Palette.textWhite)),
      selecteds: [selectedIndex],
      textStyle: TextStyle(color: Palette.textWhite, fontSize: 18),
      onConfirm: (picker, selecteds) {
        setState(() {
          _auswahljahr = years[selecteds.first];
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

  Future<List<CostPerMonth>> getCostList() async {
    final List<Contract> contracts = await Provider.of<DatabaseRepository>(
      context,
      listen: false,
    ).getMyContracts();

    final int selectedYear = int.parse(_auswahljahr);
    final List<CostPerMonth> costs = List.generate(12, (index) {
      return CostPerMonth(selectedYear * 100 + (index + 1), 0);
    });

    for (final contract in contracts) {
      // Filter auf Kategorie & Vertrag
      if (_selectedContractCategory != null &&
          contract.category != _selectedContractCategory) {
        continue;
      }
      if (_selectedContract != null && contract != _selectedContract) {
        continue;
      }

      final routine = contract.contractCostRoutine;
      final firstDate = routine.firstCostDate!;
      final costInCents = routine.costsInCents;
      final interval = routine.costRepeatInterval;

      // Erster Zahlungstermin (monatlich, vierteljährlich, etc.)
      DateTime current = DateTime(firstDate.year, firstDate.month);

      // Gehe durch die Zahlungszeiträume, bis Jahr + 1, um nicht endlos zu loopen
      while (current.year <= selectedYear) {
        if (current.year == selectedYear) {
          int index = current.month - 1;
          if (index >= 0 && index < costs.length) {
            costs[index].sum += costInCents;
          }
        }

        // Nächster Zahlungstermin je Intervall
        switch (interval) {
          case CostRepeatInterval.day:
            current = current.add(Duration(days: 1));
            break;
          case CostRepeatInterval.week:
            current = current.add(Duration(days: 7));
            break;
          case CostRepeatInterval.month:
            current = DateTime(current.year, current.month + 1);
            break;
          case CostRepeatInterval.quarter:
            current = DateTime(current.year, current.month + 3);
            break;
          case CostRepeatInterval.halfyear:
            current = DateTime(current.year, current.month + 6);
            break;
          case CostRepeatInterval.year:
            current = DateTime(current.year + 1, current.month);
            break;
        }

        // Abbruch bei zu großem Jahr
        if (current.year > selectedYear + 1) break;
      }
    }

    return costs;
  }
}


// aktuelle Version mit funktionierendem BarChart Stand 16.7.