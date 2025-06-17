import 'profile.dart';

class ContractPartnerProfile extends Profile {
  //Attribute
  final String companyName;
  final String contactPersonName;
  final bool isInContractList;

  //Konstruktor
  ContractPartnerProfile({
    required this.companyName,
    required this.contactPersonName,
    required super.street,
    required super.houseNumber,
    required super.zipCode,
    required super.city,
    required this.isInContractList,
  });

  @override
  String toString() => companyName;

  ContractPartnerProfile copyWith({
    String? companyName,
    String? contactPersonName,
    String? street,
    String? houseNumber,
    String? zipCode,
    String? city,
    bool? isInContractList,
  }) {
    return ContractPartnerProfile(
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
