// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//  Provider:
import 'package:spendwise/provider/user_provider.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          Icon(
            MdiIcons.accountCircleOutline,
            size: 150,
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            'Username : ${ref.read(userProvider.notifier).get().username}',
            style: Theme.of(context).textTheme.titleLarge,
            softWrap: true,
          ),
        ]),
      ),
    );
  }
}
