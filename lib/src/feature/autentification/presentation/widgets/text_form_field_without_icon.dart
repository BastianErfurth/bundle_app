import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class TextFormFieldWithoutIcon extends StatelessWidget {
  final String labelText;
  final String hintText;
  const TextFormFieldWithoutIcon({
    super.key,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Palette.lightGreenBlue, Palette.darkGreenblue]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        decoration: InputDecoration(
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
