class ExtraContractInformation {
  String ownRemarks;
  String generalMissingRemarks;

  //Konstruktor
  ExtraContractInformation(this.ownRemarks, this.generalMissingRemarks);

  Map<String, dynamic> toMap() {
    return {
      'ownRemarks': ownRemarks,
      'generalMissingRemarks': generalMissingRemarks,
    };
  }

  factory ExtraContractInformation.fromMap(Map<String, dynamic> map) {
    return ExtraContractInformation(
      map['ownRemarks'] ?? '',
      map['generalMissingRemarks'] ?? '',
    );
  }
}
