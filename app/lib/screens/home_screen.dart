import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/transaction.dart';

import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/add_transaction_screen.dart';
import 'package:spendwise/screens/setting_screen.dart';

import 'package:spendwise/widgits/action_chip.dart';
import 'package:spendwise/widgits/transaction_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 40,
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
                balanceCard(context, ref),
                const SizedBox(
                  height: 20,
                ),
                filterChips(),
                const SizedBox(
                  height: 40,
                ),
                pastTransactions(context, ref),
              ],
            )),
          )),
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
  ) {
    return IntrinsicHeight(
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
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
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
            ]),
          ),
          const Spacer(),
          Material(
            color:
                Theme.of(context).colorScheme.tertiaryContainer.withOpacity(.8),
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddTransactionScreen();
                }));
              },
              borderRadius: BorderRadius.circular(30),
              splashColor: Theme.of(context).colorScheme.tertiaryContainer,
              highlightColor: Theme.of(context).colorScheme.tertiaryContainer,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                width: (MediaQuery.of(context).size.width - 20) * .3,
                height: double.infinity,
                // decoration: BoxDecoration(
                //   color: Theme.of(context).colorScheme.tertiaryContainer,
                //   borderRadius: BorderRadius.circular(30),
                // ),
                // alignment: Alignment.center,
                child: Icon(MdiIcons.plus,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChips() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: [
          ...TransactionCatergory.values
              .sublist(0, 6)
              .map(
                (e) => CustomActionChip(
                  label: e.name[0].toUpperCase() +
                      e.name.substring(1).toLowerCase(),
                  icon: getTransactionCatergoryIcon(e),
                  selected: true,
                ),
              )
              .toList()
        ],
      ),
    );
  }

  Widget pastTransactions(BuildContext context, WidgetRef ref) {
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
        ...ref
            .watch(transactionProvider.notifier)
            .get()
            .reversed
            .map((e) => TransactionCard(transaction: e))
            .toList(),
      ],
    );
  }
}
