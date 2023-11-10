// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:hooks_riverpod/hooks_riverpod.dart';

//Models
import 'package:spendwise/model/transaction.dart';

// Provider
import 'package:spendwise/provider/monetary_units.dart';

// utils
import 'package:spendwise/utils/get_date.dart';

// Widgits & Screens
import 'package:spendwise/widgits/cards/transaction_card.dart';

// ignore: must_be_immutable
class ViewAllTransactionScreen extends HookConsumerWidget {
  List<Transaction> transactions;
  String title;

  ViewAllTransactionScreen({
    super.key,
    required this.transactions,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: getTransactionList(context, ref),
        ),
      ),
    );
  }

  // Get the total balance of a month
  double getMonthTotal(int month, int year) {
    double total = 0;
    for (final transaction in transactions) {
      if (transaction.date.month == month && transaction.date.year == year) {
        if (transaction.type == TransactionType.transfer) continue;

        if (transaction.type == TransactionType.expense) {
          total -= transaction.amount;
        } else {
          total += transaction.amount;
        }
      }
    }
    return total;
  }

  // Get the list of transactions with titles
  List<Widget> getTransactionList(BuildContext context, WidgetRef ref) {
    // list of transactions with titles
    List<Widget> transactionListWithTitles = [];

    String currentMonthYear = ''; // To keep track of the current month and year

    for (final transaction in transactions) {
      final transactionMonthYear =
          '${transaction.date.month}/${transaction.date.year}';

      // Check if the month and year of the current transaction are different
      if (transactionMonthYear != currentMonthYear) {
        currentMonthYear = transactionMonthYear;

        final double monthExpence =
            getMonthTotal(transaction.date.month, transaction.date.year);

        // Add a title with the new month and year
        transactionListWithTitles.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.only(
              bottom: 15,
              top: transactions.indexOf(transaction) == 0 ? 0 : 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${getFullMonth(transaction.date.month)} ${transaction.date.year}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${ref.watch(monetaryUnitProvider.notifier).get()}${monthExpence.abs().toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: monthExpence >= 0
                            ? Colors.green
                            : Theme.of(context).colorScheme.error,
                      ),
                )
              ],
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
    return transactionListWithTitles;
  }
}
