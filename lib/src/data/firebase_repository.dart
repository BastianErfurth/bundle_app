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
    final user = fbAuth.currentUser;
    if (user == null) throw Exception("Kein angemeldeter Nutzer");

    final data = newContract.toMap();
    data['userId'] = user.uid;
    await fs.collection("mycontracts").add(data);
  }

  @override
  Future<void> deleteContract(Contract docDeleteName) async {
    await fs.collection("mycontracts").doc().delete();
  }

  @override
  Future<void> modifyContract(Contract updatedContract) async {
    if (updatedContract.id == null) {
      throw Exception("Contract ID darf nicht null sein");
    }

    final docRef = fs.collection("mycontracts").doc(updatedContract.id);

    await docRef.update(updatedContract.toMap());
  }

  Future<List<Contract>> getMyContracts() async {
    final user = FirebaseAuth.instance.currentUser;
    //print('Aktueller User: ${user?.uid}');

    final snapshot = await fs
        .collection('mycontracts')
        .where('userId', isEqualTo: user?.uid)
        .get();

    //print('Contracts gefunden: ${snapshot.docs.length}');

    return snapshot.docs
        .map((doc) {
          try {
            return Contract.fromMap(doc.data(), id: doc.id);
          } catch (e) {
            //print('Fehler beim Parsen: $e');
            return null;
          }
        })
        .whereType<Contract>()
        .toList();
  }

  // @override
  // Future<List<Contract>> getMyContracts() async {
  //   final user = fbAuth.currentUser;
  //   if (user == null) {
  //     return [];
  //   }
  //   final userId = user.uid;

  //   final snap = await fs
  //       .collection("mycontracts")
  //       .where("userId", isEqualTo: userId)
  //       .get();

  //   return snap.docs.map((e) => Contract.fromMap(e.data(), id: e.id)).toList();
  // }

  @override
  Future<void> addContractPartnerProfile(ContractPartnerProfile profile) async {
    final user = fbAuth.currentUser;
    if (user == null) throw Exception("Kein angemeldeter Nutzer");

    final data = profile.toMap();
    data['userId'] = user.uid;

    await fs.collection("mycontractors").add(data);
  }

  @override
  Future<void> addUserProfile(UserProfile profile) async {
    final user = fbAuth.currentUser;
    if (user == null) throw Exception("Kein angemeldeter Nutzer");

    final data = profile.toMap();
    data['userId'] = user.uid; // <-- Wichtig, damit du später filtern kannst

    await fs.collection("myuserprofiles").add(data);
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

  @override
  Future<void> deleteUserProfile(UserProfile profile) async {
    if (profile.id == null) {
      throw Exception("Kein Dokument-ID zum Löschen vorhanden.");
    }
    await fs.collection('myuserprofiles').doc(profile.id).delete();
  }

  @override
  Future<void> deleteContractPartnerProfile(
    ContractPartnerProfile profile,
  ) async {
    if (profile.id == null) {
      throw Exception("Keine Dokument-ID vorhanden, kann Profil nicht löschen");
    }
    await fs.collection('mycontractors').doc(profile.id).delete();
  }

  @override
  Future<Contract?> getContractByNumber(String contractNumber) async {
    final querySnapshot = await fs
        .collection('mycontracts')
        .where('contractNumber', isEqualTo: contractNumber)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      final doc = querySnapshot.docs.first;
      return Contract.fromMap(doc.data(), id: doc.id);
    }
  }
}
