import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.backgroundGreenBlue,
        title: Text('Impressum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text('''
Angaben gemäß § 5 TMG:

Max Mustermann  
Musterstraße 1  
12345 Musterstadt  

Kontakt:  
Telefon: 01234 56789  
E-Mail: info@mustermann.de

Verantwortlich für den Inhalt:  
Max Mustermann
            ''', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
