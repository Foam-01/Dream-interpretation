import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../data/dream_chant.dart';
import '../../theme.dart';
import 'feature_list.dart';

/// Menu 11: the owner's book page — intro, then the three stanzas in one card.
class ChantFeature extends StatefulWidget {
  final Widget header;
  const ChantFeature({super.key, required this.header});

  @override
  State<ChantFeature> createState() => _ChantFeatureState();
}

class _ChantFeatureState extends State<ChantFeature> {
  static const _chantScales = [1.0, 1.15, 1.3, 1.5];
  double _chantScale = 1.0;

  Widget _sizeButton(String text, String label, bool enabled, int step) => Semantics(
        button: true,
        enabled: enabled,
        label: label,
        excludeSemantics: true,
        child: SizedBox(
          width: 48,
          height: 48,
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
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _chantBody());

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
}
