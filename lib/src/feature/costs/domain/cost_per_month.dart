class CostPerMonth {
  final int monthNumber;
  int sum;

  CostPerMonth(this.monthNumber, this.sum);

  @override
  String toString() {
    return sum.toString() + "     " + monthNumber.toString();
  }
}

//num Months { JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OKT, NOV, DEZ }
