import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class CalenderInfoCard extends StatelessWidget {
  final String textTopic;
  final IconButton? iconButton;
  final String dateText;
  const CalenderInfoCard({
    super.key,
    required this.textTopic,
    required this.iconButton,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Höhe kann variabel sein, damit der Text nicht abgeschnitten wird
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Palette.textWhite, width: 0.4),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // oben ausrichten für mehrzeiligen Text
        children: [
          // Datum mit fixierter Breite
          Container(
            width: 80,
            child: Text(
              dateText,
              style: TextStyle(color: Palette.textWhite),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          // Text mit flexiblem Platz und Zeilenumbruch
          Expanded(
            child: Text(
              textTopic,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Palette.textWhite),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          if (iconButton != null) ...[SizedBox(width: 8), iconButton!],
        ],
      ),
    );
  }
}
