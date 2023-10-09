import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/screens/startup.dart';
import "package:spendwise/theme/app_theme.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'Spend Wise',
        theme: AppTheme.lightTheme(lightDynamic),
        darkTheme: AppTheme.darkTheme(darkDynamic),
        home: AnimatedSplashScreen.withScreenFunction(
            splash: MdiIcons.wallet,
            backgroundColor: Theme.of(context).colorScheme.surface,
            splashIconSize: 100,
            screenFunction: () async {
              await Future.delayed(const Duration(seconds: 2));
              return const StartupScreen();
            }),
      ),
    );
  }
}
