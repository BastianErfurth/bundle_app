import 'package:bundle_app/src/feature/contracts/domain/contract.dart';
import 'package:bundle_app/src/feature/contracts/presentation/widgets/contract_attributes.dart';
import 'package:flutter/material.dart';

class ContractListContainer extends StatelessWidget {
  const ContractListContainer({
    super.key,
    required this.contract,
  });

  final Contract contract;

  @override
  Widget build(BuildContext context) {
    return ContractAttributes(
      textTopic: contract.keyword,
      iconButton: IconButton(
        onPressed: () {},
        icon: Row(
          children: [
            Icon(Icons.visibility),
            Icon(Icons.delete),
          ],
        ),
      ),
    );
  }
}
