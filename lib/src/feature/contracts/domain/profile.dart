import 'package:bundle_app/src/feature/contracts/domain/contract.dart';

abstract class Profile {
  //Attribute

  List<Contract> contractList = [];

  String street;
  String houseNumber;
  String zipCode;
  String city;

  //Konstruktor
  Profile({
    required this.street,
    required this.houseNumber,
    required this.zipCode,
    required this.city,
  });
}
