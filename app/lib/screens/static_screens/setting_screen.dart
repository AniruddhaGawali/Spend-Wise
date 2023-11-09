// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//  Provider:
import 'package:spendwise/provider/monetary_units.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/user_provider.dart';

// Screens & Widgets
import 'package:spendwise/screens/login_screen.dart';
import 'package:spendwise/screens/edit_screens/select_%20monetary_unit.dart';
import 'package:spendwise/widgits/cards/tile_card.dart';
import 'package:spendwise/widgits/cards/update_card.dart';

class SettingScreen extends HookConsumerWidget {
  late final LocalAuthentication auth;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // ignore: prefer_const_constructors_in_immutables
  SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // to check if biometric is supported
    final biometricSupported = useState(false);

    // to check if biometric is on
    final authOn = useState(false);

    // to check if biometric is on
    useEffect(() {
      isBiometricSupported().then(
        (value) => biometricSupported.value = value,
      );
      _prefs.then(
        (value) => authOn.value = value.getBool("isAuthOn") ?? false,
      );
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const UpdateCard(),
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    TileCard(
                      leading: Icon(MdiIcons.fingerprint),
                      title: const Text("Biometric Authentication"),
                      trailing: biometricSupported.value
                          ? Switch(
                              onChanged: (value) {
                                setBiometric(value).then((value) {
                                  authOn.value = value;
                                });
                              },
                              value: authOn.value,
                            )
                          : const Text("Not Supported"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TileCard(
                      leading: Icon(MdiIcons.cash100),
                      title: const Text("Monetary Unit"),
                      trailing: Text(
                        ref.read(monetaryUnitProvider.notifier).get(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onClick: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const SelectMonetaryUnitScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () {
                          ref.read(tokenProvider.notifier).deleteToken();
                          ref.read(userProvider.notifier).logout();

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          "Logout",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        trailing: Icon(
                          MdiIcons.logout,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .errorContainer
                            .withOpacity(.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () async {
                          final isConfirm = await showConfirmDialog(context);

                          if (!isConfirm) {
                            return;
                          }

                          final response = await http.delete(
                            Uri.parse("${dotenv.env['API_URL']}/user/delete"),
                            headers: {
                              "Authorization":
                                  "Bearer ${ref.read(tokenProvider.notifier).get()}"
                            },
                          );

                          if (response.statusCode == 200) {
                            ref.read(tokenProvider.notifier).deleteToken();
                            ref.read(userProvider.notifier).logout();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Something went wrong",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                  ),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                ),
                              );
                            }
                          }
                        },
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          "Delete Account",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        trailing: Icon(
                          MdiIcons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // to check if biometric is supported
  Future<bool> isBiometricSupported() async {
    auth = LocalAuthentication();
    bool isSupported = await auth.isDeviceSupported();
    return isSupported;
  }

  // to set or unset biometric
  Future<bool> setBiometric(bool isOn) async {
    bool isAuth = await auth.authenticate(
        localizedReason: "Scan your fingerprint to authenticate",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ));

    if (isAuth) {
      final SharedPreferences prefs = await _prefs;
      prefs.setBool("isAuthOn", isOn);
      return isOn;
    }

    return false;
  }

  Future<bool> showConfirmDialog(BuildContext context) async {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Delete Your Account"),
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
