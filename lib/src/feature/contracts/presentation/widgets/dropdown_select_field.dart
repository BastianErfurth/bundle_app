import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class DropDownSelectField<T> extends StatelessWidget {
  final List<T> values;
  final String Function(T) itemLabel;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;
  final String labelText;

  const DropDownSelectField({
    Key? key,
    required this.values,
    required this.itemLabel,
    this.selectedValue,
    this.onChanged,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Palette.lightGreenBlue, Palette.darkGreenblue],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: DropdownMenu<T>(
              width: double.infinity,
              initialSelection: selectedValue,
              label: Text(
                labelText,
                style: TextStyle(color: Palette.textWhite),
              ),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStateProperty.all(Palette.darkGreenblue),
                maximumSize: WidgetStateProperty.all(const Size(350, 200)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              dropdownMenuEntries: values
                  .map(
                    (item) => DropdownMenuEntry<T>(
                      value: item,
                      label: itemLabel(item),
                    ),
                  )
                  .toList(),
              onSelected: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
