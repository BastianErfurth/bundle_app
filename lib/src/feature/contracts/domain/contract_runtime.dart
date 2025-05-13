enum Interval { day, week, month, year, unlimited }

class ContractRuntime {
  //Attribute
  DateTime dt;
  int howManyinInterval;
  Interval interval;
  bool isAutomaticExtend;

  //Konstruktor

  ContractRuntime({
    required this.dt,
    required this.howManyinInterval,
    required this.interval,
    required this.isAutomaticExtend,
  });
}
