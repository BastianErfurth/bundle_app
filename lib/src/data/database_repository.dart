import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';

abstract class DatabaseRepository {
  // Verträge
  Future<void> addContract(Contract newContract);
  Future<void> modifyContract(Contract contractName);
  Future<void> deleteContract(String contractId);
  Future<List<Contract>> getMyContracts();

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
