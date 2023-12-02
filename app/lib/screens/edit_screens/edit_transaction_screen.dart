import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/edit_screens/edit_acccount_screen.dart';
import 'package:spendwise/utils/transaction.dart';
import 'package:spendwise/widgits/no_account.dart';

import 'package:spendwise/widgits/transaction_form.dart';

// ignore: must_be_immutable
class AddTransactionScreen extends HookConsumerWidget {
  TransactionCatergory? userSelectedCategory;
  Transaction? editTransaction;
  final _formKey = GlobalKey<FormState>();

  AddTransactionScreen({
    super.key,
    this.userSelectedCategory,
    this.editTransaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.read(userProvider).accounts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(editTransaction?.title ?? "Add Transaction"),
        ),
        body: const NoAccount(
            message: "No account for transaction\nPlease add account first"),
      );
    }

    final selectedTransactionType = useState<TransactionType>(
        editTransaction?.type ?? TransactionType.expense);

    final selectedFromAccount = useState<Account>(editTransaction != null
        ? ref
            .read(userProvider.notifier)
            .getAccountById(editTransaction!.fromAccount.id)
        : ref.read(userProvider).accounts.first);

    final selectedToAccount = useState<Account>(
      editTransaction != null
          ? editTransaction!.toAccount != null
              ? ref
                  .read(userProvider.notifier)
                  .getAccountById(editTransaction!.toAccount!.id)
              : selectedFromAccount.value
          : selectedFromAccount.value,
    );

    final title = useState<String>(editTransaction?.title ?? "");
    final amount = useState<double>(editTransaction?.amount ?? 0);

    final selectedDate =
        useState<DateTime>(editTransaction?.date ?? DateTime.now());
    final selectedTime = useState<TimeOfDay>(editTransaction?.date != null
        ? TimeOfDay.fromDateTime(editTransaction!.date)
        : TimeOfDay.now());

    final selectedCategory = useState<TransactionCatergory>(
      editTransaction?.category ??
          userSelectedCategory ??
          TransactionCatergory.food,
    );

    final isLoading = useState<bool>(false);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(editTransaction?.title ?? "Add Transaction"),
          actions: [
            editTransaction != null
                ? IconButton(
                    onPressed: () async {
                      bool isdeleted;
                      if (editTransaction!.type == TransactionType.transfer) {
                        isdeleted =
                            await deleteTransfer(ref, context, editTransaction);
                      } else {
                        isdeleted = await deleteTrasaction(
                            ref, context, editTransaction);
                      }

                      if (isdeleted && context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    icon: Icon(MdiIcons.delete))
                : const SizedBox.shrink(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<TransactionType>(
                        segments: [
                          ...TransactionType.values.reversed
                              .map(
                                (e) => ButtonSegment<TransactionType>(
                                  label: Text(
                                    e
                                            .toString()
                                            .split('.')
                                            .last[0]
                                            .toUpperCase() +
                                        e
                                            .toString()
                                            .split('.')
                                            .last
                                            .substring(1),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ],
                        selected: {selectedTransactionType.value},
                        onSelectionChanged: (value) {
                          value.first == TransactionType.expense
                              ? selectedCategory.value =
                                  TransactionCatergory.food
                              : selectedCategory.value =
                                  TransactionCatergory.account;
                          selectedTransactionType.value = value.first;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (selectedTransactionType.value ==
                                TransactionType.transfer &&
                            ref.read(userProvider).accounts.length <= 1)
                        ? const NoAccount(
                            message:
                                "No another account for transaction\nPlease add account first")
                        : TransactionForm(
                            ref: ref,
                            selectedTransactionType: selectedTransactionType,
                            selectedToAccount: selectedToAccount,
                            selectedFromAccount: selectedFromAccount,
                            title: title,
                            amount: amount,
                            selectedDate: selectedDate,
                            selectedTime: selectedTime,
                            selectedCategory: selectedCategory,
                            isLoading: isLoading,
                            editTransaction: editTransaction),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
