import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/design_data.dart';
import '../data/formulas.dart';
import '../theme.dart';
import '../widgets/ui.dart';

const _quick = [
  ('ฝ', 'ทำนายฝัน', 'dream'),
  ('ส', 'ตารางสัตว์', '5'),
  ('ป', 'แป๊ะกง 1000', '6'),
  ('๙', 'เลขเสียงโชค', '9'),
  ('๑๖', 'เลขเด่นงวด', '8'),
  ('ว', 'เลขวิ่ง', '10'),
  ('ร', 'แก้ฝันร้าย', '3'),
  ('ส', 'บทสวด', '11'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final now = DateTime.now();
    final wd = weekdayIndex(now);
    final locked = dayData('7', wd);
    final sound = dayData('9', wd);
    final running = dayData('10', wd);

    return ListView(padding: EdgeInsets.zero, children: [
      RedHeader(
        patternOpacity: .13,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(thaiDateLong(now), style: sans(13, color: C.gold)),
                const SizedBox(height: 2),
                Text('มหาทำนายฝัน', style: serif(26, weight: FontWeight.w800, color: C.goldLight)),
              ]),
            ),
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: C.gold, width: 2)),
              child: Text('๙', style: serif(18, color: C.gold)),
            ),
          ]),
          const SizedBox(height: 18),
          Semantics(
            button: true,
            label: 'ค้นหาความฝัน',
            child: GestureDetector(
              onTap: () => app.goSearch(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: C.input,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.gold, width: 1.5),
                ),
                child: Row(children: [
                  Text('⌕', style: sans(18, color: C.redBright, height: 1)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('เมื่อคืนคุณฝันเห็นอะไร...',
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(16, color: C.placeholder)),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
      Stack(children: [
        // Continues the header behind the overlapping card.
        const Positioned(top: 0, left: 0, right: 0, height: 44, child: ColoredBox(color: C.redBright)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CreamCard(
            radius: 18,
            borderWidth: 1.5,
            shadow: const [BoxShadow(color: Color(0x26781E0A), blurRadius: 24, offset: Offset(0, 8))],
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text('เลขล็อคประจำวัน${dayFull[wd]}', style: serif(16, color: C.red))),
                Text('งวด ${thaiDateShort(nextDrawDate(now))}', style: sans(12, color: C.caption)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _LockTile(label: 'บน', value: locked.tiles[0].value, dark: true)),
                const SizedBox(width: 10),
                Expanded(child: _LockTile(label: 'ล่าง', value: locked.tiles[1].value, dark: false)),
              ]),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text('ตัวเด่น', style: sans(13, color: C.inkSoft)),
                _Badge(sound.tiles[0].value, bg: C.redBright, fg: Colors.white),
                Text('ตัวกัน', style: sans(13, color: C.inkSoft)),
                _Badge(sound.tiles[1].value, bg: C.chipGrey, fg: C.ink),
                Text('เลขวิ่ง', style: sans(13, color: C.inkSoft)),
                Text(running.tiles.map((t) => t.value).join(' · '),
                    style: sans(13, weight: FontWeight.w700, color: C.redBright)),
              ]),
            ]),
          ),
        ),
      ]),
      const SectionLabel('หมวดยอดนิยม'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 98),
          children: [
            for (final (g, t, k) in _quick)
              Semantics(
                button: true,
                label: t,
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () => k == 'dream' ? app.goSearch(resetCat: true) : app.openFeat(k),
                  child: Column(children: [
                    GlyphTile(g),
                    const SizedBox(height: 6),
                    Text(t,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
                        style: sans(12, height: 1.3)),
                  ]),
                ),
              ),
          ],
        ),
      ),
      const SectionLabel('ฝันยอดฮิตวันนี้'),
      SizedBox(
        height: 152,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) => DreamCard(index: i, width: 120, number: dreams[i].firstTwo),
        ),
      ),
      const SizedBox(height: 24),
    ]);
  }
}

class _LockTile extends StatelessWidget {
  final String label, value;
  final bool dark;
  const _LockTile({required this.label, required this.value, required this.dark});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: dark ? C.red : C.tileLight,
          borderRadius: BorderRadius.circular(12),
          border: dark ? null : Border.all(color: C.goldBorder),
        ),
        child: Column(children: [
          Text(label, style: sans(12, color: dark ? C.gold : C.red)),
          Text(value,
              style: serif(34, weight: FontWeight.w800, color: dark ? C.goldLight : C.red, letterSpacing: 4, height: 1.3)),
        ]),
      );
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const _Badge(this.text, {required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
        child: Text(text, style: sans(13, weight: FontWeight.w700, color: fg)),
      );
}

/// Card with image placeholder + dream name + number (home hot list, digit screen).
class DreamCard extends StatelessWidget {
  final int index;
  final double? width;
  final String number;
  final double numberSize;
  const DreamCard({super.key, required this.index, required this.number, this.width, this.numberSize = 16});

  @override
  Widget build(BuildContext context) {
    final d = dreams[index];
    return SizedBox(
      width: width,
      child: CreamCard(
        radius: 14,
        padding: EdgeInsets.zero,
        onTap: () => AppScope.of(context).openDream(index),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          ImagePlaceholder('ภาพ ${d.name}', height: 80, width: double.infinity),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ฝันเห็น${d.name}',
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(14, weight: FontWeight.w600)),
              Text(number, style: serif(numberSize, color: C.redBright, height: 1.3)),
            ]),
          ),
        ]),
      ),
    );
  }
}
