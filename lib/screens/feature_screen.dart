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
  int? _loreDigit;
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
  final _remedySearch = TextEditingController();
  String _remedyQuery = '';
  static const _chantScales = [1.0, 1.15, 1.3, 1.5];
  double _chantScale = 1.0;

  Widget _sizeButton(String text, String label, bool enabled, int step) => Semantics(
        button: true,
        enabled: enabled,
        label: label,
        excludeSemantics: true,
        child: SizedBox(
          width: 48,
          height: 44,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: enabled && step > 0 ? C.gold : Colors.transparent,
              side: BorderSide(color: C.gold.withValues(alpha: enabled ? .8 : .3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: enabled
                ? () => setState(() => _chantScale = _chantScales[_chantScales.indexOf(_chantScale) + step])
                : null,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(text,
                  style: sans(16, weight: FontWeight.w700, color: !enabled ? C.caption : step > 0 ? C.onGold : C.goldLight)),
            ),
          ),
        ),
      );

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
          _LetterSwitcher(current: k, onPick: app.openFeat),
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
    Widget group(String title, List<String> nums, {required bool top}) => Container(
          decoration: BoxDecoration(
            gradient: top
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2868FF), Color(0xFF0B388E), Color(0xFF002344)],
                    stops: [0, 0.38, 1],
                  )
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

  // ---- Step-by-step rituals (4) ----
  List<Widget> _stepsBody(String k) {
    final list = steps[k] ?? const [];
    final prayer = prayers[k];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(children: [
          // A timeline: the rite is done in order, so each step hangs off one line.
          for (final (i, s) in list.indexed)
            IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(
                  width: 34,
                  child: Column(children: [
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
                        child: Text(thaiDigits[i + 1],
                            style: serif(15, color: i == 0 ? C.onGold : C.goldLight, height: 1.2)),
                      ),
                    ),
                    if (i < list.length - 1)
                      Expanded(child: Container(width: 2, color: C.gold.withValues(alpha: .35))),
                  ]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 18),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s[0], style: sans(16, weight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(s[1], style: sans(14, color: C.textSoft, height: 1.7)),
                    ]),
                  ),
                ),
              ]),
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
    Widget group(String title, List<String> nums, {required bool dark}) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: dark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [C.brandBright, C.brand],
                  )
                : null,
            color: dark ? null : C.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.goldDeep, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: serif(16, color: C.accent)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final n in nums)
                  Container(
                    width: 52,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: dark ? goldGradient : null,
                      color: dark ? null : C.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: dark ? C.goldDeep : C.goldBorder, width: 1),
                      boxShadow: dark
                          ? const [BoxShadow(color: C.shadow, blurRadius: 4, offset: Offset(0, 2))]
                          : null,
                    ),
                    child: Text(
                      n,
                      style: serif(
                        18,
                        weight: dark ? FontWeight.w800 : FontWeight.w600,
                        color: dark ? C.onGold : C.goldLight,
                        height: 1.2,
                      ),
                    ),
                  ),
              ]),
            ],
          ),
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
            color: C.brand,
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
              isDrawDay ? 'งวด ${thaiDate(_draw)} สลากออกวัน${dayFull[_soundDay]}' : 'ถ้าสลากออกวัน${dayFull[_soundDay]}',
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

  // ---- Dream chant (11): the owner's book page — intro, then the three stanzas in one card ----
  List<Widget> _chantBody() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(chantIntro, style: sans(14, color: C.textBody, height: 1.8)),
          const SizedBox(height: 14),
          // Chanted from the screen, often by older readers: let them enlarge just the verses.
          Row(children: [
            Expanded(child: Text('ขนาดตัวอักษร', style: sans(14, color: C.textSoft))),
            _sizeButton('ก-', 'ลดขนาดตัวอักษร', _chantScale > _chantScales.first, -1),
            const SizedBox(width: 8),
            _sizeButton('ก+', 'เพิ่มขนาดตัวอักษร', _chantScale < _chantScales.last, 1),
          ]),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            decoration: BoxDecoration(
              color: C.brand,
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
                Text('บทที่ ${thaiDigits[i + 1]}', style: sans(13, weight: FontWeight.w600, color: C.aquaText)),
                const SizedBox(height: 4),
                SelectableText(stanza.join('\n'),
                    textAlign: TextAlign.center, style: serif(17 * _chantScale, color: C.goldLight, height: 1.9)),
              ],
            ]),
          ),
        ]),
      ),
    ];
  }

  // ---- Nightmare remedies (3): search box + gold-premium card list; long intro folds away ----
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
    final q = _remedyQuery.trim().toLowerCase();
    final filtered = q.isEmpty
        ? remedies
        : remedies.where((r) {
            final hay = '${r.dream}${r.omen}${r.cure}'.toLowerCase();
            return hay.contains(q);
          }).toList();

    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Search box ──
          Container(
            key: const ValueKey('remedy-search'),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: C.goldBorder, width: 1),
            ),
            child: Row(children: [
              const SizedBox(width: 12),
              Icon(Icons.search_rounded, color: C.textSoft, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _remedySearch,
                  style: sans(14, color: C.text),
                  decoration: InputDecoration(
                    hintText: 'ฝันร้ายเรื่องอะไร เช่น ตกน้ำ',
                    hintStyle: sans(14, color: C.textSoft),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (v) => setState(() => _remedyQuery = v),
                ),
              ),
              if (_remedyQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _remedySearch.clear();
                    setState(() => _remedyQuery = '');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.close_rounded, color: C.textSoft, size: 18),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Remedy cards ──
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('ไม่พบฝันที่ตรงกัน', style: sans(14, color: C.textSoft))),
            )
          else
            for (final (i, r) in filtered.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // numbered circle
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
                        child: Text(num(remedies.indexOf(r) + 1), style: serif(14, color: C.goldLight, height: 1.2)),
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

          // ── Closing box (only when not filtering) ──
          if (q.isEmpty) ...[
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
            color: C.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.goldBorder),
          ),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(children: [
            SizedBox(
              // Two lines of the name at the phone's text size.
              height: 36 * MediaQuery.textScalerOf(context).scale(13) / 13,
              child: Center(
                child: Text(a.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sans(13, weight: FontWeight.w700, color: C.text, height: 1.3)),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(a.number, style: serif(22, weight: FontWeight.w800, color: C.accent, height: 1.2)),
                const SizedBox(width: 14),
                Text(a.pair, style: serif(16, color: C.textSoft, height: 1.2)),
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
            const Icon(Icons.search, size: 18, color: C.gold),
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
          // Taller cards when the phone's text is large, so the picture keeps its room.
          childAspectRatio: 0.72 / (1 + (MediaQuery.textScalerOf(context).scale(1) - 1) * 0.6),
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
            color: C.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.goldBorder),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            SizedBox(
              // Two lines of the name at the phone's text size.
              height: 36 * MediaQuery.textScalerOf(context).scale(13) / 13,
              child: Center(
                child: Text(p.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sans(13, weight: FontWeight.w700, color: C.text, height: 1.3)),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(p.lucky, style: serif(22, weight: FontWeight.w800, color: C.accent, height: 1.2)),
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
            const Icon(Icons.search, size: 18, color: C.gold),
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
          // Taller cards when the phone's text is large, so the picture keeps its room.
          childAspectRatio: 0.72 / (1 + (MediaQuery.textScalerOf(context).scale(1) - 1) * 0.6),
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

  // ---- Lucky digits 0-9 summary (2): horizontal selector + all 10 cards in order (0–9) ----
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
    final sorted = [...digitSymbols]..sort((a, b) => a.digit.compareTo(b.digit));
    return [
      Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: C.goldBorder, width: 0.8)),
        ),
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
        child: Builder(
          builder: (context) => Row(
            children: [
              for (var d = 0; d <= 9; d++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SelectPill(
                      text: '$d',
                      selected: _digit == d,
                      onTap: () {
                        setState(() => _digit = d);
                        _jumpToDigit(Scrollable.of(context).position, d);
                      },
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      radius: 10,
                      fontSize: 16,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      for (final s in sorted)
        Padding(
          key: _digitKeys[s.digit],
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: AppCard(
            radius: 18,
            borderWidth: 1.5,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: goldGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: C.shadow, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      // Fixed-size badge: very large text shrinks to fit inside it.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${s.digit}',
                          style: serif(24, weight: FontWeight.w800, color: C.onGold, height: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Wraps with large text instead of running off the card.
                    Expanded(
                      child: Text(
                        'ฝันแบบไหนเป็นเลข ${s.digit}',
                        style: serif(18, weight: FontWeight.w700, color: C.accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: s.image == null
                        ? ImagePlaceholder('ภาพประกอบเลข ${s.digit}', fontSize: 13, band: 8)
                        : Image.asset(s.image!, fit: BoxFit.cover, semanticLabel: 'ภาพประกอบเลข ${s.digit}'),
                  ),
                ),
                const SizedBox(height: 18),
                Semantics(
                  label: 'ได้แก่ ฝันเห็น ${s.items.join(', ')}',
                  child: ExcludeSemantics(
                    child: Wrap(
                      key: ValueKey('digit-items-${s.digit}'),
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final item in s.items)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: C.input,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: C.goldBorder.withValues(alpha: 0.35)),
                            ),
                            child: Text(item, style: sans(14, color: C.textBody)),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 24),
    ];
  }

  // ---- Number lore (12): filter the book's rules by their leading number ----
  List<Widget> _tableBody() {
    final entries = _loreDigit == null
        ? loreEntriesByNumber
        : loreEntriesByNumber.where((entry) => entry.badge == '$_loreDigit').toList();
    return [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
              key: const ValueKey('lore-digit-filter'),
              children: [
                SelectPill(
                  key: const ValueKey('lore-filter-all'),
                  text: 'ทั้งหมด',
                  selected: _loreDigit == null,
                  onTap: () => setState(() => _loreDigit = null),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  radius: 10,
                  fontSize: 13,
                  weight: FontWeight.w700,
                ),
                const SizedBox(width: 4),
                for (final digit in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SelectPill(
                      key: ValueKey('lore-filter-$digit'),
                      text: '$digit',
                      selected: _loreDigit == digit,
                      onTap: () => setState(() => _loreDigit = _loreDigit == digit ? null : digit),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      radius: 10,
                      fontSize: 15,
                      weight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            ),
            const SizedBox(height: 12),
            Text(loreIntro, style: sans(14, color: C.textBody, height: 1.8)),
            const SizedBox(height: 12),
            for (final e in entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
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
                            TextSpan(text: seen, style: sans(14, weight: FontWeight.w700, color: C.accent, height: 1.7)),
                            TextSpan(text: e.text.substring('ถ้าฝันเห็น '.length + seen.length)),
                          ] else
                            TextSpan(text: e.text),
                        ]),
                        style: sans(14, color: C.textBody, height: 1.7),
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
                color: C.brand,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.goldDeep, width: 2),
              ),
              child: Text(loreClosing, style: sans(14, color: C.onBrand, height: 1.8)),
            ),
          ]),
        ),
      ];
  }

  // ---- Draw lead numbers (8): keep the lead card and the weekday table so the feature stays complete ----
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
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2868FF), Color(0xFF0B388E), Color(0xFF002344)],
                          stops: [0, 0.38, 1],
                        )
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

