import 'package:flutter/material.dart';

import '../../data/pae_numbers.dart';
import '../../theme.dart';
import 'picture_grid.dart';

/// Menu 6: the book's 1,000 pae kong pictures 21 a page with range chips; the search box looks
/// across all 1,000 by dream word or either number.
class PaeFeature extends StatelessWidget {
  final Widget header;
  const PaeFeature({super.key, required this.header});

  @override
  Widget build(BuildContext context) => PictureGridMenu<PaeNumber>(
        header: header,
        items: paeNumbers,
        rangeSize: 100,
        rangeLabel: (p) => p.number,
        matches: (p, q) => p.name.contains(q) || p.number == q || p.lucky == q,
        searchKey: const ValueKey('pae-search'),
        hint: 'ค้นหาสิ่งที่ฝัน เช่น ม้า หรือเลข',
        unit: 'ภาพ',
        noun: 'ภาพ',
        cell: (p) => PictureCard(
          name: p.name,
          numbers: [
            Text(p.lucky, style: serif(22, weight: FontWeight.w800, color: C.accent, height: 1.2)),
            const SizedBox(width: 10),
            Text('ภาพ ${p.number}', style: sans(11, color: C.caption, height: 1.4)),
          ],
          picture: Image.asset(p.image, fit: BoxFit.contain, cacheWidth: 300, semanticLabel: p.name),
        ),
      );
}
