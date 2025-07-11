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

  Map<String, dynamic> toMap() {
    return {
      'costsInCents': costsInCents,
      'firstCostDate': firstCostDate?.toIso8601String(),
      'costRepeatInterval': costRepeatInterval.name,
    };
  }

  factory ContractCostRoutine.fromMap(Map<String, dynamic> map) {
    return ContractCostRoutine(
      costsInCents: map['costsInCents'] ?? 0,
      firstCostDate: map['firstCostDate'] != null
          ? DateTime.parse(map['firstCostDate'])
          : null,
      costRepeatInterval: CostRepeatInterval.values.firstWhere(
        (e) => e.name == map['costRepeatInterval'],
        orElse: () => CostRepeatInterval.month,
      ),
    );
  }

  String? get interval => null;
}
