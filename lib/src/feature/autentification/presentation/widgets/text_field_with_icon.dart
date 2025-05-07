import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class TextFieldWithIcon extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Widget iconButton;
  const TextFieldWithIcon(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.iconButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Palette.lightGreenBlue, Palette.darkGreenblue]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          suffixIcon: iconButton,
          labelText: labelText,
          labelStyle: TextStyle(color: Palette.textWhite),
          hintText: hintText,
          hintStyle: TextStyle(color: Palette.textWhite),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}
