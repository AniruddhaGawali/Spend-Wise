// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/data/constant_values.dart';
import 'package:spendwise/widgits/cards/balance_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

//  Model:
import 'package:spendwise/model/transaction.dart';

//Provider:
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';

// Screens & Widgets
import 'package:spendwise/screens/edit_screens/edit_transactions/edit_transaction_screen.dart';
import 'package:spendwise/screens/static_screens/setting_screen.dart';
import 'package:spendwise/screens/static_screens/user_detail_screen.dart';

//  Utils:
import 'package:spendwise/utils/fetch_all_data.dart';
import 'package:spendwise/widgits/past_transaction.dart';

enum TransactionFilter {
  byMonth,
  byWeek,
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);

    final isVisibile = useState(false);
    final filter = useState(TransactionFilter.byMonth);
    final transactions = filter.value == TransactionFilter.byMonth
        ? ref.watch(transactionProvider.notifier).transactionsofMonth()
        : ref.watch(transactionProvider.notifier).transactionofWeek();

    useEffect(() {
      final preferences = snapshot.data;
      if (preferences == null) {
        return;
      }
      filter.value = preferences.getString('filter') == "week"
          ? TransactionFilter.byWeek
          : TransactionFilter.byMonth;
      return null;
    }, [snapshot.data]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          // User Detail Button
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const UserDetailScreen();
              }));
            },
            icon: Icon(
              MdiIcons.accountCircleOutline,
              color: Theme.of(context).colorScheme.onBackground,
              size: 25,
            ),
          ),

          // Setting Button
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingScreen();
                }));
              },
              icon: Icon(
                MdiIcons.cog,
                color: Theme.of(context).colorScheme.onBackground,
              ))
        ],
      ),
      body: RefreshIndicator(
        // refresh indicator
        onRefresh: () async {
          await fetchData(ref);
        },

        child: Padding(
            padding: const EdgeInsets.only(
              left: padding,
              right: padding,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context, ref),
                  const SizedBox(
                    height: 40,
                  ),
                  BalanceCards(
                    transactions: transactions,
                    isVisible: isVisibile,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _catergoryChips(
                    context,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  PastTransactions(transactions: transactions, filter: filter)
                ],
              )),
            )),
      ),

      // Floating Action Button for adding new transaction if the user is above button is not visible
      floatingActionButton: isVisibile.value
          ? FloatingActionButton.large(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddTransactionScreen();
                }));
              },
              child: Icon(
                MdiIcons.plus,
                size: 40,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            )
          : null,
    );
  }

  Widget _header(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ref.watch(userProvider.notifier).captalizeUsername(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
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
      ],
    );
  }

  Widget _catergoryChips(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...TransactionCatergory.values
              .sublist(0, 5)
              .map(
                (e) => Ink(
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
                    splashColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        getTransactionCatergoryIcon(e),
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
