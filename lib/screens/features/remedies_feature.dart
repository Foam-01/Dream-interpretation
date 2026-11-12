import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../data/nightmare_remedies.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 3: the 18 nightmare remedies as cards, as in the design: a search box in the header
/// (owner request, Nov 2026), the count in the subtitle, and tinted ทายว่า / วิธีแก้ tags.
/// The long intro folds away.
class RemediesFeature extends StatefulWidget {
  final FeatureHeader header;
  const RemediesFeature({super.key, required this.header});

  @override
  State<RemediesFeature> createState() => _RemediesFeatureState();
}

class _RemediesFeatureState extends State<RemediesFeature> {
  bool _remedyIntroOpen = false;
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.header;
    return FeatureList(
      header: FeatureHeader(
        backLabel: h.backLabel,
        onBack: h.onBack,
        title: h.title,
        sub: '${h.sub} · ${remedies.length} ข้อ',
        bottom: SearchField(
          fieldKey: const ValueKey('remedy-search'),
          controller: _query,
          hint: 'ฝันร้ายเรื่องอะไร เช่น ตกน้ำ',
          onChanged: () => setState(() {}),
        ),
      ),
      children: _remediesBody(),
    );
  }

  List<Widget> _remediesBody() {
    // Tag + text: ทายว่า tinted warm (an omen), วิธีแก้ tinted aqua (what to do), as in the design.
    Widget label(String text, String body, Color tint, Color fg) => Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            margin: const EdgeInsets.only(top: 3, right: 10),
            decoration: BoxDecoration(color: tint.withValues(alpha: .16), borderRadius: BorderRadius.circular(8)),
            child: Text(
              text,
              style: sans(12, weight: FontWeight.w700, color: fg),
            ),
          ),
          Expanded(
            child: Text(body, style: sans(15, color: C.textBody, height: 1.6)),
          ),
        ],
      ),
    );

    String num(int n) => n.toString().split('').map((d) => thaiDigits[int.parse(d)]).join();
    final q = _query.text.trim();
    // Filtering keeps the book's numbering.
    final shown = [
      for (final (i, r) in remedies.indexed)
        if (q.isEmpty || r.dream.contains(q) || r.omen.contains(q) || r.cure.contains(q)) (i, r),
    ];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (q.isNotEmpty) ...[
              Text(
                shown.isEmpty ? 'ไม่พบเคล็ดแก้ฝันที่มีคำนี้ ลองคำสั้นลง' : 'พบ ${shown.length} ข้อ',
                style: sans(14, color: C.textSoft),
              ),
              const SizedBox(height: 12),
            ],
            for (final (i, r) in shown)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ฝันว่า${r.dream}', style: sans(16, weight: FontWeight.w700)),
                            label('ทายว่า', r.omen, C.warning, C.warning),
                            label('วิธีแก้', r.cure, C.aqua, C.aquaText),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('อ่านเพิ่มเติม', style: serif(16, color: C.accent)),
                        ),
                        Icon(_remedyIntroOpen ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: C.accent),
                      ],
                    ),
                    if (_remedyIntroOpen)
                      for (final p in remedyIntro)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(p, style: sans(14, color: C.textBody, height: 1.8)),
                        ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ];
  }
}
