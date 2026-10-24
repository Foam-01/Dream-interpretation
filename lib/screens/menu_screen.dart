import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/design_data.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class MenuScreen extends StatelessWidget {
  final String tab;
  const MenuScreen({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final m = menus[tab]!;
    return ListView(padding: EdgeInsets.zero, children: [
      RedHeader(
        pattern: false,
        gradient: false,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: SizedBox(
          width: double.infinity,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.title, style: serif(22, weight: FontWeight.w800, color: C.goldLight)),
            Text(m.sub, style: sans(13, color: C.onRedMuted)),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          for (final item in m.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CreamCard(
                radius: 14,
                padding: const EdgeInsets.all(14),
                onTap: () => app.openFeat(item.key),
                child: Row(children: [
                  GlyphTile(featureIcon(item.key), size: 46, radius: 12, borderWidth: 1),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.title, style: sans(16, weight: FontWeight.w600)),
                      Text(item.desc, style: sans(13, color: C.inkMuted)),
                    ]),
                  ),
                  Text('›', style: sans(20, color: C.goldMuted)),
                ]),
              ),
            ),
        ]),
      ),
    ]);
  }
}
