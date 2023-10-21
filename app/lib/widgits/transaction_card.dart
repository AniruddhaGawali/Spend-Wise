import 'package:flutter/material.dart';
import 'package:spendwise/model/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  String getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
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
              width: (MediaQuery.of(context).size.width - 40) * 0.65,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.06,
                    backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                    child: Icon(
                      getTransactionCatergoryIcon(transaction.category),
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: MediaQuery.of(context).size.width * 0.07,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
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
                          color: Theme.of(context).colorScheme.surfaceTint,
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
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
              width: (MediaQuery.of(context).size.width - 80) * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 80) * 0.4,
                    child: Text(
                      '₹${transaction.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: transaction.type == TransactionType.income
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                            fontSize: 16,
                          ),
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
    );
  }
}
