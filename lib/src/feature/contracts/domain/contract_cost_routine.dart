enum CostRepeatInterval { day, week, month, quarter, year }

class ContractCostRoutine {
  //Attribute
  int costsInCents;
  int everyAgainIntervalNumber;
  CostRepeatInterval costRepeatInterval;

  //Konstruktor
  ContractCostRoutine({
    required this.costsInCents,
    required this.everyAgainIntervalNumber,
    required this.costRepeatInterval,
  });
}
