import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/provider/user_provider.dart';

enum TransactionCatergory {
  food,
  transport,
  entertainment,
  education,
  medical,
  gifts,
  subscriptions,
  clothing,
  investments,
  travel,
  account,
  other
}

IconData getTransactionCatergoryIcon(TransactionCatergory catergory) {
  switch (catergory) {
    case TransactionCatergory.food:
      return MdiIcons.food;
    case TransactionCatergory.transport:
      return MdiIcons.trainCar;
    case TransactionCatergory.entertainment:
      return Icons.movie;
    case TransactionCatergory.education:
      return Icons.school;
    case TransactionCatergory.gifts:
      return MdiIcons.gift;
    case TransactionCatergory.medical:
      return MdiIcons.medicalBag;
    case TransactionCatergory.subscriptions:
      return Icons.subscriptions;
    case TransactionCatergory.clothing:
      return MdiIcons.hanger;
    case TransactionCatergory.investments:
      return MdiIcons.cash;
    case TransactionCatergory.travel:
      return Icons.flight;
    case TransactionCatergory.account:
      return Icons.account_balance;
    case TransactionCatergory.other:
      return Icons.more_horiz;
  }
}

enum TransactionType { transfer, income, expense }

getTransactionType(String type) {
  if (type == "income") {
    return TransactionType.income;
  }
  if (type == "expense") {
    return TransactionType.expense;
  }
  return TransactionType.transfer;
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final Account fromAccount;
  final Account? toAccount;
  final TransactionType type;
  final TransactionCatergory category;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.fromAccount,
    this.toAccount,
    required this.type,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json, WidgetRef ref) {
    Account fromAccount =
        ref.read(userProvider.notifier).getAccountById(json["accountId"]);

    Account? toAccount = json["toAccountId"] != null
        ? ref.read(userProvider.notifier).getAccountById(json["toAccountId"])
        : null;

    final category = TransactionCatergory.values.firstWhere((element) =>
        element.toString().split(".").last == json["category"].toString());

    return Transaction(
      id: json["_id"],
      title: json["title"],
      amount: double.parse(json["amount"].toString()),
      fromAccount: fromAccount,
      toAccount: toAccount,
      type: json["type"] == "income"
          ? TransactionType.income
          : json["type"] == "expense"
              ? TransactionType.expense
              : TransactionType.transfer,
      category: category,
      date: DateTime.parse(json["date"]).toLocal(),
    );
  }

  toJson() {
    return {
      "_id": id,
      "title": title,
      "amount": amount,
      "accountId": fromAccount.id,
      "toAccountId": toAccount != null ? toAccount!.id : null,
      "type": type.toString().split(".").last,
      "category": category.toString().split(".").last,
      "date": date.toUtc().toIso8601String(),
    };
  }
}
