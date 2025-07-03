enum CostRepeatInterval {
  day('Day'),
  week('Week'),
  month('Month'),
  quarter('Quarter'),
  halfyear('Half Year'),
  year('Year');

  final String label;
  const CostRepeatInterval(this.label);
}

class ContractCostRoutine {
  //Attribute
  int costsInCents;
  DateTime? firstCostDate;
  CostRepeatInterval costRepeatInterval;

  //Konstruktor
  ContractCostRoutine({
    required this.costsInCents,
    required this.firstCostDate,
    required this.costRepeatInterval,
  });

  String? get interval => null;
}
