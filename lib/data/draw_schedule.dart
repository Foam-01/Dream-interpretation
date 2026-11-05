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
