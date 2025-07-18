class CostPerMonth {
  final int monthNumber; // z.B. 202501 für Jan 2025
  int sum; // Summe in Cent

  CostPerMonth(this.monthNumber, this.sum);

  @override
  String toString() {
    return '$sum     $monthNumber';
  }

  Map<String, dynamic> toMap() {
    return {'monthNumber': monthNumber, 'sum': sum};
  }

  factory CostPerMonth.fromMap(Map<String, dynamic> map) {
    return CostPerMonth(map['monthNumber'] ?? 0, map['sum'] ?? 0);
  }
}
