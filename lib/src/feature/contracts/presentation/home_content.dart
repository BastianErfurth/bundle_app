import 'package:bundle_app/src/feature/contracts/presentation/add_contract_screen.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/topic_headline.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
          Row(
            children: [
              TopicHeadline(
                  topicIcon: Icon(Icons.description_outlined),
                  topicText: "Verträge"),
              SizedBox(width: 8),
              FilledButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddContractScreen(),
                        ),
                      );
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add_box_outlined),
                      Text("Hinzufügen"),
                    ],
                  )),
              SizedBox(width: 8),
              FilledButton(
                onPressed: () {},
                child: Icon(Icons.description_outlined),
              ),
            ],
          ),
          Placeholder(
            child: Container(
              color: Palette.lightGreenBlue,
              width: 400,
              height: 100,
            ),
          ),
          Row(
            children: [
              TopicHeadline(
                  topicIcon: Icon(Icons.euro_symbol_outlined),
                  topicText: "Kosten"),
              SizedBox(width: 8),
              FilledButton(onPressed: () {}, child: Icon(Icons.euro_outlined)),
            ],
          ),
          Placeholder(
            child: Container(
              color: Palette.lightGreenBlue,
              width: 400,
              height: 100,
            ),
          ),
          Row(
            children: [
              TopicHeadline(
                  topicIcon: Icon(Icons.calendar_month), topicText: "Kalender"),
              SizedBox(width: 8),
              FilledButton(
                onPressed: () {},
                child: Icon(Icons.calendar_month),
              ),
            ],
          ),
          Placeholder(
            child: Container(
              color: Palette.lightGreenBlue,
              width: 400,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
