import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/pae_numbers.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 6: the book's 1,000 pae kong pictures 21 a page with range chips; the search box looks
/// across all 1,000 by dream word or either number.
class PaeFeature extends StatefulWidget {
  final Widget header;
  const PaeFeature({super.key, required this.header});

  @override
  State<PaeFeature> createState() => _PaeFeatureState();
}

class _PaeFeatureState extends State<PaeFeature> {
  final _paeQuery = TextEditingController();
  int _paePage = 0;
  int _paeRange = -1; // -1 = all

  @override
  void dispose() {
    _paeQuery.dispose();
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
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _paeBody());

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
        child: SearchField(
          fieldKey: const ValueKey('pae-search'),
          controller: _paeQuery,
          hint: 'ค้นหาสิ่งที่ฝัน เช่น ม้า หรือเลข',
          onChanged: () => setState(() => _paePage = 0),
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
                    ? 'ไม่พบภาพที่ตรงกับ "$q" ลองคำอื่นหรือพิมพ์เลข'
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
}
