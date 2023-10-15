import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BulletsPoints extends StatelessWidget {
  String text;
  EdgeInsetsGeometry? padding;

  BulletsPoints({
    super.key,
    required this.text,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 0, bottom: 0),
      child: Row(children: [
        Text(
          "\u2022",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w400,
              fontSize: 30,
              height: 1.5),
        ), //bullet text
        const SizedBox(
          width: 10,
        ), //space between bullet and text
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w400,
                height: 1.5),
          ), //text
        )
      ]),
    );
  }
}
