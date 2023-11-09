// Flutter imports:
import 'dart:convert';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

// Model and Provider imports:
import 'package:spendwise/model/account.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';

Future<bool> createAccount(
  String name,
  double balance,
  AccountType type,
  WidgetRef ref,
  ValueNotifier<bool> isLoading,
) async {
  isLoading.value = true;

  final account = Account(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: name,
    balance: balance,
    type: type,
  );

  final url = "${dotenv.env['API_URL']}/account/add-account";

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}",
    },
    body: account.toJson(),
  );

  isLoading.value = false;
  if (response.statusCode == 201) {
    ref
        .read(userProvider.notifier)
        .addAccount(Account.fromJson(jsonDecode(response.body)['account']));
    return true;
  } else {
    return false;
  }
}

Future<bool> updateAccount(
  Account oldAccount,
  String name,
  double balance,
  AccountType type,
  WidgetRef ref,
  ValueNotifier<bool> isLoading,
) async {
  isLoading.value = true;
  final account =
      Account(id: oldAccount.id, name: name, balance: balance, type: type);
  final url = "${dotenv.env['API_URL']}/account/update/${oldAccount.id}";

  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}",
    },
    body: account.toJson(),
  );
  isLoading.value = false;

  if (response.statusCode == 201) {
    Map body = jsonDecode(response.body);

    ref
        .read(userProvider.notifier)
        .updateAccount(Account.fromJson(body['account']));

    return true;
  } else {
    return false;
  }
}

Future<bool> deleteAccount(WidgetRef ref, Account? account) async {
  final url = "${dotenv.env['API_URL']}/account/delete/${account!.id}";

  final response = await http.delete(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}",
    },
  );

  if (response.statusCode == 201) {
    ref.read(transactionProvider.notifier).removeTransactionOfAccount(account);
    ref.read(userProvider.notifier).removeAccount(account);
    return true;
  } else {
    return false;
  }
}
