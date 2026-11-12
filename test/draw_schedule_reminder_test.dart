// Reminder for the owner (F26): the moved-draw table (lib/data/draw_schedule.dart) only knows announced dates.
// This test reads today's date on purpose: it fails 14 days before the last checked draw, so the Government
// Lottery Office's announcements are checked in time. Fix: README, "Moved lottery draws".
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/draw_schedule.dart';
import 'package:maha_dream/data/formulas.dart';

/// How long before [drawShiftsCheckedUntil] the reminder starts failing.
const reminderLead = Duration(days: 14);

void main() {
  test('moved draws are checked at least 14 days ahead', () {
    final today = thaiToday(DateTime.now());
    expect(
      today.add(reminderLead).isAfter(drawShiftsCheckedUntil),
      isFalse,
      reason:
          'Draws after $drawShiftsCheckedUntil are not checked yet: look up the Government Lottery Office '
          'announcements, add any moved draw to drawShifts and raise drawShiftsCheckedUntil.',
    );
  });

  test('every moved draw in the table is within the checked period', () {
    for (final MapEntry(key: usual, value: real) in drawShifts.entries) {
      expect(usual.isAfter(drawShiftsCheckedUntil), isFalse, reason: '$usual');
      expect(real.isAfter(usual), isTrue, reason: 'a moved draw takes place after its usual date: $usual');
    }
  });
}
