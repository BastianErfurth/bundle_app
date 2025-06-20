enum QuitInterval {
  day,
  week,
  month,
  year;

  String get label {
    switch (this) {
      case QuitInterval.day:
        return 'Day';
      case QuitInterval.week:
        return 'Week';
      case QuitInterval.month:
        return 'Month';
      case QuitInterval.year:
        return 'Year';
    }
  }
}

class ContractQuitInterval {
  //Attribute
  final int howManyInQuitUnits;
  final QuitInterval quitInterval;
  final bool isQuitReminderAlertSet;

  //Konstruktor
  ContractQuitInterval({
    required this.howManyInQuitUnits,
    required this.quitInterval,
    required this.isQuitReminderAlertSet,
  });
}