/// Row of letter pills on a letter-category page, so the next letter is one tap away
/// instead of back to the menu. Scrolls the current letter into view.
class _LetterSwitcher extends StatefulWidget {
  final String current;
  final ValueChanged<String> onPick;
  const _LetterSwitcher({required this.current, required this.onPick});

  @override
  State<_LetterSwitcher> createState() => _LetterSwitcherState();
}

class _LetterSwitcherState extends State<_LetterSwitcher> {
  final _currentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _currentKey.currentContext;
      if (ctx != null) Scrollable.ensureVisible(ctx, alignment: .5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keys = _letterCategories.keys.toList();
    // Three rows in letter order (first third on top), scrolling together.
    const rowCount = 3;
    final perRow = (keys.length + rowCount - 1) ~/ rowCount;
    final rows = [
      for (var s = 0; s < keys.length; s += perRow) keys.sublist(s, (s + perRow).clamp(0, keys.length)),
    ];
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: C.caption.withValues(alpha: .12)))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final (r, row) in rows.indexed) ...[
            if (r > 0) const SizedBox(height: 6),
            Row(children: [
              for (final (i, k) in row.indexed) ...[
                if (i > 0) const SizedBox(width: 6),
                SizedBox(
                  key: k == widget.current ? _currentKey : null,
                  width: 44,
                  height: 44,
                  child: Semantics(
                    label: feats[k]!.title,
                    child: SelectPill(
                      text: feats[k]!.title.split(' ').last,
                      selected: k == widget.current,
                      onTap: () => k == widget.current ? null : widget.onPick(k),
                      padding: EdgeInsets.zero,
                      radius: 10,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ]),
          ],
        ]),
      ),
    );
  }
}
