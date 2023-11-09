// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:spendwise/model/account.dart';
import 'package:spendwise/screens/edit_screens/edit_account/edit_account_functions.dart';

// Screen and Widget imports:
import 'package:spendwise/screens/main_screen.dart';
import 'package:spendwise/widgits/action_chip.dart';
import 'package:spendwise/widgits/loading.dart';

class AddAccountScreen extends HookConsumerWidget {
  final Account? account;
  const AddAccountScreen({super.key, this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final accountName = useState<String>(account?.name ?? "");
    final balance = useState<double>(account?.balance ?? 0);
    final accountType =
        useState<AccountType>(account?.type ?? AccountType.bank);
    final isLoading = useState(false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 40,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                ),
                Text(
                  account == null ? "Add Transaction" : "Update Transaction",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Account",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Spacer(),
                Text("Create a new account to add transactions.",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.tertiary,
                        )),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: accountName.value,
                        decoration: InputDecoration(
                            labelText: 'Account Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an account name';
                          }
                          return null;
                        },
                        onSaved: (newValue) => accountName.value = newValue!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue:
                            account == null ? null : balance.value.toString(),
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: 'Balance',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a balance';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (newValue) =>
                            balance.value = double.parse(newValue!),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CustomActionChip(
                            label: 'Bank',
                            icon: MdiIcons.bank,
                            selected: accountType.value == AccountType.bank,
                            onPressed: () =>
                                accountType.value = AccountType.bank,
                          ),
                          const SizedBox(width: 10),
                          CustomActionChip(
                            label: 'Cash',
                            icon: MdiIcons.cashMultiple,
                            selected: accountType.value == AccountType.cash,
                            onPressed: () =>
                                accountType.value = AccountType.cash,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            bool isAccountCreated = account == null
                                ? await createAccount(
                                    accountName.value,
                                    balance.value,
                                    accountType.value,
                                    ref,
                                    isLoading,
                                  )
                                : await updateAccount(
                                    account!,
                                    accountName.value,
                                    balance.value,
                                    accountType.value,
                                    ref,
                                    isLoading,
                                  );

                            if (isAccountCreated) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        account == null
                                            ? "Account created successfully!"
                                            : "Account updated successfully!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onTertiaryContainer,
                                            )),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                  ),
                                );
                              }

                              if (context.mounted) {
                                account == null
                                    ? Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(),
                                        ),
                                        (route) => false,
                                      )
                                    : Navigator.pop(context);
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      account == null
                                          ? "Account creation failed!"
                                          : "Account updation failed!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onErrorContainer,
                                          ),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        icon: isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: Loading(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(account == null
                                ? MdiIcons.bankPlus
                                : MdiIcons.update),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Text(
                            account == null ? 'Add Account' : "Update Account",
                            softWrap: false,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      account != null
                          ? OutlinedButton.icon(
                              onPressed: () async {
                                bool isConfirm =
                                    await showConfirmDialog(context);
                                if (!isConfirm) {
                                  return;
                                }

                                bool isDeleted =
                                    await deleteAccount(ref, account);
                                if (isDeleted) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Account deleted successfully!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryContainer,
                                                )),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Account deleted successfully!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryContainer,
                                                )),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                )),
                                iconColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.error),
                              ),
                              icon: Icon(
                                MdiIcons.delete,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Text(
                                  "Delete",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showConfirmDialog(BuildContext context) async {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Delete Account"),
      content: const Text(
          "Are you sure you want to delete this account?\nThis will delete all the transactions associated with this account."),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel")),
        ElevatedButton(
          child: Text(
            "OK",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );
    // show the dialog
    final isConfirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return isConfirm;
  }
}
