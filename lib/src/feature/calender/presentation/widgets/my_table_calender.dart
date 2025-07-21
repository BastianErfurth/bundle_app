import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalender extends StatefulWidget {
  const TableCalender({super.key});

  @override
  State<TableCalender> createState() => _TableCalenderState();
}

class _TableCalenderState extends State<TableCalender> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      eventLoader: widget.getEventsForDay,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Palette.textWhite),
        weekdayStyle: TextStyle(color: Palette.textWhite),
      ),
      rowHeight: 30,
      headerStyle: const HeaderStyle(
        formatButtonVisible: true,
        titleTextStyle: TextStyle(fontSize: 14),
      ),

      // Tag anklicken: Events anzeigen
      onDaySelected: (selectedDay, focusedDay) {
        final events = widget.getEventsForDay(selectedDay);
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
                                  fontWeight: FontWeight.bold,
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
    );
    ;
  }
}
