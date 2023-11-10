// flutter lib
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// third party lib
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

// Provider
import 'package:spendwise/provider/monetary_units.dart';
import 'package:spendwise/provider/token_provider.dart';

// Screens & Widgets
import 'package:spendwise/screens/login_screen.dart';
import 'package:spendwise/screens/main_screen.dart';
import 'package:spendwise/screens/register_screen.dart';
import 'package:spendwise/screens/edit_screens/select_%20monetary_unit.dart';
import 'package:spendwise/screens/static_screens/startup_screen.dart';

// utils
import 'package:spendwise/utils/fetch_all_data.dart';
import "package:spendwise/theme/app_theme.dart";

void main() {
  dotenv.load(fileName: ".env");
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqflite_ffi.sqfliteFfiInit();
    // Change the default factory
    sqflite_ffi.databaseFactory = sqflite_ffi.databaseFactoryFfi;
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState {
  // This widget is the root of your application.

  late final LocalAuthentication auth;
  bool _supportsBiometric = false;
  bool _isAuthOn = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) => setState(() {
          _supportsBiometric = value;
        }));

    _prefs.then((value) => setState(() {
          _isAuthOn = value.getBool('isAuthOn') ?? false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'Spend Wise',
        theme: AppTheme.lightTheme(lightDynamic),
        darkTheme: AppTheme.darkTheme(darkDynamic),
        home: AnimatedSplashScreen.withScreenFunction(
          splash: _splashScreen(),
          backgroundColor: Theme.of(context).colorScheme.surface,
          splashIconSize: 100,
          screenFunction: _fetch,
        ),
      ),
    );
  }

  // fetch data from server
  Future<Widget> _fetch() async {
    //getting token from local storage
    bool isTokenLoaded = await ref.read(tokenProvider.notifier).loadToken();
    // getting monetary unit from local storage
    bool isMonetaryUnitLoaded =
        await ref.read(monetaryUnitProvider.notifier).loadUnit();
    bool isDataFetch = false;

    if (isTokenLoaded) {
      isDataFetch = await fetchData(ref);
    }

    if (isMonetaryUnitLoaded) {
      if (isDataFetch && isTokenLoaded) {
        if (_isAuthOn) {
          if (_supportsBiometric) {
            // authenticate user if biometric is supported and user has enabled it and token is loaded and data is fetched
            bool isauth = await _authenticate();
            if (isauth) {
              return MainScreen();
            }
          }
          // if biometric is not supported or user has not enabled it or user has not authenticated
          return const LoginScreen();
        }
        // if user has not enabled biometric authentication
        return MainScreen();
      } else {
        // if token is not loaded or data is not fetched
        return const StartupScreen(
          nextScreen: RegisterScreeen(),
        );
      }
    } else {
      // if monetary unit is not loaded
      return const StartupScreen(
        nextScreen: SelectMonetaryUnitScreen(
          nextPage: RegisterScreeen(),
        ),
      );
    }
  }

  // authenticate user
  Future<bool> _authenticate() async {
    try {
      // trigger authentication
      bool authentcated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: false));
      return authentcated;
    } on PlatformException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? 'Biometric authentication not supported'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    }
    return false;
  }

  // splash screen widget
  Widget _splashScreen() {
    return SizedBox(
      width: 100,
      height: 100,
      child:
          Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Center(
          child: Icon(
            MdiIcons.wallet,
            size: 50,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ]),
    );
  }
}
