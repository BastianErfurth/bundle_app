enum Interval {
  day,
  week,
  month,
  year,
  unlimited;

  String get label {
    switch (this) {
      case Interval.day:
        return 'Day';
      case Interval.week:
        return 'Week';
      case Interval.month:
        return 'Month';
      case Interval.year:
        return 'Year';
      case Interval.unlimited:
        return 'Unlimited';
    }
  }
}

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
