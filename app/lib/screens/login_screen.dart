import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/screens/register_screen_screen.dart';
import 'package:spendwise/widgits/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
    );
  }
}
