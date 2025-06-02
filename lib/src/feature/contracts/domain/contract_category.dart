enum ContractCategory {
  insurance('Versicherung'),
  housing('Wohnen'),
  mobilePhone('Mobilfunk'),
  leisure('Freizeit'),
  sport('Sport'),
  business('Business'),
  subscribtion('Abonnement');

  const ContractCategory(this.label);
  final String label;
}
