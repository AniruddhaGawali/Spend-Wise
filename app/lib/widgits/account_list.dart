import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/widgits/action_chip.dart';

// ignore: must_be_immutable
class AccountList extends ConsumerWidget {
  ValueNotifier<Account> selectedAccount;
  List<Account> accounts;

  AccountList(
      {super.key, required this.selectedAccount, required this.accounts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          ...accounts
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CustomActionChip(
                    label: e.name,
                    icon: e.type == AccountType.cash
                        ? MdiIcons.cashMultiple
                        : MdiIcons.bank,
                    selected: selectedAccount.value == e,
                    onPressed: () {
                      selectedAccount.value = e;
                    },
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
