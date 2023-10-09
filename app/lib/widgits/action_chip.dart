import 'package:flutter/material.dart';

class CustomActionChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool? selected;
  final Function? onPressed;
  const CustomActionChip(
      {super.key,
      required this.label,
      this.icon,
      this.selected,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )),
      avatar: Icon(icon),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: selected != null && selected != false
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface,
      onPressed: () {
        onPressed != null ? onPressed!() : null;
      },
    );
  }
}
