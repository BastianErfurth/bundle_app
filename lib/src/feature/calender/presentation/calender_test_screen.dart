import 'package:bundle_app/src/feature/calender/domain/calender_events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/calender/presentation/widgets/calender_info_card.dart';
import 'package:bundle_app/src/feature/calender/presentation/widgets/my_table_calender.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/presentation/view_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';

// Dein Service importieren

class CalenderTestScreen extends StatefulWidget {
  const CalenderTestScreen({super.key});

  @override
  State<CalenderTestScreen> createState() => _CalenderTestScreenState();
}

class _CalenderTestScreenState extends State<CalenderTestScreen> {
  late Future<List<Contract>> _futureContracts;
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _futureContracts = Provider.of<DatabaseRepository>(
      context,
      listen: false,
    ).getMyContracts();
  }

  List<String> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // Damit bei Änderungen neu gebaut wird
    context.watch<AuthRepository>();
    context.watch<DatabaseRepository>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Palette.backgroundGreenBlue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contract>>(
          future: _futureContracts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Keine Verträge gefunden"));
            }

            final contracts = snapshot.data!;

            // Events über Service generieren
            _events = CalendarEventService.generateEvents(contracts);

            // Kündigungs-Reminder als Karten bauen
            final reminderCards = <Widget>[];

            for (final contract in contracts) {
              if (contract.contractQuitInterval.isQuitReminderAlertSet &&
                  contract.contractRuntime.isAutomaticExtend) {
                final reminder = CalendarEventService.generateQuitReminder(
                  contract,
                );
                if (reminder != null) {
                  final reminderDate = reminder['reminderDate'] as DateTime;
                  reminderCards.add(
                    CalenderInfoCard(
                      textTopic: reminder['title'],
                      iconButton: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ViewContractScreen(
                                contractNumber: contract.contractNumber,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.visibility_rounded,
                          color: Palette.textWhite,
                        ),
                      ),
                      dateText: DateFormat('dd.MM.yyyy').format(reminderDate),
                    ),
                  );
                }
              }
            }

            return Column(
              children: [
                const TopicHeadline(
                  topicIcon: Icon(Icons.calendar_month),
                  topicText: "Mein Kalender",
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.buttonTextGreenBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MyTableCalender(getEventsForDay: _getEventsForDay),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: reminderCards.isNotEmpty
                      ? ListView.separated(
                          itemCount: reminderCards.length,
                          itemBuilder: (context, index) => reminderCards[index],
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 4),
                        )
                      : const Center(
                          child: Text("Keine Kündigungserinnerungen"),
                        ),
                ),
                FilledButton.icon(
                  onPressed: () {},
                  label: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded),
                        SizedBox(width: 8),
                        Text("Terminübersicht versenden"),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
