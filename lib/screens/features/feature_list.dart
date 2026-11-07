import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../widgets/ui.dart';

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

/// Seven weekday pills (อา … ส) for the menus read by the draw's weekday (7, 9 and 10).
class WeekdayPills extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const WeekdayPills({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
    child: Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: SelectPill(
                text: dayShort[i],
                selected: selected == i,
                onTap: () => onSelect(i),
                radius: 10,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
      ],
    ),
  );
}
