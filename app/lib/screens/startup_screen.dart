import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/screens/register_screen_screen.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).padding.top + 40,
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
            // Icon(MdiIcons.piggyBank,
            //     size: 100,
            //     color: Theme.of(context).colorScheme.tertiaryContainer),
            // const SizedBox(
            //   height: 10,
            // ),
            Text(
              "The SpendWise welcomes you to a world of financial clarity. It's where your journey to smarter money management begins. Here, at a glance, you can see your financial snapshot, recent transactions, and your progress towards budget goals. It's your financial cockpit, designed for effortless control.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    wordSpacing: 5,
                  ),
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: FilledButton.icon(
                icon: Icon(MdiIcons.arrowRight),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreeen(),
                    ),
                  );
                },
                label: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Get Started",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    ));
  }
}
