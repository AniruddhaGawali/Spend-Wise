import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/monetary_units.dart';
import 'package:spendwise/screens/edit_screens/edit_transactions/edit_transaction_screen.dart';
import 'package:spendwise/utils/get_date.dart';

class TransactionCard extends ConsumerWidget {
  final Transaction transaction;

  const TransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTransactionScreen(
              editTransaction: transaction,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 40) * 0.6,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceTint,
                      child: Icon(
                        transaction.type == TransactionType.transfer
                            ? MdiIcons.swapHorizontal
                            : getTransactionCatergoryIcon(transaction.category),
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 25,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.39,
                          child: Text(
                            transaction.title,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 3.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            transaction.category.name[0].toUpperCase() +
                                transaction.category.name
                                    .substring(1)
                                    .toLowerCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontSize: 10,
                                ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 80) * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 80) * 0.45,
                      child: Text(
                        '${ref.read(monetaryUnitProvider.notifier).get()}${transaction.amount.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: transaction.type == TransactionType.income
                                  ? Colors.green
                                  : transaction.type == TransactionType.expense
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                        softWrap: false,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Text(
                      '${transaction.date.day} ${getMonth(transaction.date.month)} ${transaction.date.year}, ${transaction.date.hour}:${transaction.date.minute}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
