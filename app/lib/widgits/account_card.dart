import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/provider/monetary_units.dart';

class AccountCard extends ConsumerWidget {
  final Account account;
  final void Function()? onClick;

  const AccountCard({
    Key? key,
    required this.account,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: account.type == AccountType.bank
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.tertiaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          account.name,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          softWrap: true,
                        ),
                      ),
                      Text(
                        account.type == AccountType.bank ? 'Bank' : 'Cash',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    account.type == AccountType.bank
                        ? MdiIcons.bank
                        : MdiIcons.cash,
                    color: account.type == AccountType.bank
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.tertiary,
                    size: 30,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '${ref.read(monetaryUnitProvider.notifier).get()} ${account.balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
