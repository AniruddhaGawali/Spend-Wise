import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  final data = MediaQuery.of(context).size;
  return data.shortestSide < 600;
}

bool isPortrait(BuildContext context) {
  final data = MediaQuery.of(context).orientation;
  return data == Orientation.portrait;
}

bool isLandscape(BuildContext context) {
  final data = MediaQuery.of(context).orientation;
  return data == Orientation.landscape;
}

double getTopPadding(BuildContext context) {
  final data = MediaQuery.of(context).padding.top;
  return data;
}
