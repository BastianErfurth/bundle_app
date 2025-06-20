enum CostRepeatInterval {
  daily("täglich"),
  weekly("wöchentlich"),
  monthly("monatlich"),
  quarterly("vierteljährlich"),
  halfyearly("halbjährlich"),
  yearly("jährlich"),
  oneTime("einmalig");

  const CostRepeatInterval(this.label);
  final String label;
}
