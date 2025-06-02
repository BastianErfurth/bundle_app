import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class TextFormFieldWithoutIcon extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const TextFormFieldWithoutIcon({
    super.key,
    required this.labelText,
    required this.hintText,
    this.validator,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        TextFormField(
          controller: TextEditingController(),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: labelText,
            isDense: true,
            labelStyle: TextStyle(color: Palette.textWhite),
            hintText: hintText,
            hintStyle: TextStyle(color: Palette.textWhite),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
