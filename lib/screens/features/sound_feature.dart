import 'package:flutter/material.dart';

import '../../data/design_data.dart';
import '../../data/formulas.dart';
import '../../data/sound_numbers.dart';
import '../../theme.dart';
import '../../widgets/ui.dart';
import 'feature_list.dart';

/// Menu 9: the book's lead / block groups by the draw's weekday; opens on the next draw.
class SoundFeature extends StatefulWidget {
  final Widget header;
  /// Reference time: the next draw opens on its weekday.
  final DateTime now;
  const SoundFeature({super.key, required this.header, required this.now});

  @override
  State<SoundFeature> createState() => _SoundFeatureState();
}

class _SoundFeatureState extends State<SoundFeature> {
  late final DateTime _draw = nextDrawDate(widget.now);
  late int _soundDay = weekdayIndex(_draw);

  @override
  Widget build(BuildContext context) => FeatureList(header: widget.header, children: _soundBody());

  List<Widget> _soundBody() {
    final lead = soundLead[_soundDay];
    final block = soundBlock[_soundDay];
    final isDrawDay = _soundDay == weekdayIndex(_draw);
    Widget group(String title, List<String> nums, {required bool dark}) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: dark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [C.brandBright, C.brand],
                  )
                : null,
            color: dark ? null : C.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.goldDeep, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: serif(16, color: C.accent)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final n in nums)
                  Container(
                    width: 52,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: dark ? goldGradient : null,
                      color: dark ? null : C.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: dark ? C.goldDeep : C.goldBorder, width: 1),
                      boxShadow: dark
                          ? const [BoxShadow(color: C.shadow, blurRadius: 4, offset: Offset(0, 2))]
                          : null,
                    ),
                    child: Text(
                      n,
                      style: serif(
                        18,
                        weight: dark ? FontWeight.w800 : FontWeight.w600,
                        color: dark ? C.onGold : C.goldLight,
                        height: 1.2,
                      ),
                    ),
                  ),
              ]),
            ],
          ),
        );
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
        child: Row(children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SelectPill(
                  text: dayShort[i],
                  selected: _soundDay == i,
                  onTap: () => setState(() => _soundDay = i),
                  radius: 10,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: C.brand,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.goldDeep, width: 2),
          ),
          child: Column(children: [
            if (soundImages[_soundDay] case final img?) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(img, fit: BoxFit.cover, semanticLabel: 'ภาพประจำวัน${dayFull[_soundDay]}'),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              isDrawDay ? 'งวด ${thaiDate(_draw)} สลากออกวัน${dayFull[_soundDay]}' : 'ถ้าสลากออกวัน${dayFull[_soundDay]}',
              textAlign: TextAlign.center,
              style: serif(17, color: C.goldLight),
            ),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          group('กลุ่มเลขตัวเด่น', lead, dark: true),
          const SizedBox(height: 18),
          group('กลุ่มเลขตัวกัน', block, dark: false),
        ]),
      ),
    ];
  }
}
