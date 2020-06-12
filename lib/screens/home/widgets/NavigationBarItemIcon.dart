import 'package:flutter/material.dart';

class NavigationBarItemIcon extends StatelessWidget {
  final String iconPath;

  NavigationBarItemIcon(this.iconPath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Image.asset(
        iconPath,
        fit: BoxFit.cover,
        height: 25,
        width: 25,
      ),
    );
  }
}
