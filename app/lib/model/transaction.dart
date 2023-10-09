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
  gifts,
  medical,
  subscriptions,
  clothing,
  investments,
  travel,
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
    case TransactionCatergory.other:
      return Icons.more_horiz;
  }
}

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final Account account;
  final TransactionType type;
  final TransactionCatergory category;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.account,
    required this.type,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json, WidgetRef ref) {
    Account account =
        ref.read(userProvider.notifier).getAccountById(json["accountId"]);

    final category = TransactionCatergory.values.firstWhere((element) =>
        element.toString().split(".").last == json["category"].toString());

    return Transaction(
      id: json["_id"],
      title: json["title"],
      amount: double.parse(json["amount"].toString()),
      account: account,
      type: json["type"] == "income"
          ? TransactionType.income
          : TransactionType.expense,
      category: category,
      date: DateTime.parse(json["updatedAt"].toString()),
    );
  }
}
