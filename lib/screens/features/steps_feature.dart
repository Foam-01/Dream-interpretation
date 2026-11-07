import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../theme.dart';
import 'feature_list.dart';

/// Menu 4 and the other step-by-step rituals: a timeline of steps, then the prayer.
class StepsFeature extends StatelessWidget {
  final Widget header;
  final String featKey;
  const StepsFeature({super.key, required this.header, required this.featKey});

  @override
  Widget build(BuildContext context) => FeatureList(header: header, children: _stepsBody(featKey));

  List<Widget> _stepsBody(String k) {
    final list = steps[k] ?? const [];
    final prayer = prayers[k];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            // A timeline: the rite is done in order, so each step hangs off one line.
            for (final (i, s) in list.indexed)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 34,
                      child: Column(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: i == 0 ? C.gold : C.brand,
                              shape: BoxShape.circle,
                              border: Border.all(color: C.gold, width: 1.5),
                            ),
                            // Fixed-size circle: very large text shrinks to fit inside it.
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                thaiDigits[i + 1],
                                style: serif(15, color: i == 0 ? C.onGold : C.goldLight, height: 1.2),
                              ),
                            ),
                          ),
                          if (i < list.length - 1)
                            Expanded(child: Container(width: 2, color: C.gold.withValues(alpha: .35))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s[0], style: sans(16, weight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(s[1], style: sans(14, color: C.textSoft, height: 1.7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (prayer != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: C.brand,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.goldDeep, width: 2),
                ),
                child: Column(
                  children: [
                    if (prayer[0].isNotEmpty) ...[
                      Text(prayer[0], style: sans(13, color: C.gold)),
                      const SizedBox(height: 6),
                    ],
                    SelectableText(
                      prayer[1],
                      textAlign: TextAlign.center,
                      style: serif(17, color: C.goldLight, height: 1.9),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ];
  }
}
