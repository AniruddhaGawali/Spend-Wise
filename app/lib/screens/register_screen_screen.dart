import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/screens/add_account_screen.dart';
import 'package:spendwise/screens/login_screen.dart';
import 'package:spendwise/widgits/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class RegisterScreeen extends StatelessWidget {
  const RegisterScreeen({super.key});

  Future<bool> _register(String username, String password, bool rememberMe,
      WidgetRef ref, BuildContext context) async {
    final url = "${dotenv.env['API_URL']}/user/register";

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"username": username, "password": password}),
    );

    Map<String, dynamic> body = jsonDecode(response.body);

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account created successfully!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    )),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        );
        ref.read(tokenProvider.notifier).set(body["token"]);
        if (rememberMe) {
          ref.read(tokenProvider.notifier).saveToken();
        }
        return true;
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Username already exists!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Account creation failed!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AuthWidgit(
      isLogin: false,
      title: "Register",
      subTitle: "Welcome to SpendWise!",
      description: "Create an account to get started.",
      buttonText: "Register",
      buttonIcon: MdiIcons.accountPlusOutline,
      bottomText: "Already have an account?",
      bottomButtonText: "Login",
      bottomWidget: const LoginScreen(),
      nextScreen: AddAccountScreen(),
      onSubmit: _register,
    );
  }
}
