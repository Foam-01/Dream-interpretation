import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../data/formulas.dart';
import '../../data/lock_numbers.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 7: the book's บน / ล่าง lock numbers by weekday; opens on the next draw's day.
class LockFeature extends StatefulWidget {
  final Widget header;
  /// Reference time: the next draw opens on its weekday.
  final DateTime now;
  const LockFeature({super.key, required this.header, required this.now});

  @override
  State<LockFeature> createState() => _LockFeatureState();
}

class _LockFeatureState extends State<LockFeature> {
  late final DateTime _draw = nextDrawDate(widget.now);
  late int _lockDay = weekdayIndex(_draw);

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _lockBody());

  List<Widget> _lockBody() {
    final isDrawDay = _lockDay == weekdayIndex(_draw);
    Widget group(String title, List<String> nums, {required bool top}) => Container(
          decoration: BoxDecoration(
            gradient: top
                ? blueGlowGradient
                : null,
            color: top ? null : C.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.goldBorder, width: 1.5),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: sans(17, weight: FontWeight.w700, color: C.goldLight)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: top ? 1.7 : 1.85,
              children: [
                for (final n in nums)
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: top ? goldGradient : null,
                      color: top ? null : C.input,
                      borderRadius: BorderRadius.circular(top ? 14 : 18),
                      border: Border.all(color: top ? C.goldDeep : C.gold, width: top ? 1 : 1.8),
                      boxShadow: top
                          ? const [BoxShadow(color: C.shadow, blurRadius: 4, offset: Offset(0, 2))]
                          : null,
                    ),
                    // Fixed-ratio tile: very large text shrinks to fit inside it.
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        n,
                        style: serif(
                          top ? 26 : 30,
                          weight: FontWeight.w800,
                          color: top ? C.onGold : C.goldLight,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ]),
        );
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
        child: Row(children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SelectPill(
                  text: dayShort[i],
                  selected: _lockDay == i,
                  onTap: () => setState(() => _lockDay = i),
                  radius: 10,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            isDrawDay ? 'งวด ${thaiDate(_draw)} · ออกวัน${dayFull[_lockDay]}' : 'ถ้าสลากออกวัน${dayFull[_lockDay]}',
            textAlign: TextAlign.center,
            style: serif(18, color: C.accent),
          ),
          const SizedBox(height: 12),
          group('เลขบน', lockTop[_lockDay], top: true),
          const SizedBox(height: 12),
          group('เลขล่าง', lockBottom[_lockDay], top: false),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: C.highlight.withValues(alpha: .5), borderRadius: BorderRadius.circular(12)),
            child: Text('$lockNote\n(เลข "ล็อค" ตามกำลังวัน $lockSource)',
                style: sans(13, color: C.textSoft, height: 1.7)),
          ),
        ]),
      ),
    ];
  }
}
