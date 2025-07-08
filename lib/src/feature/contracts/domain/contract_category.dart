enum ContractCategory {
  insurance('Versicherung'),
  housing('Wohnung / Haus'),
  mobilePhone('Mobilfunk'),
  leisure('Freizeit'),
  sport('Sport'),
  business('Business'),
  subscribtion('Abonnement'),
  other('Sonstiges');

  const ContractCategory(this.label);
  Map<String, dynamic> toMap() {
    return {'label': label};
  }

  factory ContractCategory.fromMap(Map<String, dynamic> map) {
    return ContractCategory.values.firstWhere(
      (e) => e.label == map['label'],
      orElse: () => ContractCategory.other,
    );
  }

  final String label;
}
