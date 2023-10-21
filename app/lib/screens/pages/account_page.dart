import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/add_account_screen.dart';
import 'package:spendwise/widgits/account_card.dart';

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
        ),
        body: ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            final account = accounts[index];
            return Padding(
                padding: const EdgeInsets.all(8),
                child: AccountCard(
                  account: account,
                ));
          },
        ),
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
