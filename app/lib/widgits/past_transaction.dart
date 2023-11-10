// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

//  Model & Provider:
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/monetary_units.dart';
import 'package:spendwise/provider/transaction_provider.dart';

// Screens & Widgets
import 'package:spendwise/screens/pages/home_page.dart';
import 'package:spendwise/screens/view_all_transaction_screen.dart';
import 'package:spendwise/widgits/cards/transaction_card.dart';

// ignore: must_be_immutable
class PastTransactions extends ConsumerWidget {
  List<Transaction> transactions;
  ValueNotifier<TransactionFilter> filter;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  PastTransactions({
    super.key,
    required this.transactions,
    required this.filter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setFilter(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Text(
                        filter.value == TransactionFilter.byMonth
                            ? "All Transactions of Month"
                            : "All Transactions of Week",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        MdiIcons.unfoldMoreHorizontal,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "${ref.watch(monetaryUnitProvider.notifier).get()}${getTotalExpenses().abs().toStringAsFixed(2)}",
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: getTotalExpenses() >= 0
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        transactions.isNotEmpty
            ? Column(
                children: [
                  ...transactions
                      .map((e) => TransactionCard(transaction: e))
                      .toList(),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: FilledButton.tonal(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewAllTransactionScreen(
                            title: "All Transactions",
                            transactions: ref
                                .read(transactionProvider.notifier)
                                .getSorted(),
                          );
                        }));
                      },
                      child: Text(
                        "View All",
                        softWrap: false,
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  )
                ],
              )
            : Text(
                "No Transactions",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
              ),
        const SizedBox(
          height: 80,
        )
      ],
    );
  }

  double getTotalExpenses() {
    double total = 0;
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.transfer) continue;

      if (transaction.type == TransactionType.expense) {
        total -= transaction.amount;
      } else {
        total += transaction.amount;
      }
    }

    return total;
  }

  void setFilter(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10),
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("Transactions of Month",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          )),
                  onTap: () async {
                    filter.value = TransactionFilter.byMonth;
                    final SharedPreferences prefs = await _prefs;
                    prefs.setString("filter", "month");
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    "Transactions of Week",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onTap: () async {
                    filter.value = TransactionFilter.byWeek;
                    final SharedPreferences prefs = await _prefs;
                    prefs.setString("filter", "week");
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
