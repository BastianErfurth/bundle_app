enum ContractCategory {
  insurance('Versicherung'),
  housing('Wohnung / Haus'),
  mobilePhone('Mobilfunk'),
  leisure('Freizeit'),
  sport('Sport'),
  business('Business'),
  subscribtion('Abonnement');

  const ContractCategory(this.label);
  final String label;
}
