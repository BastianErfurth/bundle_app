import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';

abstract class DatabaseRepository {
  // Verträge
  Future<void> addContract(Contract newContract);
  Future<void> modifyContract(Contract contractName);
  Future<void> deleteContract(Contract docDeleteName);
  Future<List<Contract>> getMyContracts();
  //Future<Map<DateTime, List<String>>> getEvents();

  // UserProfiles
  Future<List<UserProfile>> getUserProfiles();
  Future<void> addUserProfile(UserProfile profile);
  Future<void> deleteUserProfile(UserProfile profile);

  // Vertragspartner
  Future<List<ContractPartnerProfile>> getContractors();
  Future<void> addContractPartnerProfile(ContractPartnerProfile profile);
  Future<void> deleteContractPartnerProfile(ContractPartnerProfile profile);
  Future<Contract?> getContractByNumber(String contractNumber);
}
