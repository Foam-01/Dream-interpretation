import 'design_data.dart';
import 'draw_schedule.dart';

/// Weekday index with Sunday = 0 (design convention).
int weekdayIndex(DateTime d) => d.weekday % 7;

/// Thai lottery draws are on the 1st and 16th of each month, except the ones the lottery office moves
/// (drawShifts). Returns the real date of the next draw on or after [from] (time of day ignored).
DateTime nextDrawDate(DateTime from) {
  final d = DateTime(from.year, from.month, from.day);
  for (var m = 0; m < 3; m++) {
    for (final day in const [1, 16]) {
      final usual = DateTime(d.year, d.month + m, day);
      final real = drawShifts[usual] ?? usual;
      if (!real.isBefore(d)) return real;
    }
  }
  throw StateError('no draw found after $from');
}

/// The first draw on or after [from] that falls on [weekday] (Sunday = 0, as [weekdayIndex]).
/// Every weekday comes round within a few years of 1st/16th draws.
DateTime nextDrawOnWeekday(DateTime from, int weekday) {
  var d = nextDrawDate(from);
  for (var i = 0; i < 200 && weekdayIndex(d) != weekday; i++) {
    d = nextDrawDate(d.add(const Duration(days: 1)));
  }
  return d;
}

/// Which column of the book's tables a draw belongs to: the 1st or the 16th it was due on.
int drawRound(DateTime draw) {
  for (final MapEntry(:key, :value) in drawShifts.entries) {
    if (value == draw) return key.day;
  }
  return draw.day == 1 ? 1 : 16;
}

const _months = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];

/// e.g. "1 พ.ย. 2569"
String thaiDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year + 543}';

/// e.g. "1 พ.ย. 69"
String thaiDateShort(DateTime d) => '${d.day} ${_months[d.month - 1]} ${(d.year + 543) % 100}';

/// e.g. "วันศุกร์ที่ 23 ต.ค. 2569"
String thaiDateLong(DateTime d) => 'วัน${dayFull[weekdayIndex(d)]}ที่ ${thaiDate(d)}';
