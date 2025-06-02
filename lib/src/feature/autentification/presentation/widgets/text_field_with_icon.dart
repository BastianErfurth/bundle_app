import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class TextFieldWithIcon extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Widget iconButton;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const TextFieldWithIcon({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.iconButton,
    required this.obscureText,
    this.validator,
    required this.controller,
  });

  @override
  State<TextFieldWithIcon> createState() => _TextFieldWithIconState();
}

class _TextFieldWithIconState extends State<TextFieldWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 55,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            suffixIcon: widget.iconButton,
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Palette.textWhite),
            hintText: widget.hintText,
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
