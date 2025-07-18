import 'package:bundle_app/src/feature/costs/domain/cost_per_month.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarchartCost extends StatefulWidget {
  final Future<dynamic>? future;
  final String auswahljahr;
  const BarchartCost({this.future, super.key, required this.auswahljahr});

  @override
  State<BarchartCost> createState() => _BarchartCostState();
}

class _BarchartCostState extends State<BarchartCost> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("Keine Daten");
        }

        List<CostPerMonth> costs = snapshot.data!;

        double maxCost =
            costs.map((c) => c.sum).fold(0, (a, b) => a > b ? a : b) / 100;

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
                          String yearSuffix = widget.auswahljahr.substring(2);

                          String label = "${months[index]}$yearSuffix";

                          return Text(
                            label,
                            style: TextStyle(color: Colors.white, fontSize: 12),
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

                          double costValue = costs[index].sum.toDouble() / 100;

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
    );
  }
}
