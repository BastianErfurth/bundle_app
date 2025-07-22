import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_quit_interval.dart';
import 'package:intl/intl.dart';

class CalendarEventService {
  static Map<DateTime, List<String>> generateEvents(List<Contract> contracts) {
    final events = <DateTime, List<String>>{};

    for (final contract in contracts) {
      // Vertragsstart
      final startDate = contract.contractRuntime.dt;
      final startDay = DateTime(startDate.year, startDate.month, startDate.day);
      events.putIfAbsent(startDay, () => []);
      events[startDay]!.add("Vertragsstart: '${contract.keyword}'");

      // Erste Zahlung
      if (contract.firstCostDate != null) {
        final firstPayment = contract.firstCostDate!;
        final paymentDay = DateTime(
          firstPayment.year,
          firstPayment.month,
          firstPayment.day,
        );
        events.putIfAbsent(paymentDay, () => []);
        events[paymentDay]!.add("Erste Zahlung: '${contract.keyword}'");
      }

      // Kündigungserinnerung
      if (contract.contractQuitInterval.isQuitReminderAlertSet &&
          contract.contractRuntime.isAutomaticExtend) {
        final reminder = _generateQuitReminder(contract);
        if (reminder != null) {
          final reminderDate = reminder['reminderDate'] as DateTime;
          final reminderDay = DateTime(
            reminderDate.year,
            reminderDate.month,
            reminderDate.day,
          );
          events.putIfAbsent(reminderDay, () => []);
          events[reminderDay]!.add(reminder['title'] as String);
        }
      }
    }

    return events;
  }

  static Map<String, dynamic>? _generateQuitReminder(Contract contract) {
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

    final reminderDate = quitDate.subtract(const Duration(days: 10));

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
