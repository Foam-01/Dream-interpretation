import 'package:flutter/material.dart';

import '../../data/animal_numbers.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'picture_grid.dart';

/// Menu 5: each animal with its number pair and picture, 21 a page; range chips filter by number,
/// the search box looks across all 100.
class AnimalsFeature extends StatelessWidget {
  final Widget header;
  const AnimalsFeature({super.key, required this.header});

  @override
  Widget build(BuildContext context) => PictureGridMenu<AnimalNumber>(
    header: header,
    items: animalNumbers,
    rangeSize: 20,
    rangeLabel: (a) => a.number,
    matches: (a, q) => a.name.contains(q) || a.number == q || a.pair == q,
    searchKey: const ValueKey('animal-search'),
    hint: 'ค้นหาชื่อสัตว์ เช่น ช้าง หรือเลข',
    unit: 'ตัว',
    noun: 'สัตว์',
    cell: (a) => PictureCard(
      name: a.name,
      numbers: [
        Text(
          a.number,
          style: serif(22, weight: FontWeight.w800, color: C.accent, height: 1.2),
        ),
        const SizedBox(width: 14),
        Text(a.pair, style: serif(16, color: C.textSoft, height: 1.2)),
      ],
      picture: a.image == null
          ? ImagePlaceholder('ภาพ', width: double.infinity, fontSize: 9, band: 6)
          : Image.asset(a.image!, fit: BoxFit.contain, semanticLabel: a.name),
    ),
  );
}
