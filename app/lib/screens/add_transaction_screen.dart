import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/widgits/action_chip.dart';

class AddTransactionScreen extends HookConsumerWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTransactionType =
        useState<TransactionType>(TransactionType.expense);

    final selectedAccount =
        useState<Account>(ref.read(userProvider).accounts.first);

    final title = useState<String>("");
    final amount = useState<double>(0);

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
                  ...TransactionType.values
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

  Widget setDateTimeForm() {
    return Row(
      children: [],
    );
  }
}
