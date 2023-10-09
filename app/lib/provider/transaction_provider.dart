import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/transaction.dart';

class TransactionNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    return [];
  }

  List<Transaction> get() => state;

  void set(List<Transaction> transactions) {
    state = transactions;
  }

  void addTransaction(Transaction transaction) {
    state.add(transaction);
  }

  void removeTransaction(Transaction transaction) {
    state.remove(transaction);
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
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<Transaction>>(
  () => TransactionNotifier(),
);
