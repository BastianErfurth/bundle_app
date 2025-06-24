import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ContractPieChart extends StatelessWidget {
  final List<Contract> contracts;

  const ContractPieChart({required this.contracts, super.key});

  List<PieChartSectionData> _buildPieChartSections() {
    final Map<ContractCategory, int> categoryCounts = {};
    for (var contract in contracts) {
      categoryCounts[contract.category] =
          (categoryCounts[contract.category] ?? 0) + 1;
    }

    final total = categoryCounts.values.fold(0, (a, b) => a + b);
    final colors = [
      Palette.buttonBackgroundUnused1,
      Palette.buttonBackgroundUnused2,
      Palette.buttonTextGreenBlue,
      Palette.darkGreenblue,
      Palette.lightGreenBlue,
      Palette.mediumGreenBlue,
      Palette.textWhite,
      Palette.mixedGreenBlue,
    ];

    int colorIndex = 0;
    return categoryCounts.entries.map((entry) {
      final category = entry.key;
      final count = entry.value;
      final percentage = (count / total) * 100;
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        value: count.toDouble(),
        title: '${category.label}\n${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (contracts.isEmpty) {
      return const Center(child: Text('Keine Verträge vorhanden'));
    }

    return SizedBox(
      height: 150,
      child: PieChart(
        PieChartData(
          sections: _buildPieChartSections(),
          sectionsSpace: 2,
          centerSpaceRadius: 24,
        ),
      ),
    );
  }
}
