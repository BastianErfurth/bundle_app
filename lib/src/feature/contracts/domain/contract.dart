import 'user_profile.dart';
import 'contract_category.dart';
import 'contract_cost_routine.dart';
import 'contract_partner_profile.dart';
import 'contract_quit_interval.dart';
import 'contract_runtime.dart';
import 'extra_contract_information.dart';

class Contract {
  //Attribute
  ContractCategory category;
  String keyword;
  UserProfile userProfile;
  ContractPartnerProfile contractPartnerProfile;
  String contractNumber;
  ContractRuntime contractRuntime;
  ContractQuitInterval contractQuitInterval;
  ContractCostRoutine contractCostRoutine;
  ExtraContractInformation extraContractInformations;

  //Konstruktor

  Contract({
    required this.category,
    required this.keyword,
    required this.userProfile,
    required this.contractPartnerProfile,
    required this.contractNumber,
    required this.contractRuntime,
    required this.contractQuitInterval,
    required this.contractCostRoutine,
    required this.extraContractInformations,
  });

  get name => null;
}
