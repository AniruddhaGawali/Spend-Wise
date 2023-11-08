// Flutter Packages
import 'package:flutter/material.dart';

// Packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//  Model & Provider:
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';

// Screens & Widgets
import 'package:spendwise/screens/edit_screens/edit_account/edit_acccount_screen.dart';
import 'package:spendwise/screens/edit_screens/update_account_screen.dart';
import 'package:spendwise/screens/view_all_transaction_screen.dart';
import 'package:spendwise/widgits/cards/account_card.dart';

class AllAccountsScreen extends ConsumerWidget {
  const AllAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(userProvider).accounts;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Accounts',
          ),
          actions: [
            accounts.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const EditAccounts();
                      }));
                    },
                    icon: Icon(
                      MdiIcons.squareEditOutline,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
        body: accounts.isNotEmpty
            ? ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (BuildContext context, int index) {
                  final account = accounts[index];
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: AccountCard(
                        account: account,
                        onClick: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewAllTransactionScreen(
                              transactions: ref
                                  .watch(transactionProvider.notifier)
                                  .getSorted()
                                  .where((element) =>
                                      element.fromAccount.id == account.id)
                                  .toList(),
                              title: account.name,
                            );
                          }));
                        },
                      ));
                },
              )
            : Center(
                child: Text(
                  'No Accounts',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),

        // Floating Action Button to add new account
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddAccountScreen();
            }));
          },
          child: Icon(
            Icons.add,
            size: 40,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ));
  }
}
