import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';

abstract class DatabaseRepository {
  // Verträge
  Future<void> addContract(Contract newContract);
  Future<void> modifyContract(Contract contractName);
  Future<void> deleteContract(Contract docDeleteName);
  Future<List<Contract>> getMyContracts();

  // UserProfiles
  Future<List<UserProfile>> getUserProfiles();
  Future<void> addUserProfile(UserProfile profile); // async machen
  Future<void> deleteUserProfile(UserProfile profile); // hinzufügen

  // Vertragspartner
  Future<List<ContractPartnerProfile>> getContractors();
  Future<void> addContractPartnerProfile(
    ContractPartnerProfile profile,
  ); // async machen
  Future<void> deleteContractPartnerProfile(
    ContractPartnerProfile profile,
  ); // hinzufügen
  Future<Contract?> getContractByNumber(String contractNumber);
}
