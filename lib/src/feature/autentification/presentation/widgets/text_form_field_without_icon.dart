import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWithoutIcon extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<String> autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  const TextFormFieldWithoutIcon({
    super.key,
    required this.labelText,
    required this.hintText,
    this.validator,
    required this.controller,
    this.keyboardType,
    required this.autofillHints,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: keyboardType,
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
