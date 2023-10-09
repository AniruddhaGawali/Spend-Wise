import 'dart:convert';

import 'package:spendwise/model/account.dart';

class User {
  final String id;
  final String username;
  final String password;
  final List<Account> accounts;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.accounts});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
      accounts: json['accounts'],
    );
  }

  String toJson() => jsonEncode({
        'id': id,
        'name': username,
        'email': username,
        'password': password,
        'accounts': accounts,
      });

  addAccount(Account account) {
    accounts.add(account);
  }

  removeAccount(Account account) {
    accounts.remove(account);
  }
}
