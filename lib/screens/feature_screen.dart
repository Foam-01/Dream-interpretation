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
import '../data/animal_numbers.dart';
import '../data/design_data.dart';
import '../data/digit_lore.dart';
import '../data/digit_summary.dart';
import '../data/draw_numbers.dart';
import '../data/dream_chant.dart';
import '../data/formulas.dart';
import '../data/pae_numbers.dart';
import '../data/lock_numbers.dart';
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
  int? _digit;
  final _digitKeys = [for (var i = 0; i < 10; i++) GlobalKey()];
  late final DateTime _draw = nextDrawDate(widget.now);
  late int _runDay = weekdayIndex(_draw);
  late int _lockDay = weekdayIndex(_draw);
  late int _soundDay = weekdayIndex(_draw);
  final _paeQuery = TextEditingController();
  int _paePage = 0;
  int _paeRange = -1; // -1 = all
  final _animalQuery = TextEditingController();
  int _animalPage = 0;
  int _animalRange = -1; // -1 = all

  @override
  void dispose() {
    _paeQuery.dispose();
    _animalQuery.dispose();
    super.dispose();
  }

  /// Menus 5 and 6 show 21 pictures a page: 7 full rows of 3.
  static const perPage = 21;

  /// Turns a page and goes back to the top so the new page starts in view.
  void _turnPage(BuildContext context, VoidCallback change) {
    setState(change);
    Scrollable.of(context).position.jumpTo(0);
  }

  /// Filter chips for menus 5 and 6: ทั้งหมด, then one chip per number range; [selected] -1 means all.
  Widget _rangeChips(List<String> ranges, int selected, ValueChanged<int> onSelect) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(children: [
          SelectPill(text: 'ทั้งหมด', selected: selected < 0, onTap: () => onSelect(-1)),
          for (final (i, r) in ranges.indexed) ...[
            const SizedBox(width: 6),
            SelectPill(text: r, selected: selected == i, onTap: () => onSelect(i)),
          ],
        ]),
      );

  bool _remedyIntroOpen = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final k = widget.featKey;
    final f = feats[k]!;
    final body = switch (f.type) {
      FeatType.lock => _lockBody(),
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

  // ---- Lock numbers (7): the book's บน / ล่าง table by weekday; opens on the next draw's day ----
  List<Widget> _lockBody() {
    final isDrawDay = _lockDay == weekdayIndex(_draw);
    Widget group(String title, List<String> nums, {required bool top}) => CreamCard(
          borderWidth: 1.5,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 4, height: 18, color: top ? C.red : C.goldDeep),
              const SizedBox(width: 8),
              Text(title, style: serif(17, color: C.red)),
            ]),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.7,
              children: [
                for (final n in nums)
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: top ? C.red : C.tileLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: top ? C.gold : C.goldBorder, width: top ? 1.5 : 1),
                    ),
                    child: Text(n,
                        style: serif(26, weight: FontWeight.w800, color: top ? C.goldLight : C.red, height: 1.2)),
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
            style: serif(18, color: C.red),
          ),
          const SizedBox(height: 12),
          group('เลขบน', lockTop[_lockDay], top: true),
          const SizedBox(height: 12),
          group('เลขล่าง', lockBottom[_lockDay], top: false),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: C.tileLight.withValues(alpha: .5), borderRadius: BorderRadius.circular(12)),
            child: Text('$lockNote\n(เลข "ล็อค" ตามกำลังวัน $lockSource)',
                style: sans(13, color: C.inkSoft, height: 1.7)),
          ),
        ]),
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

  // ---- Animals (5): each animal with its number pair and picture, 21 a page; range chips filter by number,
  // the search box looks across all 100 ----
  List<Widget> _animalsBody() {
    final q = _animalQuery.text.trim();
    final found = q.isNotEmpty
        ? [for (final a in animalNumbers) if (a.name.contains(q) || a.number == q || a.pair == q) a]
        : _animalRange < 0
            ? animalNumbers
            : animalNumbers.sublist(_animalRange * 20, _animalRange * 20 + 20);
    final pages = math.max(1, (found.length / perPage).ceil());
    final page = math.min(_animalPage, pages - 1);
    final shown = found.sublist(page * perPage, math.min(found.length, page * perPage + perPage));
    Widget cell(AnimalNumber a) => Container(
          decoration: BoxDecoration(
            color: C.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.goldBorder),
          ),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(children: [
            SizedBox(
              height: 36,
              child: Center(
                child: Text(a.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: sans(13, weight: FontWeight.w700, color: C.ink, height: 1.3)),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(a.number, style: serif(22, weight: FontWeight.w800, color: C.red, height: 1.2)),
                const SizedBox(width: 14),
                Text(a.pair, style: serif(16, color: C.inkSoft, height: 1.2)),
              ]),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: a.image == null
                    ? ImagePlaceholder('ภาพ', width: double.infinity, fontSize: 9, band: 6)
                    : Image.asset(a.image!, fit: BoxFit.contain, semanticLabel: a.name),
              ),
            ),
          ]),
        );
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
                onChanged: (_) => setState(() => _animalPage = 0),
                textInputAction: TextInputAction.search,
                style: sans(16),
                decoration: InputDecoration(
                  hintText: 'ค้นหาชื่อสัตว์ เช่น ช้าง หรือเลข',
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
                onPressed: () => setState(() {
                  _animalQuery.clear();
                  _animalPage = 0;
                }),
              ),
          ]),
        ),
      ),
      if (q.isEmpty)
        _rangeChips(
          [for (var i = 0; i < 5; i++) '${animalNumbers[i * 20].number}–${animalNumbers[i * 20 + 19].number}'],
          _animalRange,
          (r) => setState(() {
            _animalRange = r;
            _animalPage = 0;
          }),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Text(
            q.isEmpty
                ? '${found.length} ตัว'
                : found.isEmpty
                    ? 'ไม่พบสัตว์ที่ตรงกับ "$q"'
                    : 'พบ ${found.length} ตัว',
            style: sans(13, color: C.caption)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.72,
          children: [for (final a in shown) cell(a)],
        ),
      ),
      if (pages > 1)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Builder(
            builder: (context) => Pager(
              page: page + 1,
              pages: pages,
              onPage: (p) => _turnPage(context, () => _animalPage = p - 1),
            ),
          ),
        ),
    ];
  }

  // ---- Pae Kong (6): the book's 1,000 pictures 21 a page with range chips, each with its picture number, lucky number
  // and picture; the search box looks across all 1,000 by dream word or either number ----
  List<Widget> _paeBody() {
    final q = _paeQuery.text.trim();
    final found = q.isNotEmpty
        ? [for (final p in paeNumbers) if (p.name.contains(q) || p.number == q || p.lucky == q) p]
        : _paeRange < 0
            ? paeNumbers
            : paeNumbers.sublist(_paeRange * 100, _paeRange * 100 + 100);
    final pages = math.max(1, (found.length / perPage).ceil());
    final page = math.min(_paePage, pages - 1);
    final shown = found.sublist(page * perPage, math.min(found.length, page * perPage + perPage));
    Widget cell(PaeNumber p) => Container(
          decoration: BoxDecoration(
            color: C.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.goldBorder),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            SizedBox(
              height: 36,
              child: Center(
                child: Text(p.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sans(13, weight: FontWeight.w700, color: C.ink, height: 1.3)),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(p.lucky, style: serif(22, weight: FontWeight.w800, color: C.red, height: 1.2)),
                const SizedBox(width: 10),
                Text('ภาพ ${p.number}', style: sans(11, color: C.caption, height: 1.4)),
              ]),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(p.image, fit: BoxFit.contain, cacheWidth: 300, semanticLabel: p.name),
              ),
            ),
          ]),
        );
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
                onChanged: (_) => setState(() => _paePage = 0),
                textInputAction: TextInputAction.search,
                style: sans(16),
                decoration: InputDecoration(
                  hintText: 'ค้นหาสิ่งที่ฝัน เช่น ม้า หรือเลข',
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
                onPressed: () => setState(() {
                  _paeQuery.clear();
                  _paePage = 0;
                }),
              ),
          ]),
        ),
      ),
      if (q.isEmpty)
        _rangeChips(
          [for (var i = 0; i < 10; i++) '${paeNumbers[i * 100].number}–${paeNumbers[i * 100 + 99].number}'],
          _paeRange,
          (r) => setState(() {
            _paeRange = r;
            _paePage = 0;
          }),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Text(
            q.isEmpty
                ? '${found.length} ภาพ'
                : found.isEmpty
                    ? 'ไม่พบภาพที่ตรงกับ "$q"'
                    : 'พบ ${found.length} ภาพ',
            style: sans(13, color: C.caption)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.72,
          children: [for (final p in shown) cell(p)],
        ),
      ),
      if (pages > 1)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Builder(
            builder: (context) => Pager(
              page: page + 1,
              pages: pages,
              onPage: (p) => _turnPage(context, () => _paePage = p - 1),
            ),
          ),
        ),
    ];
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
    final second = nextDrawDate(first.add(const Duration(days: 1)));
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
        [first, second].any((d) => weekdayIndex(d) == day && (drawRound(d) == 1 ? 0 : 1) == col);
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
