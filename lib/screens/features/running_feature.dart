import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../data/formulas.dart';
import '../../data/running_numbers.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 10: the book's running-number table by the draw's weekday; opens on the next draw.
class RunningFeature extends StatefulWidget {
  final Widget header;
  /// Reference time: the next draw opens on its weekday.
  final DateTime now;
  const RunningFeature({super.key, required this.header, required this.now});

  @override
  State<RunningFeature> createState() => _RunningFeatureState();
}

class _RunningFeatureState extends State<RunningFeature> {
  late final DateTime _draw = nextDrawDate(widget.now);
  late int _runDay = weekdayIndex(_draw);

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _runningBody());

  List<Widget> _runningBody() {
    final nums = runningByDrawDay[_runDay];
    final isDrawDay = _runDay == weekdayIndex(_draw);
    return [
      WeekdayPills(selected: _runDay, onSelect: (i) => setState(() => _runDay = i)),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [C.brandBright, C.brand],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.goldDeep, width: 2),
            boxShadow: const [BoxShadow(color: C.shadow, blurRadius: 18, offset: Offset(0, 6))],
          ),
          child: Column(children: [
            Text(
              isDrawDay ? 'งวด ${thaiDate(_draw)} ออกวัน${dayFull[_runDay]}' : 'ถ้าสลากออกวัน${dayFull[_runDay]}',
              style: sans(14, color: C.gold),
            ),
            const SizedBox(height: 2),
            Text('งวดนั้นจะมีเลขวิ่ง', style: sans(13, color: C.onBrandMuted)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (final (i, n) in nums.indexed) ...[
                if (i > 0) const SizedBox(width: 10),
                DigitBox(n, width: 60, height: 70, fontSize: 36),
              ],
            ]),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(runningIntro, style: sans(14, color: C.textBody, height: 1.8)),
          const SizedBox(height: 14),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: C.brand,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Text(runningTableTitle, textAlign: TextAlign.center, style: serif(16, color: C.goldLight)),
              ),
              for (var i = 0; i < 7; i++)
                Container(
                  color: i == _runDay ? C.highlight : null,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(children: [
                    Expanded(
                      child: Text('วัน${dayFull[i]}',
                          style: sans(15, weight: i == _runDay ? FontWeight.w700 : FontWeight.w400)),
                    ),
                    Text(runningByDrawDay[i].join('   '), style: serif(18, color: C.accent)),
                  ]),
                ),
            ]),
          ),
        ]),
      ),
    ];
  }
}
