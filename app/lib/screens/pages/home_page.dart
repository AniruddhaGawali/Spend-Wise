import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/data/constant_values.dart';
import 'package:spendwise/model/transaction.dart';

import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/add_transaction_screen.dart';
import 'package:spendwise/screens/setting_screen.dart';
import 'package:spendwise/utils/fetch_all_data.dart';

import 'package:spendwise/widgits/transaction_card.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchData(ref);
        },
        child: Padding(
            padding: const EdgeInsets.all(padding),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - padding * 2,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  header(context, ref),
                  const SizedBox(
                    height: 40,
                  ),
                  balanceCard(context, ref, transactions),
                  const SizedBox(
                    height: 20,
                  ),
                  filterChips(
                    context,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  pastTransactions(context, transactions),
                ],
              )),
            )),
      ),
    );
  }

  Widget header(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Home",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            Text(ref.read(userProvider.notifier).captalizeUsername(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
            Text(
              "Welcome back!",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SettingScreen();
            }));
          },
          icon: Icon(
            MdiIcons.accountCircleOutline,
            color: Theme.of(context).colorScheme.onBackground,
            size: 50,
          ),
        )
      ],
    );
  }

  Widget balanceCard(
    BuildContext context,
    WidgetRef ref,
    List<Transaction> transactions,
  ) {
    return SizedBox(
      height: 200,
      child: IntrinsicHeight(
        child: Row(
          children: [
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
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        "₹${ref.read(userProvider.notifier).getTotalBalance().toStringAsFixed(2)}",
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
                      "Total Expenses",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        "₹${ref.read(transactionProvider.notifier).totalExpenses().toStringAsFixed(2)}",
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
            Material(
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
                highlightColor: Theme.of(context).colorScheme.tertiaryContainer,
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
          ],
        ),
      ),
    );
  }

  Widget filterChips(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...TransactionCatergory.values
              .sublist(0, 5)
              .map((e) => Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddTransactionScreen(
                                      userSelectedCategory: e,
                                    )));
                      },
                      borderRadius: BorderRadius.circular(10),
                      splashColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          getTransactionCatergoryIcon(e),
                          color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        ),
                      ),
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }

  Widget pastTransactions(
      BuildContext context, List<Transaction> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("All Transactions",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )),
        const SizedBox(
          height: 20,
        ),
        ...transactions.reversed
            .map((e) => TransactionCard(transaction: e))
            .toList(),
      ],
    );
  }
}
