/// Feature 10 (สูตรเลขวิ่งประจำวัน): the owner's book page 265, transcribed in
/// backend/content/incoming/feature-10-running-numbers/source.md. The page's last paragraph ("another method")
/// runs on to page 266; the owner left it to us, so the unfinished paragraph is left out rather than completed.
library;

const runningIntro =
    'สูตรเลขวิ่งประจำวันนี้ ถือหลักเกณฑ์เอาวันทั้ง 7 ในรอบสัปดาห์ ซึ่งเป็นวันออกสลาก ซึ่งอาจตรงกับวันที่ 1-16 หรือ 31 ของเดือนธันวาคมก็ตามแต่ ให้ถือเอากำลัง หรืออิทธิพลของวันทั้ง 7 ในสัปดาห์ เป็นหลักสำคัญไว้ก่อน คือ';

const runningTableTitle = 'อิทธิพลเลขกำลังวัน';

/// "ถ้าสลากออกวัน … งวดนั้นจะมีเลขวิ่ง …", by the draw's weekday (Sunday = 0, as weekdayIndex).
const runningByDrawDay = [
  ['1', '8', '4'], // อาทิตย์
  ['9', '3', '7'], // จันทร์
  ['3', '0', '5'], // อังคาร
  ['2', '8', '4'], // พุธ
  ['1', '4', '7'], // พฤหัสบดี
  ['6', '3', '5'], // ศุกร์
  ['1', '5', '8'], // เสาร์
];
