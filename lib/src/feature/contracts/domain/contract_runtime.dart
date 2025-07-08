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

  Map<String, dynamic> toMap() {
    return {
      'dt': dt.toIso8601String(),
      'howManyinInterval': howManyinInterval,
      'interval': interval.label,
      'isAutomaticExtend': isAutomaticExtend,
    };
  }

  factory ContractRuntime.fromMap(Map<String, dynamic> map) {
    return ContractRuntime(
      dt: DateTime.parse(map['dt']),
      howManyinInterval: map['howManyinInterval'] ?? 0,
      interval: Interval.values.firstWhere(
        (e) => e.name == map['interval'],
        orElse: () => Interval.month,
      ),
      isAutomaticExtend: map['isAutomaticExtend'] ?? false,
    );
  }
}
