import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';

import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';

setTransaction(
  WidgetRef ref,
  Transaction transaction,
  Transaction? editTransaction,
) {
  if (editTransaction != null) {
    ref.read(transactionProvider.notifier).removeTransaction(editTransaction);
  }
  ref.read(transactionProvider.notifier).addTransaction(transaction);

  final account = ref
      .read(userProvider)
      .accounts
      .firstWhere((element) => element.id == transaction.fromAccount.id);

  if (editTransaction != null &&
      editTransaction.fromAccount.id != transaction.fromAccount.id) {
    final oldAccount = ref
        .read(userProvider)
        .accounts
        .firstWhere((element) => element.id == editTransaction.fromAccount.id);

    if (editTransaction.type == TransactionType.expense) {
      ref
          .read(userProvider.notifier)
          .addAmount(oldAccount, editTransaction.amount);
    } else {
      ref
          .read(userProvider.notifier)
          .removeAmount(oldAccount, editTransaction.amount);
    }
  }

  if (transaction.type == TransactionType.expense) {
    if (editTransaction != null) {
      ref
          .read(userProvider.notifier)
          .addAmount(account, editTransaction.amount);
    }
    ref.read(userProvider.notifier).removeAmount(account, transaction.amount);
  } else {
    if (editTransaction != null) {
      ref
          .read(userProvider.notifier)
          .removeAmount(account, editTransaction.amount);
    }
    ref.read(userProvider.notifier).addAmount(account, transaction.amount);
  }
}

addUpdateTransaction(
  WidgetRef ref,
  BuildContext context,
  ValueNotifier<String> title,
  ValueNotifier<double> amount,
  ValueNotifier<DateTime> date,
  ValueNotifier<TimeOfDay> time,
  ValueNotifier<TransactionCatergory> selectedCategory,
  ValueNotifier<Account> selectedAccount,
  ValueNotifier<TransactionType> selectedTransactionType,
  ValueNotifier<bool> isLoading,
  GlobalKey<FormState> formKey,
  Transaction? editTransaction,
) async {
  if (!formKey.currentState!.validate()) {
    return;
  }
  isLoading.value = true;
  String url = editTransaction == null
      ? "${dotenv.env['API_URL']}/transaction/add"
      : "${dotenv.env['API_URL']}/transaction/update/${editTransaction.id}";

  final createTransaction = {
    "title": title.value,
    "accountId": selectedAccount.value.id,
    "type": selectedTransactionType.value.name,
    "amount": amount.value,
    "category": selectedCategory.value.name,
    "date": DateTime(date.value.year, date.value.month, date.value.day,
            time.value.hour, time.value.minute)
        .toUtc()
        .toString()
  };

  http.Response response;
  if (editTransaction == null) {
    response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
      },
      body: jsonEncode(createTransaction),
    );
  } else {
    response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
      },
      body: jsonEncode(createTransaction),
    );
  }

  if (response.statusCode == 201) {
    // await fetchTransaction(ref);
    final body = jsonDecode(response.body);
    final transaction = Transaction.fromJson(body as Map<String, dynamic>, ref);

    await setTransaction(ref, transaction, editTransaction);

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              editTransaction == null
                  ? "Transaction added successfully!"
                  : "Transaction updated successfully!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        ),
      );

      Navigator.pop(context, true);
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              editTransaction == null
                  ? "Transaction addition failed!"
                  : "Transaction updation failed!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }
  isLoading.value = false;
}

