import 'package:bundle_app/src/feature/calender/presentation/widgets/calender_info_card.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            TopicHeadline(
                topicIcon: Icon(Icons.calendar_month),
                topicText: "Mein Kalender"),
            SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Palette.buttonTextGreenBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Palette.textWhite),
                      weekdayStyle: TextStyle(color: Palette.textWhite),
                    ),
                    rowHeight: 30,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleTextStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            // CalenderInfoCard nur Platzhaöter. später muss Listviewbuilder.
            CalenderInfoCard(
                textTopic: "KFZ Versicherung kündigen",
                iconButton: IconButton(
                    onPressed: () {}, icon: Icon(Icons.visibility_off)),
                dateText: "21.5.2025"),
            Spacer(),
            FilledButton.icon(
                onPressed: () {},
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Icon(Icons.send_rounded),
                      Text("Terminübersicht versenden"),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
