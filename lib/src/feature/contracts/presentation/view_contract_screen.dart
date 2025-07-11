import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:intl/intl.dart'; // für Datum

class ViewContractScreen extends StatefulWidget {
  final String contractNumber;
  final DatabaseRepository db;

  const ViewContractScreen({
    super.key,
    required this.contractNumber,
    required this.db,
  });

  @override
  State<ViewContractScreen> createState() => _ViewContractScreenState();
}

class _ViewContractScreenState extends State<ViewContractScreen> {
  Contract? _contract;
  bool _isLoading = true;
  String? _error;
  final dateFormat = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
    _loadContract();
  }

  Future<void> _loadContract() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final contract = await widget.db.getContractByNumber(
        widget.contractNumber,
      );
      if (contract == null) {
        setState(() {
          _error = 'Kein Vertrag mit dieser Nummer gefunden.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _contract = contract;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Laden des Vertrags: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Vertrag ansehen')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Vertrag ansehen')),
        body: Center(child: Text(_error!)),
      );
    }

    final contract = _contract!;
    final extraInfo = contract.extraContractInformations.toString().trim();

    return Scaffold(
      appBar: AppBar(
        title: Text('Vertrag: ${contract.keyword}'),
        backgroundColor: Palette.backgroundGreenBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategorie: ${contract.category.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Name: ${contract.keyword}'),
            SizedBox(height: 8),
            Text('Vertragsnummer: ${contract.contractNumber}'),
            SizedBox(height: 8),
            Text(
              'Benutzerprofil:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${contract.userProfile.firstName} ${contract.userProfile.lastName}',
            ),
            Text(
              '${contract.userProfile.street} ${contract.userProfile.houseNumber}',
            ),
            Text(
              '${contract.userProfile.zipCode} ${contract.userProfile.city}',
            ),
            SizedBox(height: 8),
            Text(
              'Vertragspartner:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(contract.contractPartnerProfile.companyName),
            Text(
              'Kontakt: ${contract.contractPartnerProfile.contactPersonName}',
            ),
            Text(
              '${contract.contractPartnerProfile.street} ${contract.contractPartnerProfile.houseNumber}',
            ),
            Text(
              '${contract.contractPartnerProfile.zipCode} ${contract.contractPartnerProfile.city}',
            ),
            SizedBox(height: 8),
            Text('Laufzeit:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Startdatum: ${dateFormat.format(contract.contractRuntime.dt)}',
            ),
            Text('Intervall: ${contract.contractRuntime.interval.name}'),
            Text(
              'Intervallanzahl: ${contract.contractRuntime.howManyinInterval}',
            ),
            Text(
              'Automatische Verlängerung: ${contract.contractRuntime.isAutomaticExtend ? "Ja" : "Nein"}',
            ),
            SizedBox(height: 8),
            Text(
              'Kündigungsintervall:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Intervall: ${contract.contractQuitInterval.quitInterval.name}',
            ),
            Text('Anzahl: ${contract.contractQuitInterval.howManyInQuitUnits}'),
            Text(
              'Kündigungserinnerung: ${contract.contractQuitInterval.isQuitReminderAlertSet ? "Aktiv" : "Inaktiv"}',
            ),
            SizedBox(height: 8),
            Text('Kosten:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Betrag: ${(contract.contractCostRoutine.costsInCents / 100).toStringAsFixed(2)} €',
            ),
            Text(
              'Erste Zahlung: ${contract.contractCostRoutine.firstCostDate != null ? dateFormat.format(contract.contractCostRoutine.firstCostDate!) : "Nicht verfügbar"}',
            ),
            Text(
              'Zahlungsintervall: ${contract.contractCostRoutine.costRepeatInterval.name}',
            ),
            SizedBox(height: 8),

            // Nur anzeigen, wenn Zusatzinformationen vorhanden sind
            if (extraInfo.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Zusatzinformationen:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(contract.extraContractInformations.toString()),
            ],
          ],
        ),
      ),
    );
  }
}
