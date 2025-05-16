import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CostScreen extends StatelessWidget {
  final DatabaseRepository db;
  const CostScreen(this.db, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Column(
        children: [
          TopicHeadline(topicIcon: Icon(Icons.euro), topicText: "Meine Kosten"),
          SizedBox(height: 16),
          ContractAttributes(
            textTopic: "Verträge auswählen",
            iconButton: IconButton(
              onPressed: () {},
              icon: Icon(Icons.expand_more),
            ),
          ),
          SizedBox(height: 4),
          ContractAttributes(
            textTopic: "Intervall auswählen",
            iconButton: IconButton(
              onPressed: () {},
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
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.euro,
                        size: 32,
                      ),
                      Text(
                        "1440,00",
                        style: Theme.of(context).textTheme.displaySmall,
                      )
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
                      return BarChartGroupData(x: index, barRods: [
                        BarChartRodData(toY: 5, color: Palette.lightGreenBlue),
                      ]);
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
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    ),
                    borderData: FlBorderData(show: false),
                    backgroundColor: Palette.darkGreenblue,
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          FilledButton.icon(
              onPressed: () {},
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Icon(Icons.send_rounded),
                    Text("Kostenübersicht versenden"),
                  ],
                ),
              )),
        ],
      )),
    );
  }
}
