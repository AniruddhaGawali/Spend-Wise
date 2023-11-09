//Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

//  Model & Provider:
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/monetary_units.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';

// Screens & Widgets
import 'package:spendwise/screens/edit_screens/edit_transactions/edit_transaction_screen.dart';

// ignore: must_be_immutable
class BalanceCards extends ConsumerWidget {
  final List<Transaction> transactions;
  final ValueNotifier<bool> isVisible;

  const BalanceCards({
    super.key,
    required this.transactions,
    required this.isVisible,
  });

  double getTotalBalance(WidgetRef ref) {
    double total = 0;
    for (var account in ref.watch(userProvider).accounts) {
      total += account.balance;
    }
    return total;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalance = getTotalBalance(ref);

    return SizedBox(
      height: 200,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // card to show total balance and total expenses of month
            Container(
              width: (MediaQuery.of(context).size.width - 20) * .6,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(.8),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Balance",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        "${ref.watch(monetaryUnitProvider.notifier).get()} ${totalBalance.toStringAsFixed(2)}",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Total Expenses of Month",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: Text(
                        "${ref.watch(monetaryUnitProvider.notifier).get()}${ref.watch(transactionProvider.notifier).totalExpensesByMonth(DateTime.now().month, DateTime.now().year).abs().toStringAsFixed(2)}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ]),
            ),

            const Spacer(),

            // button to add transaction
            VisibilityDetector(
              key: const Key("add_transaction_button"),
              // it takes a key to identify the widget is visible or not
              onVisibilityChanged: (visibilityInfo) {
                double visiblePercentage = visibilityInfo.visibleFraction * 100;
                if (visiblePercentage > 60) {
                  isVisible.value = false;
                } else {
                  isVisible.value = true;
                }
              },
              child: Material(
                color: Theme.of(context)
                    .colorScheme
                    .tertiaryContainer
                    .withOpacity(.8),
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTransactionScreen()));
                  },
                  borderRadius: BorderRadius.circular(30),
                  splashColor: Theme.of(context).colorScheme.tertiaryContainer,
                  highlightColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: (MediaQuery.of(context).size.width - 20) * .35,
                    height: double.infinity,
                    child: Icon(MdiIcons.plus,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
