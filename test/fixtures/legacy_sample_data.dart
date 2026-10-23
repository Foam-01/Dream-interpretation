// The former bundled SAMPLE design data (10 dreams, 5 thematic categories), kept only as a test fixture:
// repository/search mechanics tests and the backend sample-fixture check (backend/prisma/seed-data.spec.ts)
// use it. The app itself now bundles the real หมวด ก content (lib/data/dreams_k.dart).
// dart format off — backend/prisma/seed-data.spec.ts parses the Dream(...) lines below.
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';

const legacySampleCats = ['ทั้งหมด', 'สัตว์', 'ร่างกาย', 'ธรรมชาติ', 'บุคคล', 'สิ่งของ'];

const legacySampleCategories = [
  DreamCategory('animal', 'สัตว์'),
  DreamCategory('body', 'ร่างกาย'),
  DreamCategory('nature', 'ธรรมชาติ'),
  DreamCategory('person', 'บุคคล'),
  DreamCategory('object', 'สิ่งของ'),
];

/// Repository over the legacy sample data (same rules as the bundled repository).
const legacySampleRepository = SampleDreamRepository(source: legacySampleDreams, categoryList: legacySampleCategories);

const legacySampleDreams = <Dream>[
  Dream('snake', 'งู', 'สัตว์', LuckyNumbers(twoDigit: ['56', '65'], threeDigit: ['567', '556']), ['5', '6'], 'จะได้พบเนื้อคู่ หรือมีโชคลาภ',
      'ฝันเห็นงูตามตำราโบราณ หมายถึงเนื้อคู่หรือคนรักกำลังจะเข้ามา หากงูรัดตัวแน่น ทายว่าจะได้คู่ครองในเร็ววัน ผู้มีคู่แล้วจะได้โชคลาภจากคนใกล้ตัว',
      LuckForecast(money: 84, love: 90, health: 62), true, 'ให้ทำบุญใส่บาตรในวันเกิด อธิษฐานขอให้โชคนี้มาถึงโดยไว'),
  Dream('elephant', 'ช้าง', 'สัตว์', LuckyNumbers(twoDigit: ['91', '19'], threeDigit: ['919', '199']), ['9', '1'], 'จะมีผู้ใหญ่อุปถัมภ์ ยศถาบรรดาศักดิ์',
      'ฝันเห็นช้างหมายถึงบารมี จะได้รับการสนับสนุนจากผู้ใหญ่ หน้าที่การงานก้าวหน้า หากขี่ช้างทายว่าจะได้เลื่อนตำแหน่ง',
      LuckForecast(money: 92, love: 70, health: 75), true, 'ถวายดอกดาวเรืองแด่พระพิฆเนศ แล้วขอพรเรื่องงาน'),
  Dream('tooth-falling-out', 'ฟันหลุด', 'ร่างกาย', LuckyNumbers(twoDigit: ['08', '80'], threeDigit: ['098', '809']), ['0', '8'], 'ระวังเรื่องญาติผู้ใหญ่ สุขภาพ',
      'ฝันว่าฟันหลุด ตำราว่าเป็นลางเตือนเรื่องญาติผู้ใหญ่หรือคนในบ้าน ควรดูแลสุขภาพและระมัดระวังการเดินทาง',
      LuckForecast(money: 45, love: 40, health: 58), false, 'ตื่นเช้าให้บ้วนน้ำลายลงดิน กล่าว "ขอให้ฝันร้ายกลายเป็นดี" แล้วกรวดน้ำให้เจ้ากรรมนายเวร'),
  Dream('flood', 'น้ำท่วม', 'ธรรมชาติ', LuckyNumbers(twoDigit: ['27', '72'], threeDigit: ['277', '720']), ['2', '7'], 'ทรัพย์สินไหลมาเทมา',
      'ฝันเห็นน้ำท่วมบ้าน หมายถึงจะมีทรัพย์สินเงินทองไหลเข้ามาอย่างล้นเหลือ หากน้ำใสยิ่งเป็นมงคล',
      LuckForecast(money: 88, love: 65, health: 70), true, 'จุดธูป 9 ดอกบอกเจ้าที่ ขอให้โชคลาภไหลมาเทมา'),
  Dream('fish', 'ปลา', 'สัตว์', LuckyNumbers(twoDigit: ['84', '48'], threeDigit: ['844', '468']), ['8', '4'], 'จะได้ลาภก้อนเล็ก',
      'ฝันเห็นปลาว่ายน้ำ ทายว่าจะได้ลาภลอย หากจับปลาได้จะได้เงินก้อนโดยไม่คาดคิด',
      LuckForecast(money: 80, love: 60, health: 72), true, 'ปล่อยปลาในวันพระ ช่วยเสริมโชคตามฝัน'),
  Dream('fire', 'ไฟไหม้', 'ธรรมชาติ', LuckyNumbers(twoDigit: ['34', '43'], threeDigit: ['347', '430']), ['3', '4'], 'จะได้ลาภใหญ่ ธุรกิจรุ่งเรือง',
      'ฝันเห็นไฟไหม้บ้าน ตำราโบราณว่าเป็นฝันดี กิจการจะรุ่งเรืองเหมือนไฟลุกโชน จะได้ลาภใหญ่',
      LuckForecast(money: 78, love: 55, health: 66), true, 'ทำบุญถวายเทียนที่วัด เสริมความรุ่งเรือง'),
  Dream('monk', 'พระ', 'บุคคล', LuckyNumbers(twoDigit: ['89', '98'], threeDigit: ['889', '908']), ['8', '9'], 'สิ่งศักดิ์สิทธิ์คุ้มครอง',
      'ฝันเห็นพระสงฆ์ หมายถึงบุญบารมีส่งผล จะพ้นเคราะห์ และมีสิ่งศักดิ์สิทธิ์คุ้มครอง',
      LuckForecast(money: 75, love: 80, health: 85), true, 'สวดบทอิติปิโส 9 จบ ก่อนนอน'),
  Dream('dead-person', 'คนตาย', 'บุคคล', LuckyNumbers(twoDigit: ['09', '90'], threeDigit: ['090', '900']), ['0', '9'], 'จะมีอายุยืน พ้นเคราะห์',
      'ฝันเห็นคนตาย ตำราว่าเป็นฝันกลับ ผู้ฝันจะมีอายุยืน เคราะห์ร้ายจะหมดไป',
      LuckForecast(money: 60, love: 55, health: 82), false, 'กรวดน้ำอุทิศส่วนกุศล และสวดบทแก้ฝันร้ายก่อนนอน 3 คืน'),
  Dream('gold', 'ทองคำ', 'สิ่งของ', LuckyNumbers(twoDigit: ['59', '95'], threeDigit: ['559', '959']), ['5', '9'], 'โชคลาภ เงินทองเพิ่มพูน',
      'ฝันว่าได้ทองคำ ทายว่าจะได้ทรัพย์ หากใส่สร้อยทองจะได้เกียรติยศ',
      LuckForecast(money: 90, love: 68, health: 70), true, 'ไหว้แม่กวนอิมด้วยผลไม้สีเหลือง'),
  Dream('tiger', 'เสือ', 'สัตว์', LuckyNumbers(twoDigit: ['37', '73'], threeDigit: ['373', '737']), ['3', '7'], 'จะได้อำนาจ บารมี',
      'ฝันเห็นเสือ หมายถึงอำนาจวาสนา จะมีคนเกรงขาม หากเสือไล่ให้ระวังศัตรู',
      LuckForecast(money: 70, love: 50, health: 65), true, 'บูชาพ่อแก่ ขอให้มีบารมีคุ้มครอง'),
];
