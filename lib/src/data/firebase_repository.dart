import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_partner_profile.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_quit_interval.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_runtime.dart';
import 'package:bundle_app/src/feature/contracts/domain/extra_contract_information.dart';
import 'package:bundle_app/src/feature/contracts/domain/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository implements DatabaseRepository {
  final fs = FirebaseFirestore.instance;
  final fbAuth = FirebaseAuth.instance;

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
        isPrivate: true,
      ),
      contractPartnerProfile: ContractPartnerProfile(
        companyName: "Allianz AG",
        contactPersonName: "Frau Schmidt",
        street: "Königsgasse",
        houseNumber: "15a",
        zipCode: "50608",
        city: "Köln",
        isInContractList: false,
      ),
      contractNumber: "MM123456789",
      contractRuntime: ContractRuntime(
        dt: DateTime.now(),
        howManyinInterval: 2,
        interval: Interval.year,
        isAutomaticExtend: true,
      ),
      contractQuitInterval: ContractQuitInterval(
        howManyInQuitUnits: 3,
        quitInterval: QuitInterval.month,
        isQuitReminderAlertSet: true,
      ),
      contractCostRoutine: ContractCostRoutine(
        costsInCents: 7900,
        firstCostDate: DateTime(
          2025,
          6,
          1,
        ), // erstes Abbuchungsdatum muss hier hin
        costRepeatInterval: CostRepeatInterval.quarter,
      ),
      extraContractInformations: ExtraContractInformation(
        "Audi 80 rot",
        "B AA 007",
      ),
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
        isPrivate: true,
      ),
      contractPartnerProfile: ContractPartnerProfile(
        companyName: "Fitness First GmbH",
        contactPersonName: "n.a",
        street: "Hauptstrasse",
        houseNumber: "48",
        zipCode: "10318",
        city: "Berlin",
        isInContractList: false,
      ),
      contractNumber: "M250425/01",
      contractRuntime: ContractRuntime(
        dt: DateTime.now(),
        howManyinInterval: 2,
        interval: Interval.year,
        isAutomaticExtend: true,
      ),
      contractQuitInterval: ContractQuitInterval(
        howManyInQuitUnits: 3,
        quitInterval: QuitInterval.month,
        isQuitReminderAlertSet: true,
      ),
      contractCostRoutine: ContractCostRoutine(
        costsInCents: 2900,
        firstCostDate: DateTime(2025, 9, 1),
        costRepeatInterval: CostRepeatInterval.month,
      ),
      extraContractInformations: ExtraContractInformation(
        "Sonderrabatt  berücksichtigt",
        "",
      ),
    ),
  ];
  List<ContractPartnerProfile> myContractors = [
    ContractPartnerProfile(
      companyName: "O2Germany",
      contactPersonName: "Herr Funk",
      street: "Handyallee",
      houseNumber: "22",
      zipCode: "50556",
      city: "Köln",
      isInContractList: true,
    ),
    ContractPartnerProfile(
      companyName: "Allianz AG",
      contactPersonName: "Faru Schneider",
      street: "Kochstr",
      houseNumber: "23a",
      zipCode: "50608",
      city: "Köln",
      isInContractList: false,
    ),
  ];
  List<UserProfile> myUserProfiles = [
    UserProfile(
      lastName: "Erfurth",
      firstName: "Bastian",
      street: "Teststrasse",
      houseNumber: "8",
      zipCode: "10318",
      city: "Berlin",
      isPrivate: true,
    ),
    UserProfile(
      lastName: "Müller",
      firstName: "Max",
      street: "Schlossallee",
      houseNumber: "1",
      zipCode: "10118",
      city: "Berlin",
      isPrivate: true,
    ),
  ];

  @override
  Future<void> addContract(Contract newContract) async {
    await fs.collection("mycontracts").add(newContract.toMap());
  }

  @override
  Future<void> deleteContract(Contract docDeleteName) async {
    await fs.collection("mycontracts").doc().delete();
  }

  @override //TODO muss noch bearbeitet werden
  Future<void> modifyContract(Contract updatedContract) async {
    await Future.delayed(Duration(seconds: 1));
    final index = myContracts.indexWhere(
      (c) => c.contractNumber == updatedContract.contractNumber,
    );
    if (index != -1) {
      myContracts[index] = updatedContract;
    } else {
      throw Exception(
        "Vertrag mit Nummer ${updatedContract.contractNumber} nicht gefunden",
      );
    }
  }

  @override
  Future<List<Contract>> getMyContracts() async {
    final user = fbAuth.currentUser;
    if (user == null) {
      return [];
    }
    final userId = user.uid;

    final snap = await fs
        .collection("mycontracts")
        .where("userId", isEqualTo: userId)
        .get();

    return snap.docs.map((e) => Contract.fromMap(e.data(), id: e.id)).toList();
  }

  @override
  Future<void> addContractPartnerProfile(ContractPartnerProfile profile) async {
    await fs.collection("mycontractors").add(profile.toMap());
  }

  @override
  Future<void> addUserProfile(UserProfile profile) async {
    await fs.collection("myuserprofiles").add(profile.toMap());
  }

  @override
  Future<List<ContractPartnerProfile>> getContractors() async {
    final user = fbAuth.currentUser;
    if (user == null) {
      return [];
    }
    final userId = user.uid;

    final snap = await fs
        .collection("mycontractors")
        .where("userId", isEqualTo: userId)
        .get();

    return snap.docs
        .map((e) => ContractPartnerProfile.fromMap(e.data()))
        .toList();
  }

  @override
  Future<List<UserProfile>> getUserProfiles() async {
    final user = fbAuth.currentUser;
    if (user == null) {
      return [];
    }
    final userId = user.uid;

    final snap = await fs
        .collection("myuserprofiles")
        .where("userId", isEqualTo: userId)
        .get();

    return snap.docs.map((e) => UserProfile.fromMap(e.data())).toList();
  }

  @override //TODO muss noch bearbeitet werden
  Future<void> deleteUserProfile(UserProfile profile) async {
    await Future.delayed(Duration(seconds: 5));
    myUserProfiles.remove(profile);
  }

  @override //TODO muss noch bearbeitet werden
  Future<void> deleteContractPartnerProfile(
    ContractPartnerProfile profile,
  ) async {
    myContractors.remove(profile);
  }

  @override //TODO muss noch bearbeitet werden
  Future<Contract?> getContractByNumber(String contractNumber) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      return myContracts.firstWhere((c) => c.contractNumber == contractNumber);
    } catch (e) {
      return null;
    }
  }
}
