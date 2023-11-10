import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/edit_screens/edit_account/edit_acccount_screen.dart';
import 'package:spendwise/screens/edit_screens/edit_transactions/edit_transaction_functions.dart';
import 'package:spendwise/widgits/account_list.dart';
import 'package:spendwise/widgits/action_chip.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/widgits/loading.dart';

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
      return _noTransactions(context);
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
          : ref
              .watch(userProvider)
              .accounts
              .where(
                (element) => element.id != selectedFromAccount.value.id,
              )
              .first,
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

                    // from account
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text("From Account",
                          style: Theme.of(context).textTheme.bodyMedium!),
                    ),
                    AccountList(
                      selectedAccount: selectedFromAccount,
                      accounts: ref.watch(userProvider).accounts,
                    ),
                    SizedBox(
                      height: selectedTransactionType.value ==
                              TransactionType.transfer
                          ? 20
                          : 0,
                    ),

                    // to transfer money from one account to another
                    selectedTransactionType.value == TransactionType.transfer
                        ? Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text("To Account",
                                style: Theme.of(context).textTheme.bodyMedium!),
                          )
                        : const SizedBox.shrink(),
                    selectedTransactionType.value == TransactionType.transfer
                        ? AccountList(
                            selectedAccount: selectedToAccount,
                            accounts: ref
                                .watch(userProvider)
                                .accounts
                                .where((element) =>
                                    element.id != selectedFromAccount.value.id)
                                .toList(),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 20,
                    ),

                    formInput(
                      title,
                      amount,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    setDateTimeForm(
                      context,
                      selectedDate,
                      selectedTime,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    setCategory(selectedCategory, selectedTransactionType),
                    const SizedBox(
                      height: 40,
                    ),
                    (selectedTransactionType.value !=
                                TransactionType.transfer ||
                            selectedTransactionType.value ==
                                    TransactionType.transfer &&
                                editTransaction == null)
                        ? SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                selectedTransactionType.value ==
                                        TransactionType.transfer
                                    ? createUpdateTransafer(
                                        ref,
                                        context,
                                        title,
                                        amount,
                                        selectedDate,
                                        selectedTime,
                                        selectedCategory,
                                        selectedFromAccount,
                                        selectedToAccount,
                                        selectedTransactionType,
                                        isLoading,
                                        _formKey,
                                        editTransaction,
                                      )
                                    : addUpdateTransaction(
                                        ref,
                                        context,
                                        title,
                                        amount,
                                        selectedDate,
                                        selectedTime,
                                        selectedCategory,
                                        selectedFromAccount,
                                        selectedTransactionType,
                                        isLoading,
                                        _formKey,
                                        editTransaction,
                                      );
                              },
                              icon: isLoading.value
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Loading(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        strokeWidth: 2,
                                      ))
                                  : Icon(
                                      editTransaction == null
                                          ? MdiIcons.plus
                                          : MdiIcons.update,
                                      size: 30,
                                    ),
                              label: Text(
                                editTransaction == null
                                    ? selectedTransactionType.value !=
                                            TransactionType.transfer
                                        ? "Add Transaction"
                                        : "Transfer"
                                    : selectedTransactionType.value !=
                                            TransactionType.transfer
                                        ? "Update Transaction"
                                        : "Update Transfer",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 50,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget formInput(
    ValueNotifier<String> title,
    ValueNotifier<double> amount,
  ) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: title.value,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter title of transaction",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) => value!.isEmpty ? "Enter title" : null,
              onChanged: (value) => title.value = value,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: amount.value > 0 ? amount.value.toString() : null,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                hintText: "Enter amount of transaction",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter amount";
                }
                if (double.tryParse(value) == null) {
                  return "Enter valid amount";
                }
                if (double.parse(value) <= 0) {
                  return "Enter valid amount";
                }
                return null;
              },
              onChanged: (value) => amount.value = double.parse(value),
            ),
          ],
        ));
  }

  Widget setDateTimeForm(
    BuildContext context,
    ValueNotifier<DateTime> date,
    ValueNotifier<TimeOfDay> time,
  ) {
    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != date.value) {
        if (picked.isAfter(DateTime.now())) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Selected date cannot be in future",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        )),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
            );
          }
          return;
        }

        date.value = picked;
      }
    }

    Future<void> selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: time.value,
      );
      if (picked != null && picked != time.value) {
        DateTime selectedDate = date.value;
        DateTime selectedDateTime = DateTime(selectedDate.year,
            selectedDate.month, selectedDate.day, picked.hour, picked.minute);

        if (selectedDateTime.isAfter(DateTime.now())) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Selected time cannot be in future",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        )),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
            );
          }
          return;
        }
        time.value = picked;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            selectDate(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  MdiIcons.calendarMonthOutline,
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  DateFormat("dd/MM/yyyy").format(date.value),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              selectTime(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    MdiIcons.clockOutline,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(time.value.format(context),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget setCategory(ValueNotifier<TransactionCatergory> selectedCategory,
      ValueNotifier<TransactionType> selectedTransactionType) {
    return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: selectedTransactionType.value == TransactionType.expense
              ? WrapAlignment.center
              : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            ...selectedTransactionType.value == TransactionType.expense
                ? TransactionCatergory.values
                    .where((element) => element != TransactionCatergory.account)
                    .map(
                      (e) => CustomActionChip(
                        label: e.toString().split('.').last[0].toUpperCase() +
                            e.toString().split('.').last.substring(1),
                        icon: getTransactionCatergoryIcon(e),
                        selected: selectedCategory.value == e,
                        onPressed: () {
                          selectedCategory.value = e;
                        },
                      ),
                    )
                    .toList()
                : TransactionCatergory.values
                    .where((element) => element == TransactionCatergory.account)
                    .map(
                      (e) => CustomActionChip(
                        label: e.toString().split('.').last[0].toUpperCase() +
                            e.toString().split('.').last.substring(1),
                        icon: getTransactionCatergoryIcon(e),
                        selected: selectedCategory.value == e,
                        onPressed: () {
                          selectedCategory.value = e;
                        },
                      ),
                    )
                    .toList()
          ],
        ));
  }

  Widget _noTransactions(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editTransaction?.title ?? "Add Transaction"),
      ),
      body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "No account for transaction\nPlease add account first",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return const AddAccountScreen();
                    }));
                  },
                  icon: Icon(
                    MdiIcons.plus,
                    size: 30,
                  ),
                  label: Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
