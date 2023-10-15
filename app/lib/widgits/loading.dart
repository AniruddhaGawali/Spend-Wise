import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;

  // final
  const Loading({
    super.key,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 4,
          valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).colorScheme.secondary)),
    );
  }
}
