import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/data/mock_database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/dropdown_select_field.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';

class CostScreen extends StatefulWidget {
  final DatabaseRepository db;
  const CostScreen(this.db, {super.key});

  @override
  State<CostScreen> createState() => _CostScreenState();
}

class _CostScreenState extends State<CostScreen> {
  String _zahlungsintervall = "Zahlungsintervall wählen";
  ContractCategory? _selectedContractCategory;
  Contract?
  _selectedContract; // NEU: ausgewählter Vertrag oder null = alle Verträge

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
                    _selectedContract =
                        null; // Vertrag reset bei Kategorie-Wechsel
                  });
                },
              ),
              SizedBox(height: 8),
              FutureBuilder<List<Contract>>(
                future: (widget.db as MockDatabaseRepository).getMyContracts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Fehler beim Laden der Verträge');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Keine Verträge gefunden');
                  } else {
                    final allContracts = snapshot.data!;
                    // Liste mit 'null' als erste Option für "Alle Verträge"
                    final filteredContracts = _selectedContractCategory == null
                        ? [null, ...allContracts]
                        : [
                            null,
                            ...allContracts
                                .where(
                                  (c) =>
                                      c.category == _selectedContractCategory,
                                )
                                // ignore: unnecessary_to_list_in_spreads
                                .toList(),
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
              SizedBox(
                height: 220,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 800,
                    child: BarChart(
                      BarChartData(
                        maxY: 10,
                        barGroups: List.generate(12, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: 5,
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
                                var style = TextStyle(color: Palette.textWhite);
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
                                  "Nov",
                                  "Dez",
                                ];
                                if (value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: style,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
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
}
