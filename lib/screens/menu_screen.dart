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
    final letters = m.items.where(_isLetter).toList();
    final features = m.items.where((i) => !_isLetter(i)).toList();
    // The book menu shows its features as a two-column grid (an odd one out goes full width below);
    // the other menus keep one row per feature.
    final asGrid = letters.isNotEmpty;
    final paired = asGrid ? features.length - features.length % 2 : 0;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        PageHeader(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: serif(26, weight: FontWeight.w800, color: C.goldLight),
                ),
                Text(m.sub, style: sans(14, color: C.onBrandMuted)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (paired > 0) ...[
                ContentGrid(
                  columns: 2,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final item in features.take(paired))
                      _FeatureTile(item, onTap: () => app.openFeat(item.key)),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              for (final item in features.skip(paired))
                if (asGrid)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _FeatureTile(item, wide: true, onTap: () => app.openFeat(item.key)),
                  )
                else
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    radius: 14,
                    padding: const EdgeInsets.all(14),
                    onTap: () => app.openFeat(item.key),
                    child: Row(
                      children: [
                        GlyphTile(
                          featureIcon(item.key),
                          size: 46,
                          radius: 12,
                          borderWidth: 1,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: sans(16, weight: FontWeight.w600),
                              ),
                              Text(
                                item.desc,
                                style: sans(13, color: C.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Text('›', style: sans(20, color: C.goldMuted)),
                      ],
                    ),
                  ),
                ),
              if (letters.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('ทำนายฝันตามตัวอักษร', style: serif(17, color: C.accent)),
                Text(
                  'แตะตัวอักษรแรกของสิ่งที่ฝันเห็น',
                  style: sans(14, color: C.textSoft),
                ),
                const SizedBox(height: 10),
                // 32 letter categories as one grid instead of 32 rows.
                ContentGrid(
                  columns: 8,
                  spacing: 6,
                  runSpacing: 6,
                  minRowHeight: 44,
                  children: [
                    for (final item in letters)
                      _LetterTile(item, onTap: () => app.openFeat(item.key)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

bool _isLetter(MenuItem item) => feats[item.key]?.type == FeatType.letter;

/// A compact feature card for the book menu grid: outlined icon, title and a short line.
/// [wide] lays it out as one row (icon, title, description on the right) across the full width.
class _FeatureTile extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  final bool wide;
  const _FeatureTile(this.item, {required this.onTap, this.wide = false});

  @override
  Widget build(BuildContext context) {
    final icon = Icon(featureIcon(item.key), size: 22, color: C.goldLight);
    final title = Text(item.title, style: sans(15, weight: FontWeight.w600));
    final desc = Text(item.desc, style: sans(12, color: C.textMuted));
    return AppCard(
      radius: 14,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: wide
          // The wide row has no icon (owner's call).
          ? Row(children: [
              Expanded(child: title),
              const SizedBox(width: 8),
              Flexible(child: Text(item.desc, textAlign: TextAlign.right, style: sans(12, color: C.textMuted))),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              icon,
              const SizedBox(height: 10),
              title,
              const SizedBox(height: 2),
              desc,
            ]),
    );
  }
}

/// One letter category ("ทำนายฝันหมวด ก" → ก) in the book menu's letter grid.
class _LetterTile extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  const _LetterTile(this.item, {required this.onTap});

  @override
  // The tooltip names the full category on long-press (and lets tests find the tile by title).
  Widget build(BuildContext context) => Tooltip(
    message: item.title,
    excludeFromSemantics: true,
    child: Semantics(
      button: true,
      label: item.title,
      excludeSemantics: true,
      child: Material(
        color: C.brand,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: C.gold.withValues(alpha: .45)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Center(
            child: Text(
              item.title.split(' ').last,
              textScaler: MediaQuery.textScalerOf(context)
                  .clamp(maxScaleFactor: 1.3),
              style: serif(18, color: C.goldLight, height: 1.2),
            ),
          ),
        ),
      ),
    ),
  );
}
