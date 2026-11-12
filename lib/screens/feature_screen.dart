import 'package:flutter/material.dart';

import '../data/design_data.dart';
import '../state/app_controller.dart';
import '../widgets/ui.dart';
import 'features/animals_feature.dart';
import 'features/chant_feature.dart';
import 'features/digit_feature.dart';
import 'features/draw_feature.dart';
import 'features/letter_feature.dart';
import 'features/lock_feature.dart';
import 'features/lore_feature.dart';
import 'features/pae_feature.dart';
import 'features/remedies_feature.dart';
import 'features/running_feature.dart';
import 'features/sound_feature.dart';
import 'features/steps_feature.dart';

/// One feature page: the shared header, then the menu's own screen (lib/screens/features/).
class FeatureScreen extends StatelessWidget {
  final String featKey;

  /// Reference time: initial weekday of day-based features and draw dates (feature 8).
  final DateTime now;
  const FeatureScreen({super.key, required this.featKey, required this.now});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final k = featKey;
    final f = feats[k]!;
    final header = FeatureHeader(
      backLabel: menus[app.tab]?.title ?? 'กลับ',
      onBack: () => app.goTab(app.tab),
      title: f.title,
      sub: f.sub,
    );
    return switch (f.type) {
      FeatType.lock => LockFeature(header: header, now: now),
      FeatType.steps => StepsFeature(header: header, featKey: k),
      FeatType.remedies => RemediesFeature(header: header),
      FeatType.chant => ChantFeature(header: header),
      FeatType.running => RunningFeature(header: header, now: now),
      FeatType.sound => SoundFeature(header: header, now: now),
      FeatType.animals => AnimalsFeature(header: header),
      FeatType.pae => PaeFeature(header: header),
      FeatType.digit => DigitFeature(header: header),
      FeatType.table => LoreFeature(header: header),
      FeatType.draw => DrawFeature(header: header, now: now),
      FeatType.letter => LetterFeature(header: header, featKey: k),
    };
  }
}
