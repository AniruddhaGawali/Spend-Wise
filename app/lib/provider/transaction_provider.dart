import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/transaction.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]);

  List<Transaction> get() => state;

  void set(List<Transaction> transactions) {
    state = transactions;
  }

  void addTransaction(Transaction transaction) {
    state = [...state, transaction];
  }

  void removeTransaction(Transaction transaction) {
    state = state.where((element) => element.id != transaction.id).toList();
  }

  double totalExpenses() {
    double total = 0;
    for (var transaction in state) {
      if (transaction.type == TransactionType.expense) {
        total += transaction.amount;
      }
    }
    return total;
  }

  List<Transaction> transactionsofMonth() {
    return sortByDate(state
        .where((element) =>
            element.date.month == DateTime.now().month &&
            element.date.year == DateTime.now().year)
        .toList());
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
