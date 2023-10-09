import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/provider/token_provider.dart';
import 'package:spendwise/screens/login_screen.dart';
import 'package:spendwise/screens/startup_screen.dart';
import "package:spendwise/theme/app_theme.dart";

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              bool isTokenLoaded =
                  await ref.read(tokenProvider.notifier).loadToken();

              return isTokenLoaded
                  ? const LoginScreen()
                  : const StartupScreen();
            }),
      ),
    );
  }
}
