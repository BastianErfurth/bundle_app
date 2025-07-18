import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/costs/domain/cost_per_month.dart';

class CostService {
  Future<List<CostPerMonth>> getCostsForYear({
    required DatabaseRepository db,
    required String year,
    ContractCategory? category,
    Contract? contract,
  }) async {
    final List<Contract> contracts = await db.getMyContracts();

    final int selectedYear = int.parse(year);
    final List<CostPerMonth> costs = List.generate(12, (index) {
      return CostPerMonth(selectedYear * 100 + (index + 1), 0);
    });

    for (final c in contracts) {
      if (category != null && c.category != category) continue;
      if (contract != null && c != contract) continue;

      final routine = c.contractCostRoutine;
      final firstDate = routine.firstCostDate!;
      final costInCents = routine.costsInCents;
      final interval = routine.costRepeatInterval;

      DateTime current = DateTime(firstDate.year, firstDate.month);
      while (current.year <= selectedYear) {
        if (current.year == selectedYear) {
          int index = current.month - 1;
          if (index >= 0 && index < costs.length) {
            costs[index].sum += costInCents;
          }
        }

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

        if (current.year > selectedYear + 1) break;
      }
    }

    return costs;
  }

  Map<String, dynamic> getCostsForYearAsMap({
    required DatabaseRepository db,
    required String year,
    ContractCategory? category,
    Contract? contract,
  }) {
    final costs = getCostsForYear(
      db: db,
      year: year,
      category: category,
      contract: contract,
    );

    return {
      'year': year,
      'costs': costs.then((value) => value.map((e) => e.toMap()).toList()),
    };
  }

  factory CostService() {
    return CostService._internal();
  }

  CostService._internal();
}
