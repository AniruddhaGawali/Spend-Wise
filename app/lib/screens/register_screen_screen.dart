import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/screens/login_screen.dart';
import 'package:spendwise/widgits/auth.dart';

class RegisterScreeen extends StatelessWidget {
  const RegisterScreeen({super.key});

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
    );
  }
}
