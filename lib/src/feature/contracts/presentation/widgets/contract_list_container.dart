// ignore_for_file: use_build_context_synchronously

import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:bundle_app/src/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:bundle_app/src/feature/contracts/presentation/view_contract_screen.dart';

class ContractListContainer extends StatefulWidget {
  final void Function()? onDelete;

  const ContractListContainer({
    super.key,
    required this.contract,
    required this.db,
    this.onDelete,
  });

  final Contract contract;
  final dynamic db; // Replace 'dynamic' with the actual type of db if known

  @override
  State<ContractListContainer> createState() => _ContractListContainerState();
}

class _ContractListContainerState extends State<ContractListContainer> {
  @override
  Widget build(BuildContext context) {
    return ContractAttributes(
      textTopic: widget.contract.keyword,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewContractScreen(
                    contractNumber: widget.contract.contractNumber,
                  ),
                ),
              );
            },
            icon: Icon(Icons.visibility),
          ),
          IconButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Vertrag löschen"),
                  content: Text("Möchtest du diesen Vertrag wirklich löschen?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Abbrechen"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        "Löschen",
                        style: TextStyle(color: Palette.lightGreenBlue),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await widget.db.deleteContract(widget.contract.contractNumber);

                // Optional: Zeige Bestätigung
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Vertrag gelöscht")));
              }
            },
            icon: Icon(Icons.delete, color: Palette.lightGreenBlue),
          ),
        ],
      ),
    );
  }
}
