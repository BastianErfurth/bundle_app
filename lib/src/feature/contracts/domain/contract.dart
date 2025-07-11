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

  Map<String, dynamic> toMap() {
    return {
      'category': category.label,
      'keyword': keyword,
      'userProfile': userProfile.toMap(),
      'contractPartnerProfile': contractPartnerProfile.toMap(),
      'contractNumber': contractNumber,
      'contractRuntime': contractRuntime.toMap(),
      'contractQuitInterval': contractQuitInterval.toMap(),
      'contractCostRoutine': contractCostRoutine.toMap(),
      'extraContractInformations': extraContractInformations.toMap(),
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map) {
    return Contract(
      category: ContractCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ContractCategory.other,
      ),
      keyword: map['keyword'] ?? '',
      userProfile: UserProfile.fromMap(map['userProfile']),
      contractPartnerProfile: ContractPartnerProfile.fromMap(
        map['contractPartnerProfile'],
      ),
      contractNumber: map['contractNumber'] ?? '',
      contractRuntime: ContractRuntime.fromMap(map['contractRuntime']),
      contractQuitInterval: ContractQuitInterval.fromMap(
        map['contractQuitInterval'],
      ),
      contractCostRoutine: ContractCostRoutine.fromMap(
        map['contractCostRoutine'],
      ),
      extraContractInformations: ExtraContractInformation.fromMap(
        map['extraContractInformations'],
      ),
    );
  }

  DateTime? get firstCostDate => contractCostRoutine.firstCostDate;

  CostRepeatInterval? get costRepeatInterval =>
      contractCostRoutine.costRepeatInterval;
}
