import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/profile.dart';

class MockDatabaseRepository implements DatabaseRepository {
  //simulierte Datenbank
  List<Contract> myContracts = [];
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
