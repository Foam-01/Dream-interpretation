import 'package:flutter/material.dart';

import '../../data/digit_lore.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 12: the book's number lore, filtered by leading number.
class LoreFeature extends StatefulWidget {
  final Widget header;
  const LoreFeature({super.key, required this.header});

  @override
  State<LoreFeature> createState() => _LoreFeatureState();
}

class _LoreFeatureState extends State<LoreFeature> {
  int? _loreDigit;

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _tableBody());

  List<Widget> _tableBody() {
    final entries = _loreDigit == null
        ? loreEntriesByNumber
        : loreEntriesByNumber.where((entry) => entry.badge == '$_loreDigit').toList();
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                key: const ValueKey('lore-digit-filter'),
                children: [
                  SelectPill(
                    key: const ValueKey('lore-filter-all'),
                    text: 'ทั้งหมด',
                    selected: _loreDigit == null,
                    onTap: () => setState(() => _loreDigit = null),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    radius: 10,
                    fontSize: 13,
                    weight: FontWeight.w700,
                  ),
                  const SizedBox(width: 4),
                  for (final digit in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SelectPill(
                        key: ValueKey('lore-filter-$digit'),
                        text: '$digit',
                        selected: _loreDigit == digit,
                        onTap: () => setState(() => _loreDigit = _loreDigit == digit ? null : digit),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        radius: 10,
                        fontSize: 15,
                        weight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(loreIntro, style: sans(14, color: C.textBody, height: 1.8)),
            const SizedBox(height: 12),
            for (final e in entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  radius: 14,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigitBox(e.badge, width: 48, height: 48, fontSize: e.badge.length > 1 ? 18 : 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              if (e.seen case final seen?) ...[
                                const TextSpan(text: 'ถ้าฝันเห็น '),
                                TextSpan(
                                  text: seen,
                                  style: sans(14, weight: FontWeight.w700, color: C.accent, height: 1.7),
                                ),
                                TextSpan(text: e.text.substring('ถ้าฝันเห็น '.length + seen.length)),
                              ] else
                                TextSpan(text: e.text),
                            ],
                          ),
                          style: sans(14, color: C.textBody, height: 1.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: C.brand,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.goldDeep, width: 2),
              ),
              child: Text(loreClosing, style: sans(14, color: C.onBrand, height: 1.8)),
            ),
          ],
        ),
      ),
    ];
  }
}