Future<void> createUpdateTransafer(
  WidgetRef ref,
  BuildContext context,
  ValueNotifier<String> title,
  ValueNotifier<double> amount,
  ValueNotifier<DateTime> date,
  ValueNotifier<TimeOfDay> time,
  ValueNotifier<TransactionCatergory> selectedCategory,
  ValueNotifier<Account> selectedFromAccount,
  ValueNotifier<Account> selectedToAccount,
  ValueNotifier<TransactionType> selectedTransactionType,
  ValueNotifier<bool> isLoading,
  GlobalKey<FormState> formKey,
  Transaction? editTransaction,
) async {
  if (!formKey.currentState!.validate()) {
    return;
  }

  if (selectedToAccount.value == selectedFromAccount.value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please select valid tranfer to account",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                )),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
    );
    return;
  }

  isLoading.value = true;
  String url = editTransaction == null
      ? "${dotenv.env['API_URL']}/transaction/transfer"
      : "${dotenv.env['API_URL']}/transaction/transfer/${editTransaction.id}";

  final createTransaction = {
    "title": title.value,
    "accountId": selectedFromAccount.value.id,
    "toAccountId": selectedToAccount.value.id,
    "type": selectedTransactionType.value.name,
    "amount": amount.value,
    "category": selectedCategory.value.name,
    "userId": ref.read(userProvider).id,
    "date": DateTime(date.value.year, date.value.month, date.value.day,
            time.value.hour, time.value.minute)
        .toUtc()
        .toString()
  };

  http.Response response;

  if (editTransaction == null) {
    response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
      },
      body: jsonEncode(createTransaction),
    );
  } else {
    response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
      },
      body: jsonEncode(createTransaction),
    );
  }
  final body = jsonDecode(response.body);

  if (response.statusCode == 201) {
    final newTransaction = Transaction.fromJson(
        body['newTransaction'] as Map<String, dynamic>, ref);
    ref.read(transactionProvider.notifier).addTransaction(newTransaction);

    ref
        .read(userProvider.notifier)
        .removeAmount(selectedFromAccount.value, newTransaction.amount);

    ref
        .read(userProvider.notifier)
        .addAmount(selectedToAccount.value, newTransaction.amount);

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              editTransaction == null
                  ? "Transfer successfully!"
                  : "Transfer updated successfully!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        ),
      );

      Navigator.pop(context, true);
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              editTransaction == null
                  ? "Transfer failed!"
                  : "Transfer updation failed!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

  isLoading.value = false;
}

Future<bool> deleteTrasaction(
  WidgetRef ref,
  BuildContext context,
  Transaction? editTransaction,
) async {
  String url =
      "${dotenv.env['API_URL']}/transaction/delete/${editTransaction!.id}";

  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
    },
  );

  if (response.statusCode == 200) {
    ref.read(transactionProvider.notifier).removeTransaction(editTransaction);

    final account = ref
        .read(userProvider)
        .accounts
        .firstWhere((element) => element.id == editTransaction.fromAccount.id);

    if (editTransaction.type == TransactionType.expense) {
      ref
          .read(userProvider.notifier)
          .addAmount(account, editTransaction.amount);
    } else {
      ref
          .read(userProvider.notifier)
          .removeAmount(account, editTransaction.amount);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transaction deleted successfully!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        ),
      );
    }
    return true;
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transaction deletion failed!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
    return false;
  }
}

Future<bool> deleteTransfer(
  WidgetRef ref,
  BuildContext context,
  Transaction? editTransaction,
) async {
  String url =
      "${dotenv.env['API_URL']}/transaction/deleteTransfer/${editTransaction!.id}";

  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
    },
  );

  if (response.statusCode == 200) {
    ref.read(transactionProvider.notifier).removeTransaction(editTransaction);

    final fromAccount = ref
        .read(userProvider)
        .accounts
        .firstWhere((element) => element.id == editTransaction.fromAccount.id);

    final toAccount = ref
        .read(userProvider)
        .accounts
        .firstWhere((element) => element.id == editTransaction.toAccount!.id);

    ref
        .read(userProvider.notifier)
        .addAmount(fromAccount, editTransaction.amount);

    ref
        .read(userProvider.notifier)
        .removeAmount(toAccount, editTransaction.amount);

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transfer deleted successfully!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        ),
      );
    }
    return true;
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transfer deletion failed!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  )),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
    return false;
  }
}
