import 'dart:async';

import 'package:flutter/material.dart';

import '../state/app_controller.dart';
import '../data/design_data.dart';
import '../data/dream_images_k.dart';
import '../data/dream_repository.dart';
import '../data/formulas.dart';
import '../data/lock_numbers.dart';
import '../data/running_numbers.dart';
import '../data/sound_numbers.dart';
import '../state/daily_pick.dart';
import '../state/load_request.dart';
import '../theme.dart';
import '../widgets/error_log_sheet.dart';
import '../widgets/ui.dart';

const _quick = [
  ('ทำนายฝัน', 'dream'),
  ('ฝันจากสัตว์', '5'),
  ('แป๊ะกง 1,000', '6'),
  ('เลขเสี่ยงโชค', '9'),
  ('เลขเด่น', '8'),
  ('เลขวิ่ง', '10'),
  ('แก้ฝันร้าย', '3'),
  ('บทสวด', '11'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.now, this.clock = DateTime.now});

  /// Reference time for the date header, daily lock card and next draw date.
  final DateTime now;

  /// Live clock for the hot-dream list, which turns over at 04:00 while Home stays open.
  final DateTime Function() clock;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    // The book's lock and running numbers follow the weekday the next draw falls on.
    final draw = nextDrawDate(now);
    final drawDay = weekdayIndex(draw);
    final running = runningByDrawDay[drawDay];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        PageHeader(
          pattern: true,
          border: false,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(thaiDateLong(now), style: sans(13, color: C.gold)),
                        const SizedBox(height: 2),
                        // Long-press: hidden error log for testers (F12).
                        GestureDetector(
                          onLongPress: () => showErrorLog(context),
                          child: Text(
                            'ทำนายฝัน',
                            style: serif(26, weight: FontWeight.w800, color: C.goldLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Semantics(
                button: true,
                label: 'ค้นหาความฝัน',
                child: GestureDetector(
                  onTap: () => app.goSearch(focus: true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: C.input,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: C.gold, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: C.gold),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'เมื่อคืนคุณฝันเห็นอะไร...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: sans(16, color: C.placeholder),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Daily lock numbers right under the search box, as in the design (owner request).
        // The header continues behind the card's top, so the card sits half on the header (as in the first design).
        Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 64,
              child: PageHeader(
                gradient: false,
                color: C.headerEnd,
                pattern: true,
                border: false,
                padding: EdgeInsets.zero,
                child: SizedBox.expand(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppCard(
                radius: 18,
                borderWidth: 1.5,
                shadow: const [BoxShadow(color: C.shadow, blurRadius: 24, offset: Offset(0, 8))],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('เลขล็อควัน${dayFull[drawDay]}', style: serif(16, color: C.accent)),
                        ),
                        Text('งวด ${thaiDateShort(draw)}', style: sans(12, color: C.caption)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _LockTile(label: 'บน', numbers: lockTop[drawDay], dark: true),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _LockTile(label: 'ล่าง', numbers: lockBottom[drawDay], dark: false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // As in the design: label + badge pairs. The book gives ตัวเด่น / ตัวกัน as groups
                    // (15 and 10 numbers), so the badges count them and open the full page.
                    Wrap(
                      key: const ValueKey('lock-badges'),
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Semantics(
                          button: true,
                          label: 'ตัวเด่น ${soundLead[drawDay].length} ตัว ตัวกัน ${soundBlock[drawDay].length} ตัว',
                          excludeSemantics: true,
                          child: GestureDetector(
                            onTap: () => app.openFeat('9'),
                            child: Wrap(
                              spacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('ตัวเด่น', style: sans(13, color: C.textSoft)),
                                _Badge('${soundLead[drawDay].length} ตัว', bg: C.aqua, fg: C.onGold),
                                Text('ตัวกัน', style: sans(13, color: C.textSoft)),
                                _Badge('${soundBlock[drawDay].length} ตัว', bg: C.muted, fg: C.textBody),
                              ],
                            ),
                          ),
                        ),
                        Text('เลขวิ่ง', style: sans(13, color: C.textSoft)),
                        Text(
                          running.join(' · '),
                          style: sans(14, weight: FontWeight.w700, color: C.goldLight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SectionLabel('เมนูยอดนิยม'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ContentGrid(
            columns: 4,
            spacing: 10,
            runSpacing: 10,
            minRowHeight: 98,
            children: [
              for (final (t, k) in _quick)
                Semantics(
                  button: true,
                  label: t,
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: () => k == 'dream' ? app.goSearch(resetCat: true) : app.openFeat(k),
                    child: Column(
                      children: [
                        GlyphTile(featureIcon(k)),
                        const SizedBox(height: 6),
                        Text(
                          t,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
                          style: sans(12, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text('ฝันแนะนำวันนี้', style: serif(17, color: C.accent)),
              ),
              Semantics(
                button: true,
                child: GestureDetector(
                  onTap: () => app.goSearch(resetCat: true),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('ดูทั้งหมด', style: sans(14, color: C.goldLight)),
                  ),
                ),
              ),
            ],
          ),
        ),
        _HotDreams(clock: clock),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Small rounded label (ตัวเด่น / ตัวกัน counts on the lock card).
class _Badge extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const _Badge(this.text, {required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
    child: Text(
      text,
      style: sans(13, weight: FontWeight.w700, color: fg),
    ),
  );
}

class _LockTile extends StatelessWidget {
  final String label;
  final List<String> numbers;
  final bool dark;
  const _LockTile({required this.label, required this.numbers, required this.dark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    // บน is the highlighted row (gold, like the design); ล่าง is the outlined one.
    decoration: BoxDecoration(
      gradient: dark ? goldGradient : null,
      color: dark ? null : C.input,
      borderRadius: BorderRadius.circular(14),
      border: dark ? null : Border.all(color: C.gold, width: 1.5),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: sans(13, weight: FontWeight.w600, color: dark ? C.onGold : C.accent),
        ),
        const SizedBox(height: 4),
        // Two rows of three, always: very large text shrinks to fit rather than breaking a row.
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${numbers.take(3).join('  ')}\n${numbers.skip(3).join('  ')}',
            textAlign: TextAlign.center,
            style: serif(20, weight: FontWeight.w800, color: dark ? C.onGold : C.accent, height: 1.4),
          ),
        ),
      ],
    ),
  );
}

/// Card with image placeholder + dream name + number (home hot list, digit screen).
/// "ฝันแนะนำวันนี้": ten dreams drawn at random from those with a picture, a new draw every day at 04:00,
/// in one scrolling row (as in the design).
const _count = 10;

class _HotDreams extends StatefulWidget {
  final DateTime Function() clock;
  const _HotDreams({required this.clock});
  @override
  State<_HotDreams> createState() => _HotDreamsState();
}

// Kept alive inside Home's ListView so scrolling it off screen does not refetch.
class _HotDreamsState extends State<_HotDreams> with AutomaticKeepAliveClientMixin {
  final _request = LoadRequest<List<DreamSummary>>();
  bool _started = false;
  Timer? _rollover;
  late DreamRepository _repo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _repo = AppScope.of(context).repository;
    _load();
    _request.addListener(_changed);
    _scheduleRollover();
  }

  /// The day's draw (one request in API mode); the clock is read when the request runs, so Retry
  /// after a rollover asks for the new day.
  void _load() => _request.run(() => _repo.daily(widget.clock(), limit: _count));

  void _changed() => setState(() {});

  // Fetch the new day's draw at the next 04:00 if Home is still alive then.
  void _scheduleRollover() {
    final now = widget.clock();
    _rollover?.cancel();
    _rollover = Timer(nextDailyRollover(now).difference(now), () {
      if (!mounted) return;
      _load();
      _scheduleRollover();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _rollover?.cancel();
    _request.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final items = _request.value ?? const <DreamSummary>[];
    return switch (_request.status) {
      LoadStatus.idle || LoadStatus.loading => const GoldLoading(height: 136),
      LoadStatus.failure => LoadErrorView(message: loadErrorMessage(_request.error), onRetry: _request.retry),
      LoadStatus.success when items.isEmpty => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'ยังไม่มีความฝันแนะนำ',
          textAlign: TextAlign.center,
          style: sans(14, color: C.caption),
        ),
      ),
      // One row; it sizes to its tallest card.
      LoadStatus.success => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, d) in items.indexed) ...[
                if (i > 0) const SizedBox(width: 10),
                DreamCard(dreamId: d.id, name: d.name, image: d.image, width: 140, number: d.firstTwo),
              ],
            ],
          ),
        ),
      ),
    };
  }
}

class DreamCard extends StatelessWidget {
  final String dreamId, name;
  final DreamImage? image;
  final double? width;
  final String number;
  final double numberSize;
  const DreamCard({
    super.key,
    required this.dreamId,
    required this.name,
    required this.number,
    this.image,
    this.width,
    this.numberSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppCard(
        radius: 14,
        padding: EdgeInsets.zero,
        onTap: () => AppScope.of(context).openDream(dreamId),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DreamImageView(
              image: dreamImageFor(dreamId, image),
              placeholderLabel: 'ภาพ $name',
              // Contained so the numbers printed in the picture's corners are not cropped.
              height: 90,
              width: double.infinity,
              fit: BoxFit.contain,
              background: C.surface,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(14, weight: FontWeight.w600),
                  ),
                  // "ไม่ควรเสี่ยง" is a warning, not a number: same colour as in search and the letter lists.
                  number == LuckyNumbers.noLuckyNumbersText
                      ? Text(
                          number,
                          style: sans(14, weight: FontWeight.w600, color: C.warning, height: 1.6),
                        )
                      : Text(number, style: serif(numberSize, color: C.number, height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
