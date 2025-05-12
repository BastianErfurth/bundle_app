import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class ContractAttributes extends StatelessWidget {
  final String textTopic;
  final IconButton iconButton;
  const ContractAttributes({
    super.key,
    required this.textTopic,
    required this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Palette.lightGreenBlue, Palette.darkGreenblue]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Palette.textWhite, width: 0.3)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(textTopic, style: Theme.of(context).textTheme.titleMedium),
            iconButton,
          ],
        ),
      ),
    );
  }
}
