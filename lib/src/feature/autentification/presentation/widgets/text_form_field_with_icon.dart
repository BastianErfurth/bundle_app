import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class TextFormFieldWithIcon extends StatefulWidget {
  const TextFormFieldWithIcon({
    super.key,
    required bool isObscured,
    required String labelText,
    required String hintText,
  }) : _isObscured = isObscured;

  final bool _isObscured;

  @override
  State<TextFormFieldWithIcon> createState() =>
      _TextFormFieldWithIconState(labelText: '', hintText: '');
}

class _TextFormFieldWithIconState extends State<TextFormFieldWithIcon> {
  final String labelText;
  final String hintText;
  bool _isObscured = true;

  _TextFormFieldWithIconState(
      {required this.labelText, required this.hintText});
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
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
              icon: Icon(widget._isObscured
                  ? Icons.visibility_off
                  : Icons.visibility)),
          labelText: labelText,
          labelStyle: TextStyle(color: Palette.textWhite),
          hintText: hintText,
          hintStyle: TextStyle(color: Palette.textWhite),
          suffixIconColor: Palette.textWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        obscureText: widget._isObscured,
      ),
    );
  }
}
