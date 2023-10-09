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

  void addAccount(Account account) {
    state.accounts.add(account);
  }

  void removeAccount(Account account) {
    state.accounts.remove(account);
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

  double getTotalBalance() {
    double total = 0;
    for (var account in state.accounts) {
      total += account.balance;
    }
    return total;
  }
}

final userProvider = NotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});
