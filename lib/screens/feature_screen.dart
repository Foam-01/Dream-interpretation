import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/category_ang.dart';
import '../data/category_b.dart';
import '../data/category_ch.dart';
import '../data/category_chc.dart';
import '../data/category_chg.dart';
import '../data/category_d.dart';
import '../data/category_f.dart';
import '../data/category_fan.dart';
import '../data/category_hip.dart';
import '../data/category_k.dart';
import '../data/category_kh.dart';
import '../data/category_khr.dart';
import '../data/category_khw.dart';
import '../data/category_l.dart';
import '../data/category_m.dart';
import '../data/category_n.dart';
import '../data/category_ng.dart';
import '../data/category_p.dart';
import '../data/category_phan.dart';
import '../data/category_phueng.dart';
import '../data/category_r.dart';
import '../data/category_s.dart';
import '../data/category_sala.dart';
import '../data/category_samphao.dart';
import '../data/category_suea.dart';
import '../data/category_t.dart';
import '../data/category_thahan.dart';
import '../data/category_thong.dart';
import '../data/category_thung.dart';
import '../data/category_w.dart';
import '../data/category_y.dart';
import '../data/category_yak.dart';
import '../data/design_data.dart';
import '../data/digit_lore.dart';
import '../data/digit_summary.dart';
import '../data/draw_numbers.dart';
import '../data/dream_chant.dart';
import '../data/formulas.dart';
import '../data/running_numbers.dart';
import '../data/sound_numbers.dart';
import '../data/nightmare_remedies.dart';
import '../theme.dart';
import '../widgets/ui.dart';
import 'letter_category_section.dart';


