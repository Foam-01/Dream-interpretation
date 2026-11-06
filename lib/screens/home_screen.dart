import 'dart:async';

import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/design_data.dart';
import '../data/dream_images_k.dart';
import '../data/dream_repository.dart';
import '../data/formulas.dart';
import '../data/lock_numbers.dart';
import '../data/running_numbers.dart';
import '../state/daily_pick.dart';
import '../state/load_request.dart';
import '../theme.dart';
import '../widgets/ui.dart';

const _quick = [
  ('ทำนายฝัน', 'dream'),
  ('ตารางสัตว์', '5'),
  ('แป๊ะกง 1000', '6'),
  ('เลขเสียงโชค', '9'),
  ('เลขเด่นงวด', '8'),
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
                Text('ทำนายฝัน', style: serif(26, weight: FontWeight.w800, color: C.goldLight)),
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
              onTap: () => app.goSearch(focus: true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: C.input,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.gold, width: 1.5),
                ),
                child: Row(children: [
                  const Icon(Icons.search, size: 18, color: C.gold),
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
      const SectionLabel('หมวดยอดนิยม'),
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
                  child: Column(children: [
                    GlyphTile(featureIcon(k)),
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
      _HotDreams(clock: clock),
      const SizedBox(height: 24),
      // Daily lock numbers, at the bottom of the page (owner request).
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CreamCard(
            radius: 18,
            borderWidth: 1.5,
            shadow: const [BoxShadow(color: C.shadow, blurRadius: 24, offset: Offset(0, 8))],
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text('เลขล็อควัน${dayFull[drawDay]}', style: serif(16, color: C.accent))),
                Text('งวด ${thaiDateShort(draw)}', style: sans(12, color: C.caption)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _LockTile(label: 'บน', numbers: lockTop[drawDay], dark: true)),
                const SizedBox(width: 10),
                Expanded(child: _LockTile(label: 'ล่าง', numbers: lockBottom[drawDay], dark: false)),
              ]),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Semantics(
                  button: true,
                  child: GestureDetector(
                    onTap: () => app.openFeat('9'),
                    child: Text('ตัวเด่น · ตัวกัน ›', style: sans(13, weight: FontWeight.w600, color: C.accent)),
                  ),
                ),
                Text('เลขวิ่ง', style: sans(13, color: C.textSoft)),
                Text(running.join(' · '),
                    style: sans(13, weight: FontWeight.w700, color: C.number)),
              ]),
            ]),
          ),
      ),
      const SizedBox(height: 24),
    ]);
  }
}

class _LockTile extends StatelessWidget {
  final String label;
  final List<String> numbers;
  final bool dark;
  const _LockTile({required this.label, required this.numbers, required this.dark});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: dark ? C.brand : C.highlight,
          borderRadius: BorderRadius.circular(12),
          border: dark ? null : Border.all(color: C.goldBorder),
        ),
        child: Column(children: [
          Text(label, style: sans(12, color: dark ? C.gold : C.accent)),
          const SizedBox(height: 4),
          Text('${numbers.take(3).join('  ')}\n${numbers.skip(3).join('  ')}',
              textAlign: TextAlign.center,
              style: serif(20, weight: FontWeight.w800, color: dark ? C.goldLight : C.accent, height: 1.4)),
        ]),
      );
}

/// Card with image placeholder + dream name + number (home hot list, digit screen).
/// "ฝันยอดฮิตวันนี้": ten dreams drawn at random from those with a picture, a new draw every day at 04:00,
/// as two scrolling rows.
const _perRow = 5;

class _HotDreams extends StatefulWidget {
  final DateTime Function() clock;
  const _HotDreams({required this.clock});
  @override
  State<_HotDreams> createState() => _HotDreamsState();
}

// Kept alive inside Home's ListView so scrolling it off screen does not refetch.
class _HotDreamsState extends State<_HotDreams> with AutomaticKeepAliveClientMixin {
  final _request = LoadRequest<DreamPage>();
  bool _started = false;
  Timer? _rollover;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final repo = AppScope.of(context).repository;
    _request.run(() => repo.listAll());
    _request.addListener(_changed);
    _scheduleRollover();
  }

  void _changed() => setState(() {});

  // Redraw at the next 04:00 if Home is still alive then.
  void _scheduleRollover() {
    final now = widget.clock();
    _rollover?.cancel();
    _rollover = Timer(nextDailyRollover(now).difference(now), () {
      if (!mounted) return;
      setState(() {});
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
    final all = _request.value?.items ?? const <DreamSummary>[];
    final pictured = [for (final d in all) if (dreamImageFor(d.id, d.image) != null) d];
    // A catalogue without any pictures still gets a daily list.
    final items = dailyPick(pictured.isEmpty ? all : pictured, widget.clock(), _perRow * 2, (d) => d.id);
    return switch (_request.status) {
      LoadStatus.idle || LoadStatus.loading => const GoldLoading(height: 136),
      LoadStatus.failure => LoadErrorView(message: loadErrorMessage(_request.error), onRetry: _request.retry),
      LoadStatus.success when items.isEmpty => Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text('ยังไม่มีความฝันยอดฮิต', textAlign: TextAlign.center, style: sans(14, color: C.caption)),
        ),
      // Two rows of _perRow cards; each row sizes to its tallest card.
      // Both rows scroll together horizontally.
      LoadStatus.success => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var r = 0; r * _perRow < items.length; r++) ...[
              if (r > 0) const SizedBox(height: 10),
              IntrinsicHeight(
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  for (var c = 0; c < _perRow && r * _perRow + c < items.length; c++) ...[
                    if (c > 0) const SizedBox(width: 10),
                    DreamCard(
                        dreamId: items[r * _perRow + c].id,
                        name: items[r * _perRow + c].name,
                        image: items[r * _perRow + c].image,
                        // Pictures are ~1.8:1; 160 wide fills the 90-high image box edge to edge.
                        width: 160,
                        number: items[r * _perRow + c].firstTwo),
                  ],
                ]),
              ),
            ],
          ]),
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
  const DreamCard(
      {super.key,
      required this.dreamId,
      required this.name,
      required this.number,
      this.image,
      this.width,
      this.numberSize = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CreamCard(
        radius: 14,
        padding: EdgeInsets.zero,
        onTap: () => AppScope.of(context).openDream(dreamId),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          DreamImageView(
              image: dreamImageFor(dreamId, image),
              placeholderLabel: 'ภาพ $name',
              // Contained so the numbers printed in the picture's corners are not cropped.
              height: 90,
              width: double.infinity,
              fit: BoxFit.contain,
              background: C.surface),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(14, weight: FontWeight.w600)),
              Text(number, style: serif(numberSize, color: C.number, height: 1.3)),
            ]),
          ),
        ]),
      ),
    );
  }
}
