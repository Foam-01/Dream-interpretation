import 'package:flutter/material.dart';

/// The scrolling page of a feature: its header, then the menu's own content.
class FeatureList extends StatelessWidget {
  final Widget header;
  final List<Widget> children;
  const FeatureList({super.key, required this.header, required this.children});

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        // Scrolling puts the keyboard away (menus 5 and 6 have a search box).
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [header, ...children],
      );
}
