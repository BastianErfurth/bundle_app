// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/calender/presentation/widgets/calender_info_card.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract_cost_routine.dart';
import 'package:bundle_app/src/feature/contracts/presentation/view_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late Future<List<Contract>> _futureContracts;

  late Map<DateTime, List<String>> _events;

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

            _events = {};

            final reminderCards = <Widget>[];

            for (final contract in contracts) {
              debugPrint(
                "Vertrag '${contract.keyword}' startet am ${contract.contractRuntime.dt}",
              );

              // 1) Vertragsstart als Event
              final startDate = contract.contractRuntime.dt;
              final startDay = DateTime(
                startDate.year,
                startDate.month,
                startDate.day,
              );
              _events.putIfAbsent(startDay, () => []);
              _events[startDay]!.add("Vertragsstart: '${contract.keyword}'");

              // 2) Erste Zahlung als Event (wenn vorhanden)
              final firstCostDate = contract.contractCostRoutine.firstCostDate;
              if (firstCostDate != null) {
                final paymentDay = DateTime(
                  firstCostDate.year,
                  firstCostDate.month,
                  firstCostDate.day,
                );
                _events.putIfAbsent(paymentDay, () => []);
                _events[paymentDay]!.add(
                  "Erste Zahlung: '${contract.keyword}'",
                );
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
                  _events.putIfAbsent(reminderDay, () => []);
                  _events[reminderDay]!.add(
                    "Kündigung für '${contract.keyword}' zum ${DateFormat('dd.MM.yyyy').format(reminderDate)}",
                  );

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
                } else {
                  debugPrint(
                    "Kein Kündigungs-Reminder für '${contract.keyword}'",
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
                      child: TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        eventLoader: _getEventsForDay,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(color: Palette.textWhite),
                          weekdayStyle: TextStyle(color: Palette.textWhite),
                        ),
                        rowHeight: 30,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: true,
                          titleTextStyle: TextStyle(fontSize: 14),
                        ),

                        onDaySelected: (selectedDay, focusedDay) {
                          final events = _getEventsForDay(selectedDay);
                          if (events.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                  'Termine am ${DateFormat('dd.MM.yyyy').format(selectedDay)}',
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: events
                                      .map(
                                        (e) => ListTile(
                                          title: Text(
                                            e,
                                            style: e.startsWith("Kündigung")
                                                ? TextStyle(
                                                    color: Palette.textWhite,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Schließen'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },

                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (events.isNotEmpty) {
                              return Positioned(
                                bottom: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: events.map((_) {
                                    return Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Palette
                                            .textWhite, // Hier die rote Farbe für die Markierungen
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: reminderCards.isNotEmpty
                      ? ListView(children: reminderCards)
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

  Map<String, dynamic>? _generateQuitReminder(Contract contract) {
    final routine = contract.contractCostRoutine;

    if (routine.firstCostDate == null) return null;

    final start = routine.firstCostDate!;
    final contractEnd = DateTime(
      start.year + contract.contractRuntime.howManyinInterval,
      start.month,
      start.day,
    ).subtract(const Duration(days: 1));

    final quitInterval = contract.contractQuitInterval.quitInterval;

    DateTime quitDate;
    switch (quitInterval) {
      case CostRepeatInterval.month:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month - 1,
          contractEnd.day,
        );
        break;
      case CostRepeatInterval.quarter:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month - 3,
          contractEnd.day,
        );
        break;
      case CostRepeatInterval.halfyear:
        quitDate = DateTime(
          contractEnd.year,
          contractEnd.month - 6,
          contractEnd.day,
        );
        break;
      case CostRepeatInterval.year:
        quitDate = DateTime(
          contractEnd.year - 1,
          contractEnd.month,
          contractEnd.day,
        );
        break;
      default:
        quitDate = contractEnd;
    }

    final reminderDate = quitDate.subtract(const Duration(days: 14));

    if (reminderDate.isBefore(DateTime.now())) {
      return null;
    }

    return {
      'title':
          "Kündigung vorbereiten für '${contract.keyword}'. Kündigung zum ${DateFormat('dd.MM.yyyy').format(quitDate)}",
      'reminderDate': reminderDate,
    };
  }
}
