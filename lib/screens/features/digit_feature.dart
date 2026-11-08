import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/digit_summary.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 2: lucky digits 0–9, a selector row and all 10 cards in order.
class DigitFeature extends StatefulWidget {
  final Widget header;
  const DigitFeature({super.key, required this.header});

  @override
  State<DigitFeature> createState() => _DigitFeatureState();
}

class _DigitFeatureState extends State<DigitFeature> {
  int? _digit;
  final _digitKeys = [for (var i = 0; i < 10; i++) GlobalKey()];

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _digitBody());

  Future<void> _jumpToDigit(ScrollPosition pos, int digit) async {
    final key = _digitKeys[digit];
    if (key.currentContext == null) pos.jumpTo(0);
    // Each frame awaited here is a chance for the user to leave: stop once this screen is gone,
    // so the loop never moves a scroll position that has been disposed.
    while (mounted && key.currentContext == null && pos.pixels < pos.maxScrollExtent) {
      pos.jumpTo(math.min(pos.pixels + pos.viewportDimension, pos.maxScrollExtent));
      await WidgetsBinding.instance.endOfFrame;
    }
    if (!mounted) return;
    final target = key.currentContext;
    if (target != null && target.mounted) {
      await Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 300));
    }
  }

  List<Widget> _digitBody() {
    final sorted = [...digitSymbols]..sort((a, b) => a.digit.compareTo(b.digit));
    return [
      Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: C.goldBorder, width: 0.8)),
        ),
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
        child: Builder(
          builder: (context) => Row(
            children: [
              for (var d = 0; d <= 9; d++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SelectPill(
                      text: '$d',
                      selected: _digit == d,
                      onTap: () {
                        setState(() => _digit = d);
                        _jumpToDigit(Scrollable.of(context).position, d);
                      },
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      radius: 10,
                      fontSize: 16,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      for (final s in sorted)
        Padding(
          key: _digitKeys[s.digit],
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: AppCard(
            radius: 18,
            borderWidth: 1.5,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: goldGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: C.shadow, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      // Fixed-size badge: very large text shrinks to fit inside it.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${s.digit}',
                          style: serif(24, weight: FontWeight.w800, color: C.onGold, height: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Wraps with large text instead of running off the card.
                    Expanded(
                      child: Text(
                        'ฝันแบบไหนเป็นเลข ${s.digit}',
                        style: serif(18, weight: FontWeight.w700, color: C.accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: s.image == null
                        ? ImagePlaceholder('ภาพประกอบเลข ${s.digit}', fontSize: 13, band: 8)
                        : Image.asset(s.image!, fit: BoxFit.cover, semanticLabel: 'ภาพประกอบเลข ${s.digit}'),
                  ),
                ),
                const SizedBox(height: 18),
                Semantics(
                  label: 'ได้แก่ ฝันเห็น ${s.items.join(', ')}',
                  child: ExcludeSemantics(
                    child: Wrap(
                      key: ValueKey('digit-items-${s.digit}'),
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final item in s.items)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: C.input,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: C.goldBorder.withValues(alpha: 0.35)),
                            ),
                            child: Text(item, style: sans(14, color: C.textBody)),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 24),
    ];
  }
}
