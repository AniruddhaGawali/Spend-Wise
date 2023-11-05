import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/edit_data_screens/add_update_account_screen.dart';
import 'package:spendwise/widgits/action_chip.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:spendwise/widgits/loading.dart';

// ignore: must_be_immutable
class AddTransactionScreen extends HookConsumerWidget {
  TransactionCatergory? userSelectedCategory;
  Transaction? editTransaction;

  AddTransactionScreen({
    super.key,
    this.userSelectedCategory,
    this.editTransaction,
  });

  setTransaction(WidgetRef ref, Transaction transaction) {
    if (editTransaction != null) {
      ref
          .read(transactionProvider.notifier)
          .removeTransaction(editTransaction!);
    }
    ref.read(transactionProvider.notifier).addTransaction(transaction);

    final account = ref
        .read(userProvider)
        .accounts
        .firstWhere((element) => element.id == transaction.account.id);

    if (transaction.type == TransactionType.expense) {
      if (editTransaction != null) {
        ref
            .read(userProvider.notifier)
            .addAmount(account, editTransaction!.amount);
      }
      ref.read(userProvider.notifier).removeAmount(account, transaction.amount);
    } else {
      if (editTransaction != null) {
        ref
            .read(userProvider.notifier)
            .removeAmount(account, editTransaction!.amount);
      }
      ref.read(userProvider.notifier).addAmount(account, transaction.amount);
    }
  }

  addTransaction(
    WidgetRef ref,
    BuildContext context,
    ValueNotifier<String> title,
    ValueNotifier<double> amount,
    ValueNotifier<DateTime> date,
    ValueNotifier<TimeOfDay> time,
    ValueNotifier<TransactionCatergory> selectedCategory,
    ValueNotifier<Account> selectedAccount,
    ValueNotifier<TransactionType> selectedTransactionType,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    String url = editTransaction == null
        ? "${dotenv.env['API_URL']}/transaction/add"
        : "${dotenv.env['API_URL']}/transaction/update/${editTransaction!.id}";

    final createTransaction = {
      "title": title.value,
      "accountId": selectedAccount.value.id,
      "type": selectedTransactionType.value.name,
      "amount": amount.value,
      "category": selectedCategory.value.name,
      "date": DateTime(date.value.year, date.value.month, date.value.day,
              time.value.hour, time.value.minute)
          .toUtc()
          .toString()
    };

    http.Response response;

    if (editTransaction == null) {
      response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
        },
        body: jsonEncode(createTransaction),
      );
    } else {
      response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
        },
        body: jsonEncode(createTransaction),
      );
    }

    if (response.statusCode == 201) {
      // await fetchTransaction(ref);
      final body = jsonDecode(response.body);
      final transaction =
          Transaction.fromJson(body as Map<String, dynamic>, ref);

      setTransaction(ref, transaction);

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                editTransaction == null
                    ? "Transaction added successfully!"
                    : "Transaction updated successfully!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    )),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        );

        Navigator.pop(context, true);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                editTransaction == null
                    ? "Transaction addition failed!"
                    : "Transaction updation failed!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    )),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
    isLoading.value = false;
  }

  Future<bool> deleteTrasaction(WidgetRef ref, BuildContext context) async {
    String url =
        "${dotenv.env['API_URL']}/transaction/delete/${editTransaction!.id}";

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
      },
    );

    if (response.statusCode == 200) {
      ref
          .read(transactionProvider.notifier)
          .removeTransaction(editTransaction!);

      final account = ref
          .read(userProvider)
          .accounts
          .firstWhere((element) => element.id == editTransaction!.account.id);

      if (editTransaction!.type == TransactionType.expense) {
        ref
            .read(userProvider.notifier)
            .addAmount(account, editTransaction!.amount);
      } else {
        ref
            .read(userProvider.notifier)
            .removeAmount(account, editTransaction!.amount);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Transaction deleted successfully!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    )),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        );
      }
      return true;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Transaction deletion failed!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    )),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.read(userProvider).accounts.isEmpty) {
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

    final selectedTransactionType = useState<TransactionType>(
        editTransaction?.type ?? TransactionType.expense);

    final selectedFromAccount = useState<Account>(editTransaction != null
        ? ref
            .read(userProvider.notifier)
            .getAccountById(editTransaction!.account.id)
        : ref.read(userProvider).accounts.first);

    final selectedToAccount = useState<Account>(editTransaction != null
        ? ref
            .read(userProvider.notifier)
            .getAccountById(editTransaction!.account.id)
        : ref.read(userProvider).accounts.first);

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
                      bool isdeleted = await deleteTrasaction(ref, context);
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
                    SegmentedButton<TransactionType>(
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
                                      e.toString().split('.').last.substring(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
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
                            ? selectedCategory.value = TransactionCatergory.food
                            : selectedCategory.value =
                                TransactionCatergory.account;
                        selectedTransactionType.value = value.first;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text("From Account",
                          style: Theme.of(context).textTheme.bodyMedium!),
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...ref
                              .watch(userProvider)
                              .accounts
                              .map(
                                (e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: CustomActionChip(
                                    label: e.name,
                                    icon: e.type == AccountType.cash
                                        ? MdiIcons.cashMultiple
                                        : MdiIcons.bank,
                                    selected: selectedFromAccount.value == e,
                                    onPressed: () {
                                      selectedFromAccount.value = e;
                                    },
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: selectedTransactionType.value ==
                              TransactionType.transfer
                          ? 20
                          : 0,
                    ),
                    selectedTransactionType.value == TransactionType.transfer
                        ? Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text("To Account",
                                style: Theme.of(context).textTheme.bodyMedium!),
                          )
                        : const SizedBox.shrink(),
                    selectedTransactionType.value == TransactionType.transfer
                        ? SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...ref
                                    .watch(userProvider)
                                    .accounts
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: CustomActionChip(
                                          label: e.name,
                                          icon: e.type == AccountType.cash
                                              ? MdiIcons.cashMultiple
                                              : MdiIcons.bank,
                                          selected:
                                              selectedToAccount.value == e,
                                          onPressed: () {
                                            selectedToAccount.value = e;
                                          },
                                        ),
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
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
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          addTransaction(
                              ref,
                              context,
                              title,
                              amount,
                              selectedDate,
                              selectedTime,
                              selectedCategory,
                              selectedFromAccount,
                              selectedTransactionType,
                              isLoading);
                        },
                        icon: isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: Loading(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                              ? "Add Transaction"
                              : "Update Transaction",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
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
        DateTime now = DateTime.now();
        DateTime selectedDateTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

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

  Widget transferWidgit(
      BuildContext context, WidgetRef ref, Transaction? editTransaction) {
    final selectedAccount = useState<Account>(ref
        .read(userProvider)
        .accounts
        .firstWhere((element) => element.id != editTransaction!.account.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Transfer to",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ...ref
                  .watch(userProvider)
                  .accounts
                  .where((element) => element.id != editTransaction!.account.id)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomActionChip(
                        label: e.name,
                        icon: e.type == AccountType.cash
                            ? MdiIcons.cashMultiple
                            : MdiIcons.bank,
                        selected: selectedAccount.value == e,
                        onPressed: () {
                          selectedAccount.value = e;
                        },
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}
