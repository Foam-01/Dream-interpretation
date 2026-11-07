import 'package:flutter/material.dart';

import '../../data/category_ang.dart';
import '../../data/category_b.dart';
import '../../data/category_ch.dart';
import '../../data/category_chc.dart';
import '../../data/category_chg.dart';
import '../../data/category_d.dart';
import '../../data/category_f.dart';
import '../../data/category_fan.dart';
import '../../data/category_hip.dart';
import '../../data/category_k.dart';
import '../../data/category_kh.dart';
import '../../data/category_khr.dart';
import '../../data/category_khw.dart';
import '../../data/category_l.dart';
import '../../data/category_m.dart';
import '../../data/category_n.dart';
import '../../data/category_ng.dart';
import '../../data/category_p.dart';
import '../../data/category_phan.dart';
import '../../data/category_phueng.dart';
import '../../data/category_r.dart';
import '../../data/category_s.dart';
import '../../data/category_sala.dart';
import '../../data/category_samphao.dart';
import '../../data/category_suea.dart';
import '../../data/category_t.dart';
import '../../data/category_thahan.dart';
import '../../data/category_thong.dart';
import '../../data/category_thung.dart';
import '../../data/category_w.dart';
import '../../data/category_y.dart';
import '../../data/category_yak.dart';
import '../../data/design_data.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import '../letter_category_section.dart';
import '../../state/app_controller.dart';
import 'feature_list.dart';

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

/// Menus 13–44: one letter of the dream book, with a row to switch letters.
class LetterFeature extends StatelessWidget {
  final Widget header;
  final String featKey;
  const LetterFeature({super.key, required this.header, required this.featKey});

  @override
  Widget build(BuildContext context) => FeatureList(
    header: header,
    children: [
      _LetterSwitcher(current: featKey, onPick: AppScope.of(context).openFeat),
      LetterCategorySection(categoryId: _letterCategories[featKey]!),
    ],
  );
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
    final rows = [for (var s = 0; s < keys.length; s += perRow) keys.sublist(s, (s + perRow).clamp(0, keys.length))];
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: C.caption.withValues(alpha: .12))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (r, row) in rows.indexed) ...[
              if (r > 0) const SizedBox(height: 6),
              Row(
                children: [
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
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
