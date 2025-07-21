import 'package:bundle_app/src/feature/contracts/domain/contract_quit_interval.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_runtime.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_quit_interval.dart';
import 'package:intl/intl.dart';

class CalenderService {
  Map<String, dynamic>? _generateQuitReminder(Contract contract) {
    final start = contract.contractRuntime.dt;

    final contractEnd = DateTime(
      start.year + contract.contractRuntime.howManyinInterval,
      start.month,
      start.day,
    ).subtract(const Duration(days: 1));

    final quitInterval = contract.contractQuitInterval.quitInterval;

    DateTime quitDate;

    switch (quitInterval) {
      case QuitInterval.month:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month - contract.contractQuitInterval.howManyInQuitUnits,
          contractEnd.day,
        );
        break;
      case QuitInterval.week:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month,
          contractEnd.day -
              contract.contractQuitInterval.howManyInQuitUnits * 7,
        );
        break;
      case QuitInterval.day:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month,
          contractEnd.day - contract.contractQuitInterval.howManyInQuitUnits,
        );
        break;
      case QuitInterval.year:
        quitDate = DateTime(
          contractEnd.year - contract.contractQuitInterval.howManyInQuitUnits,
          contractEnd.month,
          contractEnd.day,
        );
        break;
    }

    final reminderDate = quitDate.subtract(
      const Duration(days: 10),
    ); // 10 Tage vor Kündigungsfrist

    if (reminderDate.isBefore(DateTime.now())) {
      return null;
    }

    return {
      'title':
          "Kündigung vorbereiten für '${contract.keyword}'. Kündigung zum ${DateFormat('dd.MM.yyyy').format(contractEnd)}",
      'reminderDate': reminderDate,
    };
  }
}
