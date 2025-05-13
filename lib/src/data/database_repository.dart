import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/profile.dart';

abstract class DatabaseRepository {
  // Vertraege
  void addContract(Contract newContract);
  void modifyContract(Contract ContractName);
  void deleteContract(Contract docDeleteName);
  List<Contract> getMyContracts();

  // Vertragspartner
  List<Profile> getProfiles();
  void addProfile(Profile profile);
  List<ContractPartnerProfile> getContractors();
  void addContractPartnerProfile(ContractPartnerProfile profile);
}
