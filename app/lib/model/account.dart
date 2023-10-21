import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum AccountType {
  bank,
  cash,
}

IconData getAccountTypeIcon(AccountType type) {
  switch (type) {
    case AccountType.bank:
      return MdiIcons.bankOutline;
    case AccountType.cash:
      return MdiIcons.cash;
  }
}

class Account {
  final String id;
  final String name;
  final AccountType type;
  final double balance;

  Account(
      {required this.id,
      required this.name,
      required this.type,
      required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['_id'],
      name: json['name'],
      type: json['type'] == 'bank' ? AccountType.bank : AccountType.cash,
      balance: double.parse(json['balance'].toString()),
    );
  }

  String toJson() => jsonEncode({
        'name': name,
        'type': type.name.toString(),
        'balance': balance,
      });
}
