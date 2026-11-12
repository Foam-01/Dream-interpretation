/// Feature 8 (สูตรเลขเด่นประจำวัน): the owner's book page, transcribed in
/// backend/content/incoming/feature-08-draw-numbers/source.md. The sentence under the table runs on to a page we
/// do not have, so it is left out rather than completed.
library;

const drawIntro =
    'สูตรนี้ เป็นการเทียบเคียงกำลังวัน กับวันที่จะทำการออกสลาก เพื่อหาเลขเด่นในงวดต่อไป หรืองวดหน้าให้ท่านดูตามแผนเลขว่า จะออกวันอะไร (ในสัปดาห์) และตรงกับวันที่เท่าไรของงวดที่ออก ดังนี้';

/// Lead numbers by the draw's weekday (Sunday = 0, as weekdayIndex): [วันที่ 1, วันที่ 16].
const drawLead = [
  [
    ['5', '7', '4'],
    ['6', '4', '5'],
  ], // อาทิตย์
  [
    ['4', '7', '9'],
    ['4', '9', '3'],
  ], // จันทร์
  [
    ['7', '3', '4'],
    ['6', '1', '3'],
  ], // อังคาร
  [
    ['5', '9', '4'],
    ['6', '4', '2'],
  ], // พุธ
  [
    ['3', '5', '8'],
    ['8', '2', '3'],
  ], // พฤหัสบดี
  [
    ['5', '4', '3'],
    ['6', '3', '4'],
  ], // ศุกร์
  [
    ['4', '7', '8'],
    ['1', '5', '7'],
  ], // เสาร์
];

/// The lead numbers for a draw: the weekday it really falls on, and the round (1st or 16th) it was due on.
List<String> drawLeadFor(int round, int weekday) => drawLead[weekday][round == 1 ? 0 : 1];
