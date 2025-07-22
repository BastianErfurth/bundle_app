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
import 'package:flutter/material.dart' hide Interval;
import 'package:intl/intl.dart';

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

  @override
  Future<void> modifyContract(Contract updatedContract) async {
    if (updatedContract.id == null) {
      throw Exception("Contract ID darf nicht null sein");
    }

    final docRef = fs.collection("mycontracts").doc(updatedContract.id);

    await docRef.update(updatedContract.toMap());
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

  @override
  Future<Map<DateTime, List<String>>> getEvents() async {
    final List<Contract> contracts =
        await getMyContracts(); // Beispielhafte Verwendung
    final Map<DateTime, List<String>> events = {};

    for (final contract in contracts) {
      // Debug: Vertragsstart ausgeben
      debugPrint(
        "Vertrag '${contract.keyword}' startet am ${contract.contractRuntime.dt}",
      );

      // 1) Vertragsstart als Event
      final startDate = contract.contractRuntime.dt;
      final startDay = DateTime(startDate.year, startDate.month, startDate.day);
      events.putIfAbsent(startDay, () => []);
      events[startDay]!.add("Vertragsstart: '${contract.keyword}'");

      // 2) Erste Zahlung als Event (wenn vorhanden)
      final firstCostDate = contract.contractCostRoutine.firstCostDate;
      if (firstCostDate != null) {
        final paymentDay = DateTime(
          firstCostDate.year,
          firstCostDate.month,
          firstCostDate.day,
        );
        events.putIfAbsent(paymentDay, () => []);
        events[paymentDay]!.add("Erste Zahlung: '${contract.keyword}'");
      }

      // 3) Kündigungserinnerung
      if (contract.contractQuitInterval.isQuitReminderAlertSet &&
          contract.contractRuntime.isAutomaticExtend) {
        final reminder = _generateQuitReminder(contract);
        if (reminder != null) {
          final reminderDate = reminder['reminderDate'] as DateTime;
          final reminderDay = DateTime(
            reminderDate.year,
            reminderDate.month,
            reminderDate.day,
          );
          events.putIfAbsent(reminderDay, () => []);
          events[reminderDay]!.add(
            "Kündigung für '${contract.keyword}' zum ${DateFormat('dd.MM.yyyy').format(reminderDate)}",
          );
        }

        // TODO: implement getEvents
        throw UnimplementedError();
      }
    }
    return events;
  }

  Map<String, dynamic>? _generateQuitReminder(Contract contract) {
    final start = contract.contractRuntime.dt;

    final contractEnd = DateTime(
      start.year + contract.contractRuntime.howManyinInterval,
      start.month,
      start.day,
    ).subtract(const Duration(days: 1));

    final quitInterval = contract.contractQuitInterval.quitInterval;

    DateTime quitDate;

    switch (quitInterval) {
      case QuitInterval.month:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month - contract.contractQuitInterval.howManyInQuitUnits,
          contractEnd.day,
        );
        break;
      case QuitInterval.week:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month,
          contractEnd.day -
              contract.contractQuitInterval.howManyInQuitUnits * 7,
        );
        break;
      case QuitInterval.day:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month,
          contractEnd.day - contract.contractQuitInterval.howManyInQuitUnits,
        );
        break;
      case QuitInterval.year:
        quitDate = DateTime(
          contractEnd.year - contract.contractQuitInterval.howManyInQuitUnits,
          contractEnd.month,
          contractEnd.day,
        );
        break;
    }

    final reminderDate = quitDate.subtract(
      const Duration(days: 10),
    ); // 10 Tage vor Kündigungsfrist

    if (reminderDate.isBefore(DateTime.now())) {
      return null;
    }

    return {
      'title':
          "Kündigung vorbereiten für '${contract.keyword}'. Kündigung zum ${DateFormat('dd.MM.yyyy').format(contractEnd)}",
      'reminderDate': reminderDate,
    };
  }
}
