// Feature 7 (เลขล็อคตามวัน): the table matches the transcription of the owner's book page 274.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/lock_numbers.dart';

void main() {
  test('บน / ล่าง per weekday and the note are the transcription in source.md', () {
    final src = File('backend/content/incoming/feature-07-lock-numbers/source.md')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    const days = ['อาทิตย์', 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัส', 'ศุกร์', 'เสาร์'];
    for (var i = 0; i < 7; i++) {
      expect(src, contains('| ${days[i]} | บน | ${lockTop[i].join(' | ')} |'), reason: days[i]);
      expect(src, contains('| ${days[i]} | ล่าง | ${lockBottom[i].join(' | ')} |'), reason: days[i]);
    }
    expect(src, contains(lockNote));
  });
}
