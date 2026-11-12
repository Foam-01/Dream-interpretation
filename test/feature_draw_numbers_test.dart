// Feature 8 (สูตรเลขเด่นประจำวัน): the table matches the transcription of the owner's book page.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/draw_numbers.dart';

void main() {
  test('intro and the weekday × (1st, 16th) table are the transcription in source.md', () {
    final src = File('backend/content/incoming/feature-08-draw-numbers/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    expect(src, contains(drawIntro));
    for (var i = 0; i < 7; i++) {
      expect(
        src,
        contains('| วัน${dayFull[i]} | ${drawLead[i][0].join(' ')} | ${drawLead[i][1].join(' ')} |'),
        reason: dayFull[i],
      );
    }
  });

  test('a draw due on the 1st reads the first column, on the 16th the second', () {
    expect(drawLeadFor(1, 0), ['5', '7', '4']);
    expect(drawLeadFor(16, 5), ['6', '3', '4']);
  });
}
