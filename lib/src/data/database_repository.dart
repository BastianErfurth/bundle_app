import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/profile.dart';

abstract class DatabaseRepository {
  // Vertraege
  Future<void> addContract(Contract newContract);
  Future<void> modifyContract(Contract contractName);
  Future<void> deleteContract(Contract docDeleteName);
  Future<List<Contract>> getMyContracts();

  // Vertragspartner
  Future<List<Profile>> getProfiles();
  void addProfile(Profile profile);
  Future<List<ContractPartnerProfile>> getContractors();
  void addContractPartnerProfile(ContractPartnerProfile profile);
}
