import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]);

  List<Transaction> get() => state;
  List<Transaction> getSorted() => sortByDate(state);

  void set(List<Transaction> transactions) {
    state = transactions;
  }

  void addTransaction(Transaction transaction) {
    state = [...state, transaction];
  }

  void removeTransaction(Transaction transaction) {
    state = state.where((element) => element.id != transaction.id).toList();
  }

  void removeTransactionOfAccount(Account account) {
    state =
        state.where((element) => element.fromAccount.id != account.id).toList();
  }

  List<Transaction> transactionsofMonth() {
    return sortByDate(state
        .where((element) =>
            element.date.month == DateTime.now().month &&
            element.date.year == DateTime.now().year)
        .toList());
  }

  List<Transaction> transactionofWeek() {
    return sortByDate(state
        .where((element) => element.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList());
  }

  double totalExpensesByMonth(int month, int year) {
    double total = 0;
    for (var transaction in state) {
      if (transaction.type == TransactionType.transfer) continue;

      if (transaction.type == TransactionType.expense &&
          transaction.date.month == month &&
          transaction.date.year == year) {
        total -= transaction.amount;
      }
      if (transaction.type == TransactionType.income &&
          transaction.date.month == month &&
          transaction.date.year == year) {
        total += transaction.amount;
      }
    }
    return total;
  }

  double totalExpensesByWeek() {
    double total = 0;
    for (var transaction in state) {
      if (transaction.type == TransactionType.expense &&
          transaction.date
              .isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
        total += transaction.amount;
      }
    }
    return total;
  }

  List<Transaction> transactionsByMonth(int month) {
    return sortByDate(
        state.where((element) => element.date.month == month).toList());
  }

  List<Transaction> transactionsByYear(int year) {
    return sortByDate(
        state.where((element) => element.date.year == year).toList());
  }

  List<Transaction> sortByDate(List<Transaction> list) {
    List<Transaction> sortedTransactions = list;
    sortedTransactions.sort((a, b) => b.date.compareTo(a.date));
    return sortedTransactions;
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>(
  (ref) => TransactionNotifier(),
);
