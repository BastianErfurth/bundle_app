import 'package:bundle_app/src/data/auth_repository.dart';
import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/feature/calender/domain/get_events_function.dart';
import 'package:bundle_app/src/feature/calender/presentation/calender_screen.dart';
import 'package:bundle_app/src/feature/calender/presentation/widgets/my_table_calender.dart';
import 'package:bundle_app/src/feature/contracts/domain/contract.dart'
    as contracts_domain;
import 'package:bundle_app/src/feature/contracts/presentation/add_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/my_contracts_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_piechart.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/feature/costs/domain/cost_functions.dart';
import 'package:bundle_app/src/feature/costs/presentation/cost_screen.dart';
import 'package:bundle_app/src/feature/costs/presentation/widgets/barcart_cost.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<contracts_domain.Contract>> _contractsFuture;
  final GetEventsFunction _eventService = GetEventsFunction();

  @override
  void initState() {
    super.initState();
    _contractsFuture = Provider.of<DatabaseRepository>(
      context,
      listen: false,
    ).getMyContracts();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthRepository>();
    final db = context.watch<DatabaseRepository>();
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
                  height: 75,
                  width: 75,
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
                        builder: (context) => AddContractScreen(),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _contractsFuture = db.getMyContracts();
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
                        builder: (context) => MyContractsScreen(),
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
                      MaterialPageRoute(builder: (context) => CostScreen()),
                    );
                  },
                  child: Icon(Icons.euro_outlined),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 800,
                  child: BarchartCost(
                    auswahljahr: DateTime.now().year.toString(),
                    future: CostService().getCostsForYear(
                      db: db,
                      year: DateTime.now().year.toString(),
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
                      MaterialPageRoute(builder: (context) => CalenderScreen()),
                    );
                  },
                  child: Icon(Icons.calendar_month),
                ),
              ],
            ),
            SizedBox(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Palette.buttonTextGreenBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MyTableCalender(
                    getEventsForDay: _eventService.getEventsForDay,
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
