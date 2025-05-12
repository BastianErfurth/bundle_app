import 'package:flutter/material.dart';

class TopicHeadline extends StatelessWidget {
  final Icon topicIcon;
  final String topicText;
  const TopicHeadline({
    super.key,
    required this.topicIcon,
    required this.topicText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        topicIcon,
        Text(
          topicText,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
