import 'design_data.dart';
import 'draw_schedule.dart';

class DayTile {
  final String label, value;
  final bool dark;
  const DayTile(this.label, this.value, this.dark);
}

class DayResult {
  final String? image;
  final List<DayTile> tiles;
  final List<List<String>> rows;
  final String note;
  const DayResult(this.tiles, this.rows, this.note, {this.image});
}

/// Day-based formulas (feature 7). [i] is weekday index, Sunday = 0.
/// Ported 1:1 from the design's `dayData`.
DayResult dayData(String k, int i) {
  final p = i + 1;
  final a = (p * 3 + i) % 10, b = (p + 5) % 10, c = (p * 7 + 2) % 10;
  final u = '$p${(p + i + 4) % 10}';
  final l = '${(i * 2 + 6) % 10}${(p * 4) % 10}';
  final day = dayFull[i];
  switch (k) {
    case '7':
      return DayResult(
        [DayTile('บน', u.split('').join(' '), true), DayTile('ล่าง', l.split('').join(' '), false)],
        [['3 ตัวบน', '$u$a'], ['เลขรอง', '$b$c'], ['เลขเบิ้ล', '$p$p']],
        'เลขล็อควัน$day คำนวณจากดาวประจำวัน ($p) และฤกษ์ยามงวดนี้',
      );
    default:
      throw ArgumentError.value(k, 'k', 'not a day-based feature');
  }
}

class Pae {
  final String num, name, rev;
  const Pae(this.num, this.name, this.rev);
}

Pae paeOf(int n) {
  final num = n.toString().padLeft(3, '0');
  return Pae(num, paeWords[(n * 7 + n ~/ 10) % paeWords.length], num.split('').reversed.join());
}

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
