import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_quit_interval.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_runtime.dart';
import 'package:bundle_app/src/feature/contracts/domain/extra_contract_information.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';

class MockDatabaseRepository implements DatabaseRepository {
  //simulierte Datenbank
  List<Contract> myContracts = [
    Contract(
      category: ContractCategory.insurance,
      keyword: "Kfz Versicherung Audi",
      userProfile: UserProfile(
        lastName: "Müller",
        firstName: "Max",
        street: "Schlossallee",
        houseNumber: "1",
        zipCode: "10118",
        city: "Berlin",
        isPrivate: true,
      ),
      contractPartnerProfile: ContractPartnerProfile(
        companyName: "Allianz AG",
        contactPersonName: "Frau Schmidt",
        street: "Königsgasse",
        houseNumber: "15a",
        zipCode: "50608",
        city: "Köln",
        isInContractList: false,
      ),
      contractNumber: "MM123456789",
      contractRuntime: ContractRuntime(
        dt: DateTime.now(),
        howManyinInterval: 2,
        interval: Interval.year,
        isAutomaticExtend: true,
      ),
      contractQuitInterval: ContractQuitInterval(
        howManyInQuitUnits: 3,
        quitInterval: QuitInterval.month,
        isQuitReminderAlertSet: true,
      ),
      contractCostRoutine: ContractCostRoutine(
        costsInCents: 7900,
        firstCostDate: DateTime(
          2025,
          6,
          1,
        ), // erstes Abbuchungsdatum muss hier hin
        costRepeatInterval: CostRepeatInterval.quarter,
      ),
      extraContractInformations: ExtraContractInformation(
        "Audi 80 rot",
        "B AA 007",
      ),
    ),
    Contract(
      category: ContractCategory.sport,
      keyword: "Fitness First",
      userProfile: UserProfile(
        lastName: "Müller",
        firstName: "Max",
        street: "Schlossallee",
        houseNumber: "1",
        zipCode: "10118",
        city: "Berlin",
        isPrivate: true,
      ),
      contractPartnerProfile: ContractPartnerProfile(
        companyName: "Fitness First GmbH",
        contactPersonName: "n.a",
        street: "Hauptstrasse",
        houseNumber: "48",
        zipCode: "10318",
        city: "Berlin",
        isInContractList: false,
      ),
      contractNumber: "M250425/01",
      contractRuntime: ContractRuntime(
        dt: DateTime.now(),
        howManyinInterval: 2,
        interval: Interval.year,
        isAutomaticExtend: true,
      ),
      contractQuitInterval: ContractQuitInterval(
        howManyInQuitUnits: 3,
        quitInterval: QuitInterval.month,
        isQuitReminderAlertSet: true,
      ),
      contractCostRoutine: ContractCostRoutine(
        costsInCents: 2900,
        firstCostDate: DateTime(2025, 9, 1),
        costRepeatInterval: CostRepeatInterval.month,
      ),
      extraContractInformations: ExtraContractInformation(
        "Sonderrabatt  berücksichtigt",
        "",
      ),
    ),
  ];
  List<ContractPartnerProfile> myContractors = [
    ContractPartnerProfile(
      companyName: "O2Germany",
      contactPersonName: "Herr Funk",
      street: "Handyallee",
      houseNumber: "22",
      zipCode: "50556",
      city: "Köln",
      isInContractList: true,
    ),
    ContractPartnerProfile(
      companyName: "Allianz AG",
      contactPersonName: "Faru Schneider",
      street: "Kochstr",
      houseNumber: "23a",
      zipCode: "50608",
      city: "Köln",
      isInContractList: false,
    ),
  ];
  List<UserProfile> myUserProfiles = [
    UserProfile(
      lastName: "Erfurth",
      firstName: "Bastian",
      street: "Teststrasse",
      houseNumber: "8",
      zipCode: "10318",
      city: "Berlin",
      isPrivate: true,
    ),
    UserProfile(
      lastName: "Müller",
      firstName: "Max",
      street: "Schlossallee",
      houseNumber: "1",
      zipCode: "10118",
      city: "Berlin",
      isPrivate: true,
    ),
  ];

  @override
  Future<void> addContract(Contract newContract) async {
    await Future.delayed(Duration(seconds: 5));
    myContracts.add(newContract);
  }

  @override
  Future<void> deleteContract(Contract docDeleteName) async {
    await Future.delayed(Duration(seconds: 5));
    myContracts.remove(docDeleteName);
  }

  @override
  Future<void> modifyContract(Contract updatedContract) async {
    await Future.delayed(Duration(seconds: 1));
    final index = myContracts.indexWhere(
      (c) => c.contractNumber == updatedContract.contractNumber,
    );
    if (index != -1) {
      myContracts[index] = updatedContract;
    } else {
      throw Exception(
        "Vertrag mit Nummer ${updatedContract.contractNumber} nicht gefunden",
      );
    }
  }

  @override
  Future<List<Contract>> getMyContracts() async {
    await Future.delayed(Duration(seconds: 5));
    return myContracts;
  }

  @override
  Future<void> addContractPartnerProfile(ContractPartnerProfile profile) async {
    await Future.delayed(Duration(seconds: 5));
    myContractors.add(profile);
  }

  @override
  Future<void> addUserProfile(UserProfile profile) async {
    await Future.delayed(Duration(seconds: 5));
    myUserProfiles.add(profile);
  }

  @override
  Future<List<ContractPartnerProfile>> getContractors() async {
    await Future.delayed(Duration(seconds: 5));
    return myContractors;
  }

  @override
  Future<List<UserProfile>> getUserProfiles() async {
    await Future.delayed(Duration(seconds: 5));
    return myUserProfiles;
  }

  @override
  Future<void> deleteUserProfile(UserProfile profile) async {
    await Future.delayed(Duration(seconds: 5));
    myUserProfiles.remove(profile);
  }

  @override
  Future<void> deleteContractPartnerProfile(
    ContractPartnerProfile profile,
  ) async {
    myContractors.remove(profile);
  }

  @override
  Future<Contract?> getContractByNumber(String contractNumber) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      return myContracts.firstWhere((c) => c.contractNumber == contractNumber);
    } catch (e) {
      return null;
    }
  }
}
