import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyTableCalender extends StatefulWidget {
  final List<String> Function(DateTime day) getEventsForDay;

  const MyTableCalender({super.key, required this.getEventsForDay});

  @override
  State<MyTableCalender> createState() => _MyTableCalenderState();
}

class _MyTableCalenderState extends State<MyTableCalender> {
  final DateTime _focusesDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusesDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: widget.getEventsForDay,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Palette.textWhite),
        weekdayStyle: TextStyle(color: Palette.textWhite),
      ),
      rowHeight: 30,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontSize: 14),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox.shrink();

          return ListView.builder(
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Palette.calenderAlert, // 🔴 Farbe hier ändern
                shape: BoxShape.circle,
                border: Border.all(
                  color: Palette.backgroundGreenBlue, // 🔴 Randfarbe
                  width: 0.5,
                ),
              ),
            ),
          );
        },
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
  }
}
