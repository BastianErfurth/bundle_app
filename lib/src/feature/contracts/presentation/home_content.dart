import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/calender/presentation/calender_screen.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart'
    as contracts_domain;
import 'package:bundle_app/src/feature/contracts/presentation/add_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/my_contracts_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_piechart.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/feature/costs/presentation/cost_screen.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeContent extends StatefulWidget {
  final DatabaseRepository db;
  final AuthRepository auth;
  const HomeContent(this.db, this.auth, {super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<contracts_domain.Contract>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _contractsFuture = widget.db.getMyContracts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  "assets/images/appicon.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text("Bundle", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Row(
              children: [
                TopicHeadline(
                  topicIcon: Icon(Icons.description_outlined),
                  topicText: "Verträge",
                ),
                SizedBox(width: 6),
                FilledButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AddContractScreen(widget.db, widget.auth),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _contractsFuture = widget.db.getMyContracts();
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add_box_outlined),
                      Text("Hinzufügen"),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MyContractsScreen(widget.db, widget.auth),
                      ),
                    );
                  },
                  child: Icon(Icons.description_outlined),
                ),
              ],
            ),
            SizedBox(height: 8),
            FutureBuilder<List<contracts_domain.Contract>>(
              future: _contractsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 150,
                    child: Center(child: Text('Fehler: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox(
                    height: 150,
                    child: Center(child: Text('Keine Verträge vorhanden')),
                  );
                } else {
                  return SizedBox(
                    height: 150,
                    child: ContractPieChart(contracts: snapshot.data!),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                TopicHeadline(
                  topicIcon: Icon(Icons.euro_symbol_outlined),
                  topicText: "Kosten",
                ),
                SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CostScreen(widget.db),
                      ),
                    );
                  },
                  child: Icon(Icons.euro_outlined),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 800,
                  child: BarChart(
                    BarChartData(
                      maxY: 10,
                      barGroups: List.generate(12, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: 5,
                              color: Palette.lightGreenBlue,
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              var style = TextStyle(color: Palette.textWhite);
                              const months = [
                                "Jan",
                                "Feb",
                                "Mar",
                                "Apr",
                                "Mai",
                                "Jun",
                                "Jul",
                                "Aug",
                                "Sep",
                                "Nov",
                                "Dez",
                              ];
                              if (value.toInt() < months.length) {
                                return Text(
                                  months[value.toInt()],
                                  style: style,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      backgroundColor: Palette.darkGreenblue,
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                TopicHeadline(
                  topicIcon: Icon(Icons.calendar_month),
                  topicText: "Kalender",
                ),
                SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CalenderScreen(widget.db),
                      ),
                    );
                  },
                  child: Icon(Icons.calendar_month),
                ),
              ],
            ),
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
          ],
        ),
      ),
    );
  }
}
