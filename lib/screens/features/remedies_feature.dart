import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../data/nightmare_remedies.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 3: the 18 nightmare remedies as cards; the long intro folds away.
class RemediesFeature extends StatefulWidget {
  final Widget header;
  const RemediesFeature({super.key, required this.header});

  @override
  State<RemediesFeature> createState() => _RemediesFeatureState();
}

class _RemediesFeatureState extends State<RemediesFeature> {
  bool _remedyIntroOpen = false;

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _remediesBody());

  List<Widget> _remediesBody() {
    // badge pill helper: ทายว่า (dark/gold) or วิธีแก้ (muted/accent-outline)
    Widget label(String text, String body, {bool dark = true}) {
      final bg = dark ? C.brand : C.muted;
      final fg = dark ? C.goldLight : C.accent;
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.only(top: 2, right: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: dark ? null : Border.all(color: C.accent.withAlpha(100), width: 1),
            ),
            child: Text(text, style: sans(12, weight: FontWeight.w600, color: fg)),
          ),
          Expanded(child: Text(body, style: sans(14, color: dark ? C.textSoft : C.textBody, height: 1.7))),
        ]),
      );
    }

    String num(int n) => n.toString().split('').map((d) => thaiDigits[int.parse(d)]).join();
    // 18 short items: no search box (the owner asked for it to go; people read them all).
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('เคล็ดแก้ฝัน ${num(remedies.length)} ข้อ', style: serif(18, color: C.accent)),
          const SizedBox(height: 12),
            for (final (i, r) in remedies.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // numbered circle (book numbering)
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: C.brand,
                        shape: BoxShape.circle,
                        border: Border.all(color: C.gold, width: 1.5),
                      ),
                      // Fixed-size circle: very large text shrinks to fit inside it.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(num(i + 1), style: serif(14, color: C.goldLight, height: 1.2)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('ฝันว่า${r.dream}', style: sans(16, weight: FontWeight.w600)),
                        label('ทายว่า', r.omen, dark: true),
                        label('วิธีแก้', r.cure, dark: false),
                      ]),
                    ),
                  ]),
                ),
              ),

          // ── Closing box ──
          ...[
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: C.brand,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.goldDeep, width: 2),
              ),
              child: Text(remedyClosing, style: sans(14, color: C.onBrand, height: 1.8)),
            ),
            const SizedBox(height: 12),
            AppCard(
              onTap: () => setState(() => _remedyIntroOpen = !_remedyIntroOpen),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text('อ่านเพิ่มเติม', style: serif(16, color: C.accent))),
                  Icon(_remedyIntroOpen ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: C.accent),
                ]),
                if (_remedyIntroOpen)
                  for (final p in remedyIntro)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(p, style: sans(14, color: C.textBody, height: 1.8)),
                    ),
              ]),
            ),
          ],
        ]),
      ),
    ];
  }
}
