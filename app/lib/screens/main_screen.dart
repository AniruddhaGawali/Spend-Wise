import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/screens/home_screen.dart';

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
        children: [
          const HomeScreen(),
          Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Center(
                child: Text(
                  'Comming Soon...',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              )),
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
          NavigationDestination(
            icon: Icon(MdiIcons.walletBifoldOutline),
            selectedIcon: Icon(MdiIcons.walletBifold),
            label: 'Accounts',
          ),
        ],
      ),
    );
  }
}
