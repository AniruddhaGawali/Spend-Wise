import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:spendwise/model/user.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';

Future<bool> fetchData(WidgetRef ref) async {
  // Fetch data from API or database
  final url = "${dotenv.env['API_URL']}/all-data";

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}",
    },
  );

  if (response.statusCode == 200) {
    try {
      final body = jsonDecode(response.body);

      final user = body["user"];
      final accounts = body["accounts"];
      final transaction = body["transactions"];

      ref
          .read(userProvider.notifier)
          .set(User(accounts: [], id: user["_id"], username: user["username"]));

      for (var element in accounts) {
        Account account = Account.fromJson(element);
        ref.read(userProvider.notifier).addAccount(account);
      }

      List<Transaction> transactions = [];

      for (var element in transaction) {
        Transaction transaction = Transaction.fromJson(element, ref);
        transactions.add(transaction);
      }

      ref.read(transactionProvider.notifier).set(transactions);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Failed to fetch data. Status code: ${response.statusCode}');
  }
}

Future<bool> fetchTransaction(WidgetRef ref) async {
  final url = "${dotenv.env['API_URL']}/all-data/transactions";

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}",
    },
  );

  if (response.statusCode == 200) {
    try {
      final body = jsonDecode(response.body);
      // print(body);
      final transaction = body;

      List<Transaction> transactions = [];

      for (var element in transaction) {
        Transaction transaction = Transaction.fromJson(element, ref);
        transactions.add(transaction);
      }

      ref.read(transactionProvider.notifier).set(transactions);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  return false;
}
