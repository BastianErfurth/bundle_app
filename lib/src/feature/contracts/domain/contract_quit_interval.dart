enum QuitInterval {
  day("Day"),
  week("Week"),
  month("Month"),
  year("Year");

  final String label;
  const QuitInterval(this.label);

  String get labelname {
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

  Map<String, dynamic> toMap() {
    return {
      'howManyInQuitUnits': howManyInQuitUnits,
      'quitInterval': quitInterval.name,
      'isQuitReminderAlertSet': isQuitReminderAlertSet,
    };
  }

  factory ContractQuitInterval.fromMap(Map<String, dynamic> map) {
    return ContractQuitInterval(
      howManyInQuitUnits: map['howManyInQuitUnits'] ?? 0,
      quitInterval:
          QuitInterval.fromLabel(map['quitInterval']) ?? QuitInterval.month,
      isQuitReminderAlertSet: map['isQuitReminderAlertSet'] ?? false,
    );
  }

  String get intervalLabel {
    return quitInterval.labelname;
  }
}
