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
}
