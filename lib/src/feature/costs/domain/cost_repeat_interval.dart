enum CostRepeatInterval { day, week, month, quarter, halfYear, year, once }

extension CostRepeatIntervalExtension on CostRepeatInterval {
  String get label {
    switch (this) {
      case CostRepeatInterval.day:
        return 'täglich';
      case CostRepeatInterval.week:
        return 'wöchentlich';
      case CostRepeatInterval.month:
        return 'monatlich';
      case CostRepeatInterval.quarter:
        return 'vierteljährlich';
      case CostRepeatInterval.halfYear:
        return 'halbjährlich';
      case CostRepeatInterval.year:
        return 'jährlich';
      case CostRepeatInterval.once:
        return 'einmalig';
    }
  }

  static CostRepeatInterval? fromLabel(String label) {
    return CostRepeatInterval.values.firstWhere(
      (e) => e.label.toLowerCase().trim() == label.toLowerCase().trim(),
      orElse: () => throw ArgumentError(
        'No matching CostRepeatInterval for label: $label',
      ),
    );
  }
}
