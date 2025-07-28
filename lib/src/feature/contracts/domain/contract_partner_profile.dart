import 'profile.dart';

class ContractPartnerProfile extends Profile {
  //Attribute
  final String? id;
  final String companyName;
  final String contactPersonName;
  final bool isInContractList;

  //Konstruktor
  ContractPartnerProfile({
    this.id,
    required this.companyName,
    required this.contactPersonName,
    required super.street,
    required super.houseNumber,
    required super.zipCode,
    required super.city,
    required this.isInContractList,
  });

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'contactPersonName': contactPersonName,
      'street': street,
      'houseNumber': houseNumber,
      'zipCode': zipCode,
      'city': city,
      'isInContractList': isInContractList,
    };
  }

  factory ContractPartnerProfile.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    return ContractPartnerProfile(
      id: id,
      companyName: map['companyName'] ?? '',
      contactPersonName: map['contactPersonName'] ?? '',
      street: map['street'] ?? '',
      houseNumber: map['houseNumber'] ?? '',
      zipCode: map['zipCode'] ?? '',
      city: map['city'] ?? '',
      isInContractList: map['isInContractList'] ?? false,
    );
  }

  @override
  String toString() => companyName;

  ContractPartnerProfile copyWith({
    String? id,
    String? companyName,
    String? contactPersonName,
    String? street,
    String? houseNumber,
    String? zipCode,
    String? city,
    bool? isInContractList,
  }) {
    return ContractPartnerProfile(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      street: street ?? this.street,
      houseNumber: houseNumber ?? this.houseNumber,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      isInContractList: isInContractList ?? this.isInContractList,
    );
  }
}
