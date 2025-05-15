import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_quit_interval.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_runtime.dart';
import 'package:bundle_app/src/feature/contracts/domain/extra_contract_information.dart';
import 'package:bundle_app/src/feature/contracts/domain/profile.dart';
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
          isPrivate: true),
      contractPartnerProfile: ContractPartnerProfile(
          companyName: "Allianz AG",
          contactPersonName: "Frau Schmidt",
          street: "Königsgasse",
          houseNumber: "15a",
          zipCode: "50608",
          city: "Köln",
          isInContractList: false),
      contractNumber: "MM123456789",
      contractRuntime: ContractRuntime(
          dt: DateTime.now(),
          howManyinInterval: 2,
          interval: Interval.year,
          isAutomaticExtend: true),
      contractQuitInterval: ContractQuitInterval(
          howManyInQuitUnits: 3,
          quitInterval: QuitInterval.month,
          isQuitReminderAlertSet: true),
      contractCostRoutine: ContractCostRoutine(
          costsInCents: 7900,
          everyAgainIntervalNumber: 6,
          costRepeatInterval: CostRepeatInterval.month),
      extraContractInformations:
          ExtraContractInformation("Audi 80 rot", "B AA 007"),
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
          isPrivate: true),
      contractPartnerProfile: ContractPartnerProfile(
          companyName: "Fitness First GmbH",
          contactPersonName: "n.a",
          street: "Hauptstrasse",
          houseNumber: "48",
          zipCode: "10318",
          city: "Berlin",
          isInContractList: false),
      contractNumber: "M250425/01",
      contractRuntime: ContractRuntime(
          dt: DateTime.now(),
          howManyinInterval: 2,
          interval: Interval.year,
          isAutomaticExtend: true),
      contractQuitInterval: ContractQuitInterval(
          howManyInQuitUnits: 3,
          quitInterval: QuitInterval.month,
          isQuitReminderAlertSet: true),
      contractCostRoutine: ContractCostRoutine(
          costsInCents: 2900,
          everyAgainIntervalNumber: 1,
          costRepeatInterval: CostRepeatInterval.month),
      extraContractInformations:
          ExtraContractInformation("Sonderrabatt  berücksichtigt", ""),
    ),
  ];
  List<ContractPartnerProfile> myContractors = [];
  List<Profile> myProfiles = [];

  @override
  void addContract(Contract newContract) {
    myContracts.add(newContract);
  }

  @override
  void deleteContract(Contract docDeleteName) {
    myContracts.remove(docDeleteName);
  }

  @override
  void modifyContract(Contract updatedContract) {
    for (Contract contract in myContracts) {
      // check if the contract number matches
      if (contract.contractNumber == updatedContract.contractNumber) {
        // we have found the contract to update
        // remove the old contract and add the updated one
        myContracts.remove(contract);
        myContracts.add(updatedContract);
      }
    }
  }

  @override
  List<Contract> getMyContracts() {
    return myContracts;
  }

  @override
  void addContractPartnerProfile(ContractPartnerProfile profile) {
    myContractors.add(profile);
  }

  @override
  void addProfile(Profile profile) {
    myProfiles.add(profile);
  }

  @override
  List<ContractPartnerProfile> getContractors() {
    return myContractors;
  }

  @override
  List<Profile> getProfiles() {
    return myProfiles;
  }
}
