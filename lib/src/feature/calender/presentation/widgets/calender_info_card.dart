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
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Palette.textWhite, width: 0.4),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateText, style: TextStyle(color: Palette.textWhite)),
            Text(textTopic, style: Theme.of(context).textTheme.titleSmall),
            iconButton ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
