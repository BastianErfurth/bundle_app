class ExtraContractInformation {
  String ownRemarks;
  String generalMissingRemarks;

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

  // Neue Methode, um den Text lesbar zurückzugeben
  String get displayText {
    if (ownRemarks.isNotEmpty && generalMissingRemarks.isNotEmpty) {
      return 'Eigene Bemerkungen: $ownRemarks\nAllgemeine Hinweise: $generalMissingRemarks';
    } else if (ownRemarks.isNotEmpty) {
      return 'Eigene Bemerkungen: $ownRemarks';
    } else if (generalMissingRemarks.isNotEmpty) {
      return 'Allgemeine Hinweise: $generalMissingRemarks';
    } else {
      return 'Keine Zusatzinformationen vorhanden.';
    }
  }

  @override
  String toString() => displayText;

  get text => null;
}
