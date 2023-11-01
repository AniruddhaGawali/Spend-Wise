import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/account.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/main_screen.dart';
import 'package:spendwise/utils/fetch_all_data.dart';
import 'package:spendwise/widgits/action_chip.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:spendwise/widgits/loading.dart';

class AddAccountScreen extends HookConsumerWidget {
  final Account? account;
  const AddAccountScreen({super.key, this.account});

  Future<bool> _createAccount(
    String name,
    double balance,
    AccountType type,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    final account = Account(id: '1', name: name, balance: balance, type: type);
    final url = "${dotenv.env['API_URL']}/account/add-account";

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}",
      },
      body: account.toJson(),
    );
    isLoading.value = false;

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _updateAccount(
    Account oldAccount,
    String name,
    double balance,
    AccountType type,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    final account =
        Account(id: oldAccount.id, name: name, balance: balance, type: type);
    final url = "${dotenv.env['API_URL']}/account/update/${oldAccount.id}";

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${ref.read(tokenProvider.notifier).get()}",
      },
      body: account.toJson(),
    );
    isLoading.value = false;

    if (response.statusCode == 201) {
      Map body = jsonDecode(response.body);

      ref
          .read(userProvider.notifier)
          .updateAccount(Account.fromJson(body['account']));

      return true;
    } else {
      return false;
    }
  }

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
            child: Form(
              key: formKey,
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
                        onPressed: () => accountType.value = AccountType.bank,
                      ),
                      const SizedBox(width: 10),
                      CustomActionChip(
                        label: 'Cash',
                        icon: MdiIcons.cashMultiple,
                        selected: accountType.value == AccountType.cash,
                        onPressed: () => accountType.value = AccountType.cash,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        bool isAccountCreated = account == null
                            ? await _createAccount(
                                accountName.value,
                                balance.value,
                                accountType.value,
                                ref,
                                isLoading,
                              )
                            : await _updateAccount(
                                account!,
                                accountName.value,
                                balance.value,
                                accountType.value,
                                ref,
                                isLoading,
                              );

                        if (isAccountCreated) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Account created successfully!",
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

                          account ?? await fetchData(ref);

                          if (context.mounted) {
                            account == null
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                  )
                                : Navigator.pop(context);
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Account creation failed!",
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
                              color: Theme.of(context).colorScheme.onPrimary,
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
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  account != null
                      ? OutlinedButton.icon(
                          onPressed: () {},
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
