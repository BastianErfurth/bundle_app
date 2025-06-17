enum CostRepeatInterval { day, week, month, quarter, halfyear, year }

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
}
