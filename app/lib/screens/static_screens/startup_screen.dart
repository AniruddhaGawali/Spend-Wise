// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Screens & Widgets
import 'package:spendwise/data/constant_values.dart';
import 'package:spendwise/utils/about_device.dart';

class StartupScreen extends ConsumerWidget {
  final Widget nextScreen;
  const StartupScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(padding),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - padding,
        width: MediaQuery.of(context).size.width - padding,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: isPortrait(context)
                      ? getTopPadding(context) + padding * 2
                      : getTopPadding(context),
                ),
                Text(
                  "Spend Wise",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Your Money, Your Rules,\nYour Peace of Mind.",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "The SpendWise welcomes you to a world of financial clarity. It's where your journey to smarter money management begins. Here, at a glance, you can see your financial snapshot, recent transactions, and your progress towards budget goals. It's your financial cockpit, designed for effortless control.",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        wordSpacing: 5,
                      ),
                ),
                const Spacer(),
                FilledButton.icon(
                  icon: Icon(MdiIcons.arrowRight),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => nextScreen,
                      ),
                    );
                  },
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      "Get Started",
                      softWrap: false,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: isPortrait(context) ? 50 : 0,
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
