import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/category_ch.dart';
import '../data/category_k.dart';
import '../data/category_kh.dart';
import '../data/category_khr.dart';
import '../data/category_khw.dart';
import '../data/category_ng.dart';
import '../data/design_data.dart';
import '../data/formulas.dart';
import '../theme.dart';
import '../widgets/ui.dart';
import 'home_screen.dart' show DreamCard;
import 'letter_category_section.dart';


/// Category shown by each FeatType.letter feature.
const _letterCategories = {
  '13': letterKCategoryId,
  '14': letterKhCategoryId,
  '15': letterKhwCategoryId,
  '16': letterKhrCategoryId,
  '17': letterNgCategoryId,
  '18': letterChCategoryId,
};
class FeatureScreen extends StatefulWidget {
  final String featKey;

  /// Reference time: initial weekday of day-based features and draw dates (feature 8).
  final DateTime now;
  const FeatureScreen({super.key, required this.featKey, required this.now});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  // Initialised once per State from the injected time (same lifecycle as before).
  late int _day = weekdayIndex(widget.now);
  int _digit = 5;
  int _hund = 0;
  int _pae = 59;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final k = widget.featKey;
    final f = feats[k]!;
    final body = switch (f.type) {
      FeatType.day => _dayBody(k),
      FeatType.steps => _stepsBody(k),
      FeatType.animals => _animalsBody(),
      FeatType.pae => _paeBody(),
      FeatType.digit => _digitBody(),
      FeatType.table => _tableBody(),
      FeatType.draw => _drawBody(),
      FeatType.letter => [
          LetterCategorySection(categoryId: _letterCategories[k]!),
        ],
    };
    return ListView(padding: EdgeInsets.zero, children: [
      FeatureHeader(
        backLabel: menus[app.tab]?.title ?? 'กลับ',
        onBack: () => app.goTab(app.tab),
        title: f.title,
        sub: f.sub,
      ),
      ...body,
    ]);
  }

  // ---- Day-based formulas (1, 7, 9, 10) ----
  List<Widget> _dayBody(String k) {
    final dd = dayData(k, _day);
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
                  selected: _day == i,
                  onTap: () => setState(() => _day = i),
                  radius: 10,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Text('${k == '1' ? 'เลือกวันเกิดของคุณ · ' : ''}วัน${dayFull[_day]}', style: sans(13, color: C.caption)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: CreamCard(
          borderWidth: 1.5,
          child: Column(children: [
            if (dd.image != null) ...[
              ImagePlaceholder(dd.image!,
                  height: 140,
                  width: double.infinity,
                  radius: 12,
                  fontSize: 11,
                  band: 8,
                  border: Border.all(color: C.goldBorder)),
              const SizedBox(height: 14),
            ],
            Row(children: [
              for (final (i, t) in dd.tiles.indexed) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                      color: t.dark ? C.red : C.tileLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: C.goldBorder, width: 1.5),
                    ),
                    child: Column(children: [
                      Text(t.label, style: sans(12, color: t.dark ? C.gold : C.imgText)),
                      Text(t.value,
                          style: serif(30,
                              weight: FontWeight.w800,
                              color: t.dark ? C.goldLight : C.red,
                              letterSpacing: 3,
                              height: 1.3)),
                    ]),
                  ),
                ),
              ],
            ]),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: CreamCard(
          padding: EdgeInsets.zero,
          child: Column(children: [
            for (final (i, r) in dd.rows.indexed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: i < dd.rows.length - 1 ? const Border(bottom: BorderSide(color: C.divider)) : null,
                ),
                child: Row(children: [
                  Expanded(child: Text(r[0], style: sans(15, color: C.inkMuted))),
                  r[1].contains('★') || r[1].contains('☆')
                      ? _Stars(r[1])
                      : Text(r[1], style: sans(15, weight: FontWeight.w700, color: C.red)),
                ]),
              ),
          ]),
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: C.red, borderRadius: BorderRadius.circular(16)),
        child: Text(dd.note, style: sans(14, color: C.onRed, height: 1.7)),
      ),
    ];
  }

  // ---- Step-by-step rituals (3, 4, 11) ----
  List<Widget> _stepsBody(String k) {
    final list = steps[k] ?? const [];
    final prayer = prayers[k];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(children: [
          for (final (i, s) in list.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CreamCard(
                padding: const EdgeInsets.all(14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: C.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: C.gold, width: 1.5),
                    ),
                    child: Text(thaiDigits[i + 1], style: serif(15, color: C.goldLight, height: 1.2)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s[0], style: sans(16, weight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(s[1], style: sans(14, color: C.inkSoft, height: 1.7)),
                    ]),
                  ),
                ]),
              ),
            ),
          if (prayer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: C.red,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.goldDeep, width: 2),
              ),
              child: Column(children: [
                Text(prayer[0], style: sans(13, color: C.gold)),
                const SizedBox(height: 6),
                SelectableText(prayer[1],
                    textAlign: TextAlign.center, style: serif(17, color: C.goldLight, height: 1.9)),
              ]),
            ),
        ]),
      ),
    ];
  }

  // ---- Animal table (5) ----
  List<Widget> _animalsBody() {
    Widget row(List<Widget> cells, {Color? bg, bool last = false}) => Container(
          color: bg,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: null,
          foregroundDecoration:
              last || bg != null ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: C.divider))),
          child: Row(children: [
            SizedBox(width: 52, child: cells[0]),
            const SizedBox(width: 8),
            Expanded(child: cells[1]),
            const SizedBox(width: 8),
            SizedBox(width: 64, child: Center(child: cells[2])),
            const SizedBox(width: 8),
            SizedBox(width: 64, child: Center(child: cells[3])),
          ]),
        );
    final head = sans(13, weight: FontWeight.w600, color: C.goldLight);
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: CreamCard(
          borderWidth: 1.5,
          padding: EdgeInsets.zero,
          child: Column(children: [
            row([Text('รูป', style: head), Text('ชื่อสัตว์', style: head), Text('เลขเด่น', style: head), Text('2 ตัว', style: head)],
                bg: C.red),
            for (final (i, a) in animals.indexed)
              row([
                const ImagePlaceholder('ภาพ', width: 44, height: 44, radius: 10, fontSize: 8, band: 5),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a[0], style: sans(15, weight: FontWeight.w600)),
                  Text(a[1], style: sans(12, color: C.caption)),
                ]),
                Text(a[2], style: serif(20, weight: FontWeight.w800, color: C.redBright)),
                Text('${a[3]} · ${a[3][1]}${a[3][0]}', style: sans(14, weight: FontWeight.w600, color: C.inkSoft)),
              ], last: i == animals.length - 1),
          ]),
        ),
      ),
    ];
  }

  // ---- Pae Kong 000-999 (6) ----
  List<Widget> _paeBody() {
    final cur = paeOf(_pae);
    return [
      // Row height follows the pills (was a fixed 48 that clipped text at large scale).
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        child: Row(children: [
          for (var i = 0; i < 10; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            SelectPill(
              text: '${i}00–${i}99',
              selected: _hund == i,
              onTap: () => setState(() {
                _hund = i;
                _pae = i * 100;
              }),
            ),
          ],
        ]),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: C.red,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.goldDeep, width: 2),
        ),
        child: Row(children: [
          ImagePlaceholder('ภาพแป๊ะกง\n${cur.num}', width: 92, height: 92, radius: 12, fontSize: 9),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cur.num, style: serif(34, weight: FontWeight.w800, color: C.goldLight, letterSpacing: 3, height: 1.1)),
              Text(cur.name, style: sans(16, weight: FontWeight.w600, color: C.onRed)),
              const SizedBox(height: 2),
              Text('เลขกลับ ${cur.rev}', style: sans(12, color: C.gold)),
            ]),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ContentGrid(
          columns: 5,
          spacing: 6,
          runSpacing: 6,
          minRowHeight: 52,
          children: [for (var i = 0; i < 100; i++) _paeCell(_hund * 100 + i)],
        ),
      ),
    ];
  }

  Widget _paeCell(int n) {
    final p = paeOf(n);
    final sel = n == _pae;
    return Semantics(
      button: true,
      selected: sel,
      child: GestureDetector(
        onTap: () => setState(() => _pae = n),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          decoration: BoxDecoration(
            color: sel ? C.red : C.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: C.goldBorder),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(p.num, style: serif(16, color: sel ? C.goldLight : C.red, height: 1.2)),
            Text(p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sans(10, color: sel ? C.onRedMuted : C.caption, height: 1.2)),
          ]),
        ),
      ),
    );
  }

  // ---- Lucky digits 0-9 summary (2) ----
  List<Widget> _digitBody() {
    final l = lore[_digit];
    final list = [
      for (final d in dreams)
        if (d.digits.contains('$_digit')) d,
    ];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.25,
          children: [
            for (var i = 0; i < 10; i++)
              SelectPill(
                text: '$i',
                selected: _digit == i,
                onTap: () => setState(() => _digit = i),
                radius: 12,
                padding: EdgeInsets.zero,
                fontSize: 24,
                weight: FontWeight.w800,
              ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: CreamCard(
          borderWidth: 1.5,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: SizedBox(
            width: double.infinity,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('เลข ${l[0]} · ${l[1]}', style: serif(16, color: C.red)),
              const SizedBox(height: 4),
              Text(l[2], style: sans(14, color: C.inkSoft, height: 1.7)),
            ]),
          ),
        ),
      ),
      SectionLabel('ความฝันที่ให้เลข ${l[0]}', size: 15, padding: const EdgeInsets.fromLTRB(16, 4, 16, 8)),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: list.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('ยังไม่มีความฝันที่ให้เลขนี้', textAlign: TextAlign.center, style: sans(14, color: C.caption)),
              )
            : GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.15,
                children: [for (final d in list) DreamCard(dreamId: d.id, name: d.name, number: d.two, numberSize: 15)],
              ),
      ),
    ];
  }

  // ---- Number lore table (12) ----
  List<Widget> _tableBody() => [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(children: [
            for (final l in lore)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CreamCard(
                  radius: 14,
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    DigitBox(l[0], width: 48, height: 48, fontSize: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l[1], style: sans(15, weight: FontWeight.w600)),
                        Text(l[2], style: sans(13, color: C.inkMuted, height: 1.6)),
                      ]),
                    ),
                  ]),
                ),
              ),
          ]),
        ),
      ];

  // ---- Draw formulas (8) ----
  List<Widget> _drawBody() {
    final first = nextDrawDate(widget.now);
    final d1 = first.day == 1 ? first : DateTime(first.year, first.month + 1, 1);
    final d16 = first.day == 16 ? first : DateTime(d1.year, d1.month, 16);
    final draws = [
      ('งวดวันที่ 1', d1, 'สูตร: เลขท้าย 2 ตัวงวดก่อน + เลขวันพระ แล้วถอดหลักหน่วย', ['4', '7', '9'], '47 · 79 · 94'),
      ('งวดวันที่ 16', d16, 'สูตร: เลขหน้า 3 ตัว × กำลังดาวประจำวันออกรางวัล', ['2', '5', '8'], '25 · 58 · 82'),
    ];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(children: [
          for (final (t, date, formula, digits, pairs) in draws)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CreamCard(
                borderWidth: 1.5,
                padding: EdgeInsets.zero,
                child: Column(children: [
                  Container(
                    color: C.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(children: [
                      Expanded(child: Text(t, style: serif(16, color: C.goldLight))),
                      Text(thaiDate(date), style: sans(12, color: C.gold)),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(children: [
                      Text(formula, style: sans(13, color: C.inkMuted, height: 1.6)),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        for (final n in digits)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: DigitBox(n, width: 52, height: 60, fontSize: 28),
                          ),
                      ]),
                      const SizedBox(height: 12),
                      Text.rich(TextSpan(style: sans(14, color: C.inkSoft), children: [
                        const TextSpan(text: 'เลขคู่เด่น '),
                        TextSpan(text: pairs, style: sans(17, weight: FontWeight.w700, color: C.redBright)),
                      ])),
                    ]),
                  ),
                ]),
              ),
            ),
          Text('เลขจากสูตรเพื่อความบันเทิง โปรดใช้วิจารณญาณ', textAlign: TextAlign.center, style: sans(12, color: C.caption)),
        ]),
      ),
    ];
  }
}

/// Renders "★★★☆☆" with icons (Thai fonts lack these glyphs).
class _Stars extends StatelessWidget {
  final String value;
  const _Stars(this.value);

  @override
  Widget build(BuildContext context) => Semantics(
        label: '${'★'.allMatches(value).length} จาก ${value.length} ดาว',
        excludeSemantics: true,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          for (final ch in value.split(''))
            Icon(ch == '★' ? Icons.star : Icons.star_border, size: 16, color: C.red),
        ]),
      );
}
