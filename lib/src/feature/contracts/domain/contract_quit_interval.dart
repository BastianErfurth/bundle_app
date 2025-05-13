enum QuitInterval { day, week, month, year }

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
