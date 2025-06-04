import 'package:bundle_app/src/feature/contracts/domain/contract_category.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';

class DropDownSelectField extends StatelessWidget {
  const DropDownSelectField({super.key});

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
            child: DropdownMenu(
              width: double.infinity,
              label: Text(
                "Kategorie wählen",
                style: TextStyle(color: Palette.textWhite),
              ),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStateProperty.all(Palette.darkGreenblue),
                maximumSize: WidgetStateProperty.all(Size(350, 200)),

                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              textStyle: TextStyle(color: Palette.textWhite),

              dropdownMenuEntries: ContractCategory.values
                  .map(
                    (category) => DropdownMenuEntry(
                      value: category,
                      label: category.label,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
