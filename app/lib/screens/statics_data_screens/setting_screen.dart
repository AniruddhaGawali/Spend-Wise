import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendwise/provider/monetary_units.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/provider/user_provider.dart';
import 'package:spendwise/screens/login_screen.dart';
import 'package:spendwise/screens/edit_data_screens/select_%20monetary_unit.dart';

import 'package:spendwise/widgits/cards/update_card.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends HookConsumerWidget {
  late final LocalAuthentication auth;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // ignore: prefer_const_constructors_in_immutables
  SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricSupported = useState(false);
    final authOn = useState(false);

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
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SelectMonetaryUnitScreen(),
                            ),
                          );
                        },
                        title: const Text("Monetary Unit"),
                        leading: Text(
                          ref.read(monetaryUnitProvider.notifier).get(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
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
                          final response = await http.delete(
                            Uri.parse(
                                "https://spendwise-api.herokuapp.com/api/user/delete"),
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

  Future<bool> isBiometricSupported() async {
    auth = LocalAuthentication();
    bool isSupported = await auth.isDeviceSupported();
    return isSupported;
  }

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
}
