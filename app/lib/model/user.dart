import 'package:spendwise/model/account.dart';

class User {
  final String id;
  final String username;
  final List<Account> accounts;

  User({required this.id, required this.username, required this.accounts});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      accounts: json['accounts'],
    );
  }

  addAccount(Account account) {
    accounts.add(account);
  }

  removeAccount(Account account) {
    accounts.remove(account);
  }
}
