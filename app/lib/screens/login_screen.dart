import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/screens/register_screen_screen.dart';
import 'package:spendwise/screens/startup_screen.dart';
import 'package:spendwise/widgits/auth.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<bool> _login(String username, String password, bool rememberMe,
      WidgetRef ref, BuildContext context) async {
    final url = "${dotenv.env['API_URL']}/user/login";

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

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login Successful!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        );
        ref.read(tokenProvider.notifier).set(body["token"]);
        return true;
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Invalid Credentials!",
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
              "Login Failed!",
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
      isLogin: true,
      title: "Login",
      subTitle: "Welcome Back!",
      description: "Login to your account to get started.",
      buttonText: "Login",
      buttonIcon: MdiIcons.loginVariant,
      bottomText: "Don't have an account?",
      bottomButtonText: "Register",
      bottomWidget: const RegisterScreeen(),
      nextScreen: const StartupScreen(),
      onSubmit: _login,
    );
  }
}
