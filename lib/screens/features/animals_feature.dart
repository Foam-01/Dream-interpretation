import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/animal_numbers.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 5: each animal with its number pair and picture, 21 a page; range chips filter by number,
/// the search box looks across all 100.
class AnimalsFeature extends StatefulWidget {
  final Widget header;
  const AnimalsFeature({super.key, required this.header});

  @override
  State<AnimalsFeature> createState() => _AnimalsFeatureState();
}

class _AnimalsFeatureState extends State<AnimalsFeature> {
  final _animalQuery = TextEditingController();
  int _animalPage = 0;
  int _animalRange = -1; // -1 = all

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _animalsBody());

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
        child: SearchField(
          fieldKey: const ValueKey('animal-search'),
          controller: _animalQuery,
          hint: 'ค้นหาชื่อสัตว์ เช่น ช้าง หรือเลข',
          onChanged: () => setState(() => _animalPage = 0),
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
                    ? 'ไม่พบสัตว์ที่ตรงกับ "$q" ลองคำอื่นหรือพิมพ์เลข'
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
}
