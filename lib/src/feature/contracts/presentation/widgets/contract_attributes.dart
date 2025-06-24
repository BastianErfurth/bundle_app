import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class ContractAttributes extends StatelessWidget {
  final String? textTopic;
  final Widget? trailing; // <-- war IconButton, jetzt allgemein Widget
  final String? valueText;

  const ContractAttributes({
    super.key,
    required this.textTopic,
    this.trailing,
    this.valueText,
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
            Expanded(
              child: Text(
                '$textTopic: ${valueText ?? ''}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
