import 'package:bundle_app/src/common/app_navigation_bar.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class AddContractScreen extends StatefulWidget {
  const AddContractScreen({super.key});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppNavigationBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.attach_file,
                size: 400,
                color: Palette.darkGreenblue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                            onPressed: () {},
                            label: Row(
                              children: [
                                Icon(Icons.close),
                                Text("Abbrechen"),
                              ],
                            )),
                        FilledButton.icon(
                            onPressed: () {},
                            label: Row(
                              children: [
                                Icon(Icons.add_box_outlined),
                                Text("Hinzufügen"),
                              ],
                            )),
                      ],
                    ),
                    SizedBox(height: 24),
                    TopicHeadline(
                        topicIcon: Icon(Icons.description_outlined),
                        topicText: "Struktur"),
                    ContractAttributes(
                      textTopic: "Kategorie",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Stichwort eingeben",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                        topicIcon: Icon(Icons.description_outlined),
                        topicText: "Vertragsparteien"),
                    ContractAttributes(
                      textTopic: "Profil",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Vertragspartner",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Vertragsnummer",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                        topicIcon: Icon(Icons.access_time_rounded),
                        topicText: "Laufzeiten"),
                    ContractAttributes(
                      textTopic: "Vertragsstart",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Laufzeit",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Automatische Verlängerung",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.toggle_off)),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                        topicIcon: Icon(Icons.close), topicText: "Kündigung"),
                    ContractAttributes(
                      textTopic: "Kündigungsfrist",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Kündigungserinnerung",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.toggle_off)),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                        topicIcon: Icon(Icons.euro_symbol_outlined),
                        topicText: "Kosten"),
                    ContractAttributes(
                      textTopic: "Kosten",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Intervall Abbuchung",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 4),
                    ContractAttributes(
                      textTopic: "Zahlungsintervall",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.expand_more)),
                    ),
                    SizedBox(height: 16),
                    TopicHeadline(
                        topicIcon: Icon(Icons.add_box_outlined),
                        topicText: "Sonstiges"),
                    ContractAttributes(
                      textTopic: "Zusatzinformationen",
                      iconButton: IconButton(
                          onPressed: () {}, icon: Icon(Icons.add_box_outlined)),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                            onPressed: () {},
                            label: Row(
                              children: [
                                Icon(Icons.upload_file_outlined),
                                Text("Dokument hochladen"),
                              ],
                            )),
                        FilledButton.icon(
                            onPressed: () {},
                            label: Row(
                              children: [
                                Icon(Icons.save_alt_outlined),
                                Text("Speichern"),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
