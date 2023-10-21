import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/utils/get_date.dart';
import 'package:spendwise/widgits/transaction_card.dart';

class ViewAllTransactionScreen extends HookConsumerWidget {
  const ViewAllTransactionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider.notifier).getSorted();

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
              style: Theme.of(context).textTheme.titleMedium,
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
