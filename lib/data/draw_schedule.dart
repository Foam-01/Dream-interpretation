/// Draws the Government Lottery Office (สำนักงานสลากกินแบ่งรัฐบาล) moved off the usual 1st / 16th.
/// Key: the usual date of the draw; value: the date it really takes place. Add each new announcement here,
/// with its reason and source; only announced dates belong in this table (never guessed ones).
final drawShifts = <DateTime, DateTime>{
  // 2569 (2026)
  DateTime(2026, 1, 1): DateTime(2026, 1, 2), // New Year's Day
  DateTime(2026, 1, 16): DateTime(2026, 1, 17), // Teachers' Day
  DateTime(2026, 5, 1): DateTime(2026, 5, 2), // National Labour Day
  DateTime(2026, 12, 16): DateTime(2026, 12, 17), // royal cremation ceremony; GLO notice, Oct 2569
  // 2570 (2027)
  DateTime(2027, 1, 1): DateTime(2027, 1, 2), // New Year; GLO notice, Oct 2569
};

/// Every draw up to and including this date has been checked against the Government Lottery Office's
/// announcements (news of the GLO notice of Oct 2569: 16 Dec 2569 → 17 Dec, 1 Jan 2570 → 2 Jan). After the next
/// check, add any moved draw above and raise this date (README, "Moved lottery draws").
/// test/draw_schedule_reminder_test.dart fails 14 days before it, as a reminder.
final drawShiftsCheckedUntil = DateTime(2027, 1, 2);
