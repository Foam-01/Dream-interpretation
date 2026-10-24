import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/design_data.dart';
import '../data/dream_images_k.dart';
import '../data/dream_repository.dart';
import '../data/formulas.dart';
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
  const HomeScreen({super.key, required this.now});

  /// Reference time for the date header, daily lock card and next draw date.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
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
              onTap: () => app.goSearch(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: C.input,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.gold, width: 1.5),
                ),
                child: Row(children: [
                  const Icon(Icons.search, size: 18, color: C.redBright),
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
      const _HotDreams(),
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
/// "ฝันยอดฮิตวันนี้": the first five dreams in catalogue order, from the repository.
class _HotDreams extends StatefulWidget {
  const _HotDreams();
  @override
  State<_HotDreams> createState() => _HotDreamsState();
}

// Kept alive inside Home's ListView so scrolling it off screen does not refetch.
class _HotDreamsState extends State<_HotDreams> with AutomaticKeepAliveClientMixin {
  final _request = LoadRequest<DreamPage>();
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final repo = AppScope.of(context).repository;
    _request.run(() => repo.list(limit: 5));
    _request.addListener(_changed);
  }

  void _changed() => setState(() {});

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _request.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final items = _request.value?.items ?? const <DreamSummary>[];
    return switch (_request.status) {
      LoadStatus.idle || LoadStatus.loading => const GoldLoading(height: 136),
      LoadStatus.failure => LoadErrorView(message: loadErrorMessage(_request.error), onRetry: _request.retry),
      LoadStatus.success when items.isEmpty => Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text('ยังไม่มีความฝันยอดฮิต', textAlign: TextAlign.center, style: sans(14, color: C.caption)),
        ),
      // Row sizes to the tallest card instead of a fixed height that clipped it.
      LoadStatus.success => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                DreamCard(
                    dreamId: items[i].id,
                    name: items[i].name,
                    image: items[i].image,
                    width: 120,
                    number: items[i].firstTwo),
              ],
            ]),
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
              image: dreamImageFor(dreamId, image), placeholderLabel: 'ภาพ $name', height: 80, width: double.infinity),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(14, weight: FontWeight.w600)),
              Text(number, style: serif(numberSize, color: C.redBright, height: 1.3)),
            ]),
          ),
        ]),
      ),
    );
  }
}
