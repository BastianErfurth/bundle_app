enum QuitInterval {
  day,
  week,
  month,
  year;

  String get label {
    switch (this) {
      case QuitInterval.day:
        return 'Tag(e()Day';
      case QuitInterval.week:
        return 'Woche(n)';
      case QuitInterval.month:
        return 'Monat(e)';
      case QuitInterval.year:
        return 'Jahr(e)';
    }
  }

  static QuitInterval? fromLabel(String label) {
    try {
      return QuitInterval.values.firstWhere(
        (e) => e.label.toLowerCase().trim() == label.toLowerCase().trim(),
      );
    } catch (_) {
      return null;
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