/// Category shown by each FeatType.letter feature.
const _letterCategories = {
  '13': letterKCategoryId,
  '14': letterKhCategoryId,
  '15': letterKhwCategoryId,
  '16': letterKhrCategoryId,
  '17': letterNgCategoryId,
  '18': letterChCategoryId,
  '19': letterChgCategoryId,
  '20': letterChcCategoryId,
  '21': letterSCategoryId,
  '22': letterYCategoryId,
  '23': letterDCategoryId,
  '24': letterTCategoryId,
  '25': letterThungCategoryId,
  '26': letterThahanCategoryId,
  '27': letterThongCategoryId,
  '28': letterNCategoryId,
  '29': letterBCategoryId,
  '30': letterPCategoryId,
  '31': letterPhuengCategoryId,
  '32': letterFCategoryId,
  '33': letterPhanCategoryId,
  '34': letterFanCategoryId,
  '35': letterSamphaoCategoryId,
  '36': letterMCategoryId,
  '37': letterYakCategoryId,
  '38': letterRCategoryId,
  '39': letterLCategoryId,
  '40': letterWCategoryId,
  '41': letterSalaCategoryId,
  '42': letterSueaCategoryId,
  '43': letterHipCategoryId,
  '44': letterAngCategoryId,
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
  int? _digit;
  final _digitKeys = [for (var i = 0; i < 10; i++) GlobalKey()];
  int _hund = 0;
  int _pae = 59;
  late final DateTime _draw = nextDrawDate(widget.now);
  late int _runDay = weekdayIndex(_draw);
  late int _soundDay = weekdayIndex(_draw);
  final _paeQuery = TextEditingController();
  final _animalQuery = TextEditingController();

  @override
  void dispose() {
    _paeQuery.dispose();
    _animalQuery.dispose();
    super.dispose();
  }

  String _paeWord = '';
  final _paeCardKey = GlobalKey();

  /// One box for both: 1–3 digits select that number and its hundred block; words list the matching pictures.
  void _searchPae(String q) {
    final t = q.trim();
    final n = RegExp(r'^\d{1,3}$').hasMatch(t) ? int.parse(t) : null;
    setState(() {
      _paeWord = n == null ? t : '';
      if (n != null) {
        _hund = n ~/ 100;
        _pae = n;
      }
    });
  }
  bool _remedyIntroOpen = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final k = widget.featKey;
    final f = feats[k]!;
    final body = switch (f.type) {
      FeatType.day => _dayBody(k),
      FeatType.steps => _stepsBody(k),
      FeatType.remedies => _remediesBody(),
      FeatType.chant => _chantBody(),
      FeatType.running => _runningBody(),
      FeatType.sound => _soundBody(),
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

  // ---- Day-based formulas (7) ----
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
        child: Text('วัน${dayFull[_day]}', style: sans(13, color: C.caption)),
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

  // ---- Step-by-step rituals (4) ----
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
                if (prayer[0].isNotEmpty) ...[
                  Text(prayer[0], style: sans(13, color: C.gold)),
                  const SizedBox(height: 6),
                ],
                SelectableText(prayer[1],
                    textAlign: TextAlign.center, style: serif(17, color: C.goldLight, height: 1.9)),
              ]),
            ),
        ]),
      ),
    ];
  }

  // ---- Sound numbers (9): the book's lead / block groups by the draw's weekday; opens on the next draw ----
  List<Widget> _soundBody() {
    final lead = soundLead[_soundDay];
    final block = soundBlock[_soundDay];
    final isDrawDay = _soundDay == weekdayIndex(_draw);
    Widget group(String title, List<String> nums, {required bool dark}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: serif(16, color: C.red)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final n in nums)
                Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: dark ? C.red : C.chipGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: dark ? C.goldDeep : C.goldBorder),
                  ),
                  child: Text(n, style: serif(18, color: dark ? C.goldLight : C.ink, height: 1.2)),
                ),
            ]),
          ],
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
                  selected: _soundDay == i,
                  onTap: () => setState(() => _soundDay = i),
                  radius: 10,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: C.red,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.goldDeep, width: 2),
          ),
          child: Column(children: [
            if (soundImages[_soundDay] case final img?) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(img, fit: BoxFit.cover, semanticLabel: 'ภาพประจำวัน${dayFull[_soundDay]}'),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              isDrawDay ? 'งวด ${thaiDate(_draw)} สลากออกวัน${dayFull[_soundDay]}' : 'สลากออกวัน${dayFull[_soundDay]}',
              textAlign: TextAlign.center,
              style: serif(17, color: C.goldLight),
            ),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          group('กลุ่มเลขตัวเด่น', lead, dark: true),
          const SizedBox(height: 18),
          group('กลุ่มเลขตัวกัน', block, dark: false),
        ]),
      ),
    ];
  }

  // ---- Running numbers (10): the book's table by the draw's weekday; opens on the next draw ----
  List<Widget> _runningBody() {
    final nums = runningByDrawDay[_runDay];
    final isDrawDay = _runDay == weekdayIndex(_draw);
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
                  selected: _runDay == i,
                  onTap: () => setState(() => _runDay = i),
                  radius: 10,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: C.red,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.goldDeep, width: 2),
          ),
          child: Column(children: [
            Text(
              isDrawDay ? 'งวด ${thaiDate(_draw)} ออกวัน${dayFull[_runDay]}' : 'ถ้าสลากออกวัน${dayFull[_runDay]}',
              style: sans(14, color: C.gold),
            ),
            const SizedBox(height: 2),
            Text('งวดนั้นจะมีเลขวิ่ง', style: sans(13, color: C.onRedMuted)),
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
          Text(runningIntro, style: sans(14, color: C.inkBody, height: 1.8)),
          const SizedBox(height: 14),
          CreamCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: C.red,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Text(runningTableTitle, textAlign: TextAlign.center, style: serif(16, color: C.goldLight)),
              ),
              for (var i = 0; i < 7; i++)
                Container(
                  color: i == _runDay ? C.tileLight : null,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(children: [
                    Expanded(
                      child: Text('วัน${dayFull[i]}',
                          style: sans(15, weight: i == _runDay ? FontWeight.w700 : FontWeight.w400)),
                    ),
                    Text(runningByDrawDay[i].join('   '), style: serif(18, color: C.red)),
                  ]),
                ),
            ]),
          ),
        ]),
      ),
    ];
  }

  // ---- Dream chant (11): the owner's book page — intro, then the three stanzas in one card ----
  List<Widget> _chantBody() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(chantIntro, style: sans(14, color: C.inkBody, height: 1.8)),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            decoration: BoxDecoration(
              color: C.red,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.goldDeep, width: 2),
            ),
            child: Column(children: [
              for (final (i, stanza) in chantStanzas.indexed) ...[
                if (i > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Container(width: 48, height: 1, color: C.goldDeep),
                  ),
                SelectableText(stanza.join('\n'),
                    textAlign: TextAlign.center, style: serif(17, color: C.goldLight, height: 1.9)),
              ],
            ]),
          ),
        ]),
      ),
    ];
  }

  // ---- Nightmare remedies (3): the owner's text — remedies first, then the closing; the long intro folds away ----
  List<Widget> _remediesBody() {
    Widget label(String text, String body, {Color color = C.inkSoft}) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 2),
              margin: const EdgeInsets.only(top: 2, right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: C.tileLight, borderRadius: BorderRadius.circular(8)),
              child: Text(text, style: sans(12, weight: FontWeight.w600, color: C.redDeep)),
            ),
            Expanded(child: Text(body, style: sans(14, color: color, height: 1.7))),
          ]),
        );
    String num(int n) => n.toString().split('').map((d) => thaiDigits[int.parse(d)]).join();
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('เคล็ดแก้ฝัน ${num(remedies.length)} ข้อ', style: serif(18, color: C.red)),
          const SizedBox(height: 10),
          for (final (i, r) in remedies.indexed)
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
                    child: Text(num(i + 1), style: serif(14, color: C.goldLight, height: 1.2)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('ฝันว่า${r.dream}', style: sans(16, weight: FontWeight.w600)),
                      label('ทายว่า', r.omen),
                      label('วิธีแก้', r.cure, color: C.inkBody),
                    ]),
                  ),
                ]),
              ),
            ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: C.red,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.goldDeep, width: 2),
            ),
            child: Text(remedyClosing, style: sans(14, color: C.onRed, height: 1.8)),
          ),
          const SizedBox(height: 12),
          CreamCard(
            onTap: () => setState(() => _remedyIntroOpen = !_remedyIntroOpen),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text('อ่านเพิ่มเติม', style: serif(16, color: C.red))),
                Icon(_remedyIntroOpen ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: C.red),
              ]),
              if (_remedyIntroOpen)
                for (final p in remedyIntro)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(p, style: sans(14, color: C.inkBody, height: 1.8)),
                  ),
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
    final q = _animalQuery.text.trim();
    final shown = [for (final a in animals) if (q.isEmpty || a[0].contains(q) || a[2] == q || a[3].contains(q)) a];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: C.input,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.goldBorder, width: 1.5),
          ),
          child: Row(children: [
            const Icon(Icons.search, size: 18, color: C.redBright),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: const ValueKey('animal-search'),
                controller: _animalQuery,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                style: sans(16),
                decoration: InputDecoration(
                  hintText: 'ค้นหาชื่อสัตว์ เช่น งู หรือเลข',
                  hintStyle: sans(16, color: C.placeholder),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (q.isNotEmpty)
              IconButton(
                tooltip: 'ล้างคำค้นหา',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, size: 18, color: C.placeholder),
                onPressed: () => setState(_animalQuery.clear),
              ),
          ]),
        ),
      ),
      if (shown.isEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Text('ไม่พบสัตว์ที่ตรงกับ "$q"', textAlign: TextAlign.center, style: sans(14, color: C.caption)),
        )
      else
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: CreamCard(
          borderWidth: 1.5,
          padding: EdgeInsets.zero,
          child: Column(children: [
            row([Text('รูป', style: head), Text('ชื่อสัตว์', style: head), Text('เลขเด่น', style: head), Text('2 ตัว', style: head)],
                bg: C.red),
            for (final (i, a) in shown.indexed)
              row([
                const ImagePlaceholder('ภาพ', width: 44, height: 44, radius: 10, fontSize: 8, band: 5),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a[0], style: sans(15, weight: FontWeight.w600)),
                  Text(a[1], style: sans(12, color: C.caption)),
                ]),
                Text(a[2], style: serif(20, weight: FontWeight.w800, color: C.redBright)),
                Text('${a[3]} · ${a[3][1]}${a[3][0]}', style: sans(14, weight: FontWeight.w600, color: C.inkSoft)),
              ], last: i == shown.length - 1),
          ]),
        ),
      ),
    ];
  }

  // ---- Pae Kong 000-999 (6) ----
  List<Widget> _paeBody() {
    final cur = paeOf(_pae);
    final shown = _paeWord.isEmpty
        ? [for (var i = 0; i < 100; i++) _hund * 100 + i]
        : [for (var i = 0; i < 1000; i++) if (paeOf(i).name.contains(_paeWord)) i];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: C.input,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.goldBorder, width: 1.5),
          ),
          child: Row(children: [
            const Icon(Icons.search, size: 18, color: C.redBright),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: const ValueKey('pae-search'),
                controller: _paeQuery,
                onChanged: _searchPae,
                textInputAction: TextInputAction.search,
                style: sans(16),
                decoration: InputDecoration(
                  hintText: 'ค้นหาคำ เช่น ม้า หรือเลข 000–999',
                  hintStyle: sans(16, color: C.placeholder),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (_paeQuery.text.isNotEmpty)
              IconButton(
                tooltip: 'ล้างคำค้นหา',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, size: 18, color: C.placeholder),
                onPressed: () {
                  _paeQuery.clear();
                  _searchPae('');
                },
              ),
          ]),
        ),
      ),
      // Row height follows the pills (was a fixed 48 that clipped text at large scale).
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        child: Row(children: [
          for (var i = 0; i < 10; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            SelectPill(
              text: '${i}00–${i}99',
              selected: _paeWord.isEmpty && _hund == i,
              onTap: () => setState(() {
                _hund = i;
                _pae = i * 100;
                _paeWord = '';
                _paeQuery.clear();
              }),
            ),
          ],
        ]),
      ),
      Container(
        key: _paeCardKey,
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
      if (_paeWord.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            shown.isEmpty ? 'ไม่พบภาพที่มีคำว่า "$_paeWord"' : 'พบ ${shown.length} เลข ที่มีคำว่า "$_paeWord"',
            style: sans(13, color: C.caption),
          ),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ContentGrid(
          columns: 5,
          spacing: 6,
          runSpacing: 6,
          minRowHeight: 52,
          children: [for (final n in shown) _paeCell(n)],
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
        onTap: () {
          setState(() => _pae = n);
          // In a word search the list can push the big card off screen: bring it back into view.
          final card = _paeCardKey.currentContext;
          if (_paeWord.isNotEmpty && card != null) {
            Scrollable.ensureVisible(card, duration: const Duration(milliseconds: 250));
          }
        },
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

  // ---- Lucky digits 0-9 summary (2): the owner's book pages, one card per digit; pills jump to a card ----
  /// The page list builds cards lazily, so a far card may not exist yet: step down from the top until it does.
  Future<void> _jumpToDigit(ScrollPosition pos, int digit) async {
    final key = _digitKeys[digit];
    if (key.currentContext == null) pos.jumpTo(0);
    while (key.currentContext == null && pos.pixels < pos.maxScrollExtent) {
      pos.jumpTo(math.min(pos.pixels + pos.viewportDimension, pos.maxScrollExtent));
      await WidgetsBinding.instance.endOfFrame;
    }
    final target = key.currentContext;
    if (target != null && target.mounted) {
      await Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 300));
    }
  }

  List<Widget> _digitBody() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Builder(
          builder: (context) => GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.25,
            children: [
              for (final s in digitSymbols)
                SelectPill(
                  text: '${s.digit}',
                  selected: _digit == s.digit,
                  onTap: () {
                    setState(() => _digit = s.digit);
                    _jumpToDigit(Scrollable.of(context).position, s.digit);
                  },
                  radius: 12,
                  padding: EdgeInsets.zero,
                  fontSize: 24,
                  weight: FontWeight.w800,
                ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
        child: Text(digitSummaryIntro, style: sans(14, color: C.inkBody, height: 1.8)),
      ),
      for (final s in digitSymbols)
        Padding(
          key: _digitKeys[s.digit],
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: CreamCard(
            borderWidth: 1.5,
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: C.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: C.gold, width: 2),
                  ),
                  child: Text('${s.digit}', style: serif(28, weight: FontWeight.w800, color: C.goldLight, height: 1.1)),
                ),
                const SizedBox(width: 12),
                Text('เลข ${s.digit}', style: serif(18, color: C.red)),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: s.image == null
                      ? ImagePlaceholder('ภาพประกอบเลข ${s.digit}', fontSize: 11, band: 8)
                      : Image.asset(s.image!, fit: BoxFit.cover, semanticLabel: 'ภาพประกอบเลข ${s.digit}'),
                ),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'ได้แก่ ฝันเห็น ', style: sans(14, weight: FontWeight.w600, color: C.redDeep, height: 1.8)),
                  TextSpan(text: '${s.items.join(', ')} ฯลฯ'),
                ]),
                style: sans(14, color: C.inkBody, height: 1.8),
              ),
            ]),
          ),
        ),
      const SizedBox(height: 20),
    ];
  }

  // ---- Number lore (12): the owner's book pages — intro, 28 rules with the number as a badge, closing ----
  List<Widget> _tableBody() => [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(loreIntro, style: sans(14, color: C.inkBody, height: 1.8)),
            const SizedBox(height: 12),
            for (final e in loreEntries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CreamCard(
                  radius: 14,
                  padding: const EdgeInsets.all(12),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    DigitBox(e.badge, width: 48, height: 48, fontSize: e.badge.length > 1 ? 18 : 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          if (e.seen case final seen?) ...[
                            const TextSpan(text: 'ถ้าฝันเห็น '),
                            TextSpan(text: seen, style: sans(14, weight: FontWeight.w700, color: C.redDeep, height: 1.7)),
                            TextSpan(text: e.text.substring('ถ้าฝันเห็น '.length + seen.length)),
                          ] else
                            TextSpan(text: e.text),
                        ]),
                        style: sans(14, color: C.inkBody, height: 1.7),
                      ),
                    ),
                  ]),
                ),
              ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: C.red,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.goldDeep, width: 2),
              ),
              child: Text(loreClosing, style: sans(14, color: C.onRed, height: 1.8)),
            ),
          ]),
        ),
      ];

  // ---- Draw lead numbers (8): the book's table (weekday × the 1st / the 16th); the next two draws first ----
  List<Widget> _drawBody() {
    final first = _draw;
    final second = first.day == 1 ? DateTime(first.year, first.month, 16) : DateTime(first.year, first.month + 1, 1);
    Widget cell(String text, {bool head = false, bool on = false}) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9),
            color: on ? C.tileLight : null,
            child: Text(text,
                textAlign: TextAlign.center,
                style: head
                    ? sans(13, weight: FontWeight.w600, color: C.goldLight)
                    : serif(16, color: on ? C.redDeep : C.red, weight: on ? FontWeight.w800 : FontWeight.w700)),
          ),
        );
    bool isNext(int day, int col) =>
        [first, second].any((d) => weekdayIndex(d) == day && (d.day == 1 ? 0 : 1) == col);
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(children: [
          for (final d in [first, second])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: C.red,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.goldDeep, width: 2),
                ),
                child: Column(children: [
                  Text('งวด ${thaiDate(d)} ออกวัน${dayFull[weekdayIndex(d)]}', style: sans(14, color: C.gold)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    for (final (i, n) in drawLeadFor(d, weekdayIndex(d)).indexed) ...[
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
          Text(drawIntro, style: sans(14, color: C.inkBody, height: 1.8)),
          const SizedBox(height: 14),
          CreamCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              Container(
                decoration: const BoxDecoration(
                  color: C.red,
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
