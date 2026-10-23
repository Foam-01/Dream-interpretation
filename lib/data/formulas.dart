import 'design_data.dart';

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

/// Day-based formulas (features 1, 7, 9, 10). [i] is weekday index, Sunday = 0.
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
    case '9':
      return DayResult(
        [DayTile('ตัวเด่น', '$p', true), DayTile('ตัวกัน', '${(p + 4) % 10}', false)],
        [['ดาวประจำวัน', 'พระ$day ($p)'], ['ธาตุ', dayElement[i]], ['สีมงคล', dayColor[i]], ['เลขคู่เด่น', '$p$a · $a$p']],
        'สูตรเสียงโชค: นำกำลังดาว$dayบวกเลขฤกษ์ ได้ตัวเด่น $p ตัวกันคือดาวที่เป็นศัตรู',
        image: 'ภาพเทวดาประจำวัน$day',
      );
    case '10':
      return DayResult(
        [DayTile('วิ่ง 1', '$a', true), DayTile('วิ่ง 2', '$b', true), DayTile('วิ่ง 3', '$c', false)],
        [['เลขเจาะ 2 ตัว', '$a$b · $b$c'], ['รูด 19 ประตู', 'รูด $a'], ['3 ตัวโต๊ด', '$a$b$c']],
        'เลขวิ่งเปลี่ยนทุกวันตามดาวประจำวัน ใช้คู่กับเลขจากความฝันยิ่งแม่นยำ',
      );
    default:
      return DayResult(
        [DayTile('เลขประจำตัว', '$p', true), DayTile('เลขนำโชค', '$a$b', false)],
        [['การเงิน', '★★★★☆'], ['ความรัก', i.isOdd ? '★★★☆☆' : '★★★★★'], ['การงาน', '★★★★☆'], ['สีมงคล', dayColor[i]]],
        'ผู้เกิดวัน$day ช่วงนี้ดวงมีผู้ใหญ่อุปถัมภ์ หากฝันเห็นสัตว์ใหญ่ ทายว่าจะได้ลาภก้อนโต',
        image: 'ภาพดวงประจำวัน$day',
      );
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

/// Thai lottery draws on the 1st and 16th of each month.
DateTime nextDrawDate(DateTime from) {
  final d = DateTime(from.year, from.month, from.day);
  if (d.day == 1) return d;
  if (d.day <= 16) return DateTime(d.year, d.month, 16);
  return DateTime(d.year, d.month + 1, 1);
}

const _months = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];

/// e.g. "1 พ.ย. 2569"
String thaiDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year + 543}';

/// e.g. "1 พ.ย. 69"
String thaiDateShort(DateTime d) => '${d.day} ${_months[d.month - 1]} ${(d.year + 543) % 100}';

/// e.g. "วันศุกร์ที่ 23 ต.ค. 2569"
String thaiDateLong(DateTime d) => 'วัน${dayFull[weekdayIndex(d)]}ที่ ${thaiDate(d)}';
