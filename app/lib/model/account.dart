import 'dart:convert';

enum AccountType {
  bank,
  cash,
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
