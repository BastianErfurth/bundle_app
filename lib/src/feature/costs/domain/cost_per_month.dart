class CostPerMonth {
  final int monthNumber; // z.B. 202501 für Jan 2025
  int sum; // Summe in Cent

  CostPerMonth(this.monthNumber, this.sum);

  @override
  String toString() {
    return '$sum     $monthNumber';
  }
}
