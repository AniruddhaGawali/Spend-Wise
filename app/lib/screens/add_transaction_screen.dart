import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/widgits/action_chip.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class AddTransactionScreen extends HookConsumerWidget {
  const AddTransactionScreen({super.key});

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
  ) async {
    String url = "${dotenv.env['API_URL']}/transaction/add";

    final transaction = {
      "title": title.value,
      "accountId": selectedAccount.value.id,
      "type": selectedTransactionType.value.name,
      "amount": amount.value,
      "category": selectedCategory.value.name,
      "date": DateTime(date.value.year, date.value.month, date.value.day,
              time.value.hour, time.value.minute)
          .toIso8601String()
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}"
      },
      body: jsonEncode(transaction),
    );

    if (response.statusCode == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Transaction added successfully!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    )),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        );
        Navigator.of(context).pop();
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Transaction addition failed!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    )),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTransactionType =
        useState<TransactionType>(TransactionType.expense);

    final selectedAccount =
        useState<Account>(ref.read(userProvider).accounts.first);

    final title = useState<String>("");
    final amount = useState<double>(0);

    final selectedDate = useState<DateTime>(DateTime.now());
    final selectedTime = useState<TimeOfDay>(TimeOfDay.now());

    final selectedCategory =
        useState<TransactionCatergory>(TransactionCatergory.food);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 40,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                "Add Transaction",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              SegmentedButton<TransactionType>(
                segments: [
                  ...TransactionType.values.reversed
                      .map(
                        (e) => ButtonSegment<TransactionType>(
                          label: Text(
                            e.toString().split('.').last[0].toUpperCase() +
                                e.toString().split('.').last.substring(1),
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
                      : selectedCategory.value = TransactionCatergory.account;
                  selectedTransactionType.value = value.first;
                },
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
                        .read(userProvider)
                        .accounts
                        .map(
                          (e) => CustomActionChip(
                            label: e.name,
                            icon: e.type.name == "cash"
                                ? MdiIcons.cashMultiple
                                : MdiIcons.bank,
                            selected: selectedAccount.value == e,
                            onPressed: () {
                              selectedAccount.value = e;
                            },
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
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
                        selectedAccount,
                        selectedTransactionType);
                  },
                  icon: Icon(
                    MdiIcons.plus,
                    size: 30,
                  ),
                  label: Text(
                    "Add Transaction",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.8),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ]),
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
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  DateFormat("dd/MM/yyyy").format(date.value),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        )),
        const SizedBox(
          width: 10,
        ),
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
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(time.value.format(context),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500)),
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
}
