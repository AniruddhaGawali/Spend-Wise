import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/user.dart';

class UserNotifier extends Notifier<User> {
  @override
  build() {
    return User(id: "", username: "", accounts: []);
  }

  void set(User user) {
    state = user;
  }

  User get() => state;

  void addAccount(Account account) {
    state = User(
        id: state.id,
        username: state.username,
        accounts: [...state.accounts, account]);
  }

  void updateAccount(Account account) {
    state = User(
        id: state.id,
        username: state.username,
        accounts: state.accounts
            .map((e) => e.id == account.id
                ? Account(
                    id: e.id,
                    name: account.name,
                    type: account.type,
                    balance: account.balance)
                : e)
            .toList());
  }

  void removeAccount(Account account) {
    state = User(
        id: state.id,
        username: state.username,
        accounts: state.accounts
            .where((element) => element.id != account.id)
            .toList());
  }

  void addAmount(Account account, double amount) {
    state = User(
        id: state.id,
        username: state.username,
        accounts: state.accounts
            .map((e) => e.id == account.id
                ? Account(
                    id: e.id,
                    name: e.name,
                    type: e.type,
                    balance: e.balance + amount)
                : e)
            .toList());
  }

  void removeAmount(Account account, double amount) {
    state = User(
        id: state.id,
        username: state.username,
        accounts: state.accounts
            .map((e) => e.id == account.id
                ? Account(
                    id: e.id,
                    name: e.name,
                    type: e.type,
                    balance: e.balance - amount)
                : e)
            .toList());
  }

  void updateUser(User user) {
    state = user;
  }

  Account getAccountById(String id) {
    return state.accounts.firstWhere((element) => element.id == id);
  }

  String captalizeUsername() {
    return state.username[0].toUpperCase() + state.username.substring(1);
  }

  void logout() {
    state = User(id: "", username: "", accounts: []);
  }
}

final userProvider = NotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});
