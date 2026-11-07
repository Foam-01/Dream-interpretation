import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../data/draw_numbers.dart';
import '../../data/formulas.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 8: the next two draws' lead numbers, then the book's weekday table.
class DrawFeature extends StatefulWidget {
  final Widget header;
  /// Reference time: the next draw opens on its weekday.
  final DateTime now;
  const DrawFeature({super.key, required this.header, required this.now});

  @override
  State<DrawFeature> createState() => _DrawFeatureState();
}

class _DrawFeatureState extends State<DrawFeature> {
  late final DateTime _draw = nextDrawDate(widget.now);

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _drawBody());

  List<Widget> _drawBody() {
    final first = _draw;
    final second = nextDrawDate(first.add(const Duration(days: 1)));
    Widget cell(String text, {bool head = false, bool on = false}) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9),
            color: on ? C.highlight : null,
            child: Text(text,
                textAlign: TextAlign.center,
                style: head
                    ? sans(13, weight: FontWeight.w600, color: C.goldLight)
                    : serif(16, color: C.accent, weight: on ? FontWeight.w800 : FontWeight.w700)),
          ),
        );
    bool isNext(int day, int col) =>
        [first, second].any((d) => weekdayIndex(d) == day && (drawRound(d) == 1 ? 0 : 1) == col);
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(children: [
          for (final (drawIndex, d) in [first, second].indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: drawIndex == 0
                      ? blueGlowGradient
                      : null,
                  color: drawIndex == 0 ? null : C.brand,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.goldDeep, width: 2),
                  boxShadow: const [BoxShadow(color: C.shadow, blurRadius: 20, offset: Offset(0, 8))],
                ),
                child: Column(children: [
                  Text('งวด ${thaiDate(d)} ออกวัน${dayFull[weekdayIndex(d)]}', style: sans(14, color: C.gold)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    for (final (i, n) in drawLeadFor(drawRound(d), weekdayIndex(d)).indexed) ...[
                      if (i > 0) const SizedBox(width: 10),
                      DigitBox(n, width: 52, height: 60, fontSize: 30),
                    ],
                  ]),
                ]),
              ),
            ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(drawIntro, style: sans(14, color: C.textBody, height: 1.8)),
          const SizedBox(height: 14),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              Container(
                decoration: const BoxDecoration(
                  color: C.brand,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(children: [cell('วัน', head: true), cell('วันที่ 1', head: true), cell('วันที่ 16', head: true)]),
              ),
              for (var i = 0; i < 7; i++)
                Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text('วัน${dayFull[i]}', style: sans(14)),
                    ),
                  ),
                  cell(drawLead[i][0].join(' '), on: isNext(i, 0)),
                  cell(drawLead[i][1].join(' '), on: isNext(i, 1)),
                ]),
            ]),
          ),
        ]),
      ),
    ];
  }
}
