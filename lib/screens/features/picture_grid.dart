import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menus 5 and 6: a book of numbered pictures, 21 a page (7 full rows of 3). Range chips filter by
/// number; the search box looks across every picture.
class PictureGridMenu<T> extends StatefulWidget {
  final Widget header;

  /// All pictures in book order.
  final List<T> items;

  /// Pictures per range chip (the chips split [items] into equal parts).
  final int rangeSize;

  /// The number a chip label shows for the first and last picture of its range.
  final String Function(T item) rangeLabel;

  /// Whether [item] matches the (trimmed, non-empty) search [query].
  final bool Function(T item, String query) matches;

  final Key searchKey;
  final String hint;

  /// Counting word after the number of pictures (ตัว, ภาพ).
  final String unit;

  /// What is being searched for, in "ไม่พบ… ที่ตรงกับ" (สัตว์, ภาพ).
  final String noun;

  /// The card for one picture, usually a [PictureCard].
  final Widget Function(T item) cell;

  const PictureGridMenu({
    super.key,
    required this.header,
    required this.items,
    required this.rangeSize,
    required this.rangeLabel,
    required this.matches,
    required this.searchKey,
    required this.hint,
    required this.unit,
    required this.noun,
    required this.cell,
  });

  /// Pictures per page.
  static const perPage = 21;

  @override
  State<PictureGridMenu<T>> createState() => _PictureGridMenuState<T>();
}

class _PictureGridMenuState<T> extends State<PictureGridMenu<T>> {
  final _query = TextEditingController();
  int _page = 0;
  int _range = -1; // -1 = all

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Turns a page and goes back to the top so the new page starts in view.
  void _turnPage(BuildContext context, VoidCallback change) {
    setState(change);
    Scrollable.of(context).position.jumpTo(0);
  }

  /// Filter chips: ทั้งหมด, then one chip per number range; [selected] -1 means all.
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
  Widget build(BuildContext context) {
    const perPage = PictureGridMenu.perPage;
    final w = widget;
    final items = w.items;
    final size = w.rangeSize;
    final q = _query.text.trim();
    final found = q.isNotEmpty
        ? [for (final item in items) if (w.matches(item, q)) item]
        : _range < 0
            ? items
            : items.sublist(_range * size, _range * size + size);
    final pages = math.max(1, (found.length / perPage).ceil());
    final page = math.min(_page, pages - 1);
    final shown = found.sublist(page * perPage, math.min(found.length, page * perPage + perPage));
    return FeatureList(header: w.header, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: SearchField(
          fieldKey: w.searchKey,
          controller: _query,
          hint: w.hint,
          onChanged: () => setState(() => _page = 0),
        ),
      ),
      if (q.isEmpty)
        _rangeChips(
          [
            for (var i = 0; i < items.length ~/ size; i++)
              '${w.rangeLabel(items[i * size])}–${w.rangeLabel(items[i * size + size - 1])}',
          ],
          _range,
          (r) => setState(() {
            _range = r;
            _page = 0;
          }),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Text(
            q.isEmpty
                ? '${found.length} ${w.unit}'
                : found.isEmpty
                    ? 'ไม่พบ${w.noun}ที่ตรงกับ "$q" ลองคำอื่นหรือพิมพ์เลข'
                    : 'พบ ${found.length} ${w.unit}',
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
          children: [for (final item in shown) w.cell(item)],
        ),
      ),
      if (pages > 1)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Builder(
            builder: (context) => Pager(
              page: page + 1,
              pages: pages,
              onPage: (p) => _turnPage(context, () => _page = p - 1),
            ),
          ),
        ),
    ]);
  }
}

/// One card of [PictureGridMenu]: the name (two lines), a row of numbers, then the picture.
class PictureCard extends StatelessWidget {
  final String name;
  final List<Widget> numbers;
  final Widget picture;
  const PictureCard({super.key, required this.name, required this.numbers, required this.picture});

  @override
  Widget build(BuildContext context) => Container(
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
              child: Text(name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(13, weight: FontWeight.w700, color: C.text, height: 1.3)),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: numbers),
          ),
          const SizedBox(height: 6),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: picture)),
        ]),
      );
}
