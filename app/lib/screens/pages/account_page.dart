import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/provider/user_provider.dart';

class AllAccountsScreen extends ConsumerWidget {
  const AllAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(userProvider).accounts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Accounts',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (BuildContext context, int index) {
          final account = accounts[index];
          return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                  decoration: BoxDecoration(
                    color: account.type == AccountType.bank
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            getAccountTypeIcon(account.type),
                            color: account.type == AccountType.bank
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                            size: 30,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            account.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            account.type.name.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '\$${account.balance.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  )));
        },
      ),
    );
  }
}
