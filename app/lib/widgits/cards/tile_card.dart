import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TileCard extends StatelessWidget {
  Widget? leading;
  Widget? trailing;
  Widget? title;
  Widget? subtitle;
  Color? backgroundColor;
  BoxBorder? border;

  void Function()? onClick;

  TileCard({
    Key? key,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.onClick,
    this.backgroundColor,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border ??
            Border(
              bottom: BorderSide(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                width: 1,
              ),
            ),
        color: backgroundColor ?? Theme.of(context).colorScheme.background,
      ),
      child: ListTile(
        onTap: onClick,
        leading: leading,
        title: title,
        trailing: trailing,
      ),
    );
  }
}
