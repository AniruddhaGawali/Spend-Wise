// ignore_for_file: constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/provider/monetary_units.dart';

enum MonetaryUnit {
  USD,
  EUR,
  GBP,
  JPY,
  CAD,
  AUD,
  CHF,
  CNY,
  INR,
  NZD,
}

class SelectMonetaryUnitScreen extends HookConsumerWidget {
  final Widget? nextPage;
  const SelectMonetaryUnitScreen({super.key, this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<MonetaryUnit, String> monetaryUnits = {
      MonetaryUnit.USD: '\$',
      MonetaryUnit.EUR: '€',
      MonetaryUnit.GBP: '£',
      MonetaryUnit.JPY: '¥',
      MonetaryUnit.CAD: '\$',
      MonetaryUnit.AUD: '\$',
      MonetaryUnit.CHF: 'CHF',
      MonetaryUnit.CNY: '¥',
      MonetaryUnit.INR: '₹',
      MonetaryUnit.NZD: '\$',
    };

    final selectedMonetaryUnits = useState<MonetaryUnit>(MonetaryUnit.USD);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Monetary Unit'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: monetaryUnits.length,
        itemBuilder: (BuildContext context, int index) {
          final monetaryUnit = monetaryUnits.keys.elementAt(index);
          final monetaryUnitSymbol = monetaryUnits.values.elementAt(index);
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              selectedMonetaryUnits.value = monetaryUnit;
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedMonetaryUnits.value == monetaryUnit
                    ? Theme.of(context).colorScheme.tertiaryContainer
                    : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(monetaryUnit.toString().split('.').last,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight:
                                selectedMonetaryUnits.value == monetaryUnit
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          )),
                  const SizedBox(width: 10),
                  Text(
                    monetaryUnitSymbol,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight:
                              selectedMonetaryUnits.value == monetaryUnit
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.secondaryContainer,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text(
                '${selectedMonetaryUnits.value.name}:  ${monetaryUnits[selectedMonetaryUnits.value]}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  ref
                      .read(monetaryUnitProvider.notifier)
                      .set(monetaryUnits[selectedMonetaryUnits.value]!);

                  await ref.read(monetaryUnitProvider.notifier).deleteUnit();
                  await ref.read(monetaryUnitProvider.notifier).saveUnit();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Monetary Unit Saved',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    );

                    nextPage != null
                        ? Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => nextPage!,
                            ),
                          )
                        : Navigator.of(context).pop();
                  }
                },
                child: Text(
                  nextPage != null ? 'Next' : "Save",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }
}
