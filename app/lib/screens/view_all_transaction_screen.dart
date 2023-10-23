import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/utils/get_date.dart';
import 'package:spendwise/widgits/transaction_card.dart';

// ignore: must_be_immutable
class ViewAllTransactionScreen extends HookConsumerWidget {
  List<Transaction> transactions;

  ViewAllTransactionScreen({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a list to store the modified list of transactions with titles
    List<Widget> transactionListWithTitles = [];

    String currentMonthYear = ''; // To keep track of the current month and year

    for (final transaction in transactions) {
      final transactionMonthYear =
          '${transaction.date.month}/${transaction.date.year}';

      // Check if the month and year of the current transaction are different
      if (transactionMonthYear != currentMonthYear) {
        currentMonthYear = transactionMonthYear;
        // Add a title with the new month and year
        transactionListWithTitles.add(
          ListTile(
            title: Text(
              '${getFullMonth(transaction.date.month)} ${transaction.date.year}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      // Add the transaction card
      transactionListWithTitles.add(
        TransactionCard(
          transaction: transaction,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
      ),
      body: ListView(
        children: transactionListWithTitles,
      ),
    );
  }
}
