import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/user.dart';

class UserNotifier extends Notifier<User> {
  @override
  build() {
    return User(id: "", username: "", password: "", accounts: []);
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
}

final userProvider = NotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});
