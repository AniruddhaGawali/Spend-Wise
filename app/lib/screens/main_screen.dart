// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/screens/pages/analytics_page/analytics_screen.dart';

// Screens & Widgets
import 'package:spendwise/screens/pages/account_page.dart';
import 'package:spendwise/screens/pages/home_page.dart';

class MainScreen extends HookWidget {
  MainScreen({super.key});
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (value) => selectedIndex.value = value,
        children: const [
          HomeScreen(),
          AllAccountsScreen(),
          AnalyticsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) {
          selectedIndex.value = index;
          pageController.jumpToPage(
            index,
          );
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              MdiIcons.homeOutline,
            ),
            selectedIcon: Icon(
              MdiIcons.home,
            ),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.wallet),
            selectedIcon: Icon(Icons.wallet),
            label: 'Accounts',
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.chartDonut),
            selectedIcon: Icon(MdiIcons.chartDonutVariant),
            label: 'Analytics',
          )
        ],
      ),
    );
  }
}
