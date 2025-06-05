import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';

abstract class DatabaseRepository {
  // Vertraege
  Future<void> addContract(Contract newContract);
  Future<void> modifyContract(Contract contractName);
  Future<void> deleteContract(Contract docDeleteName);
  Future<List<Contract>> getMyContracts();

  // Vertragspartner
  Future<List<UserProfile>> getUserProfiles();
  void addProfile(UserProfile profile);
  Future<List<ContractPartnerProfile>> getContractors();
  void addContractPartnerProfile(ContractPartnerProfile profile);
}
