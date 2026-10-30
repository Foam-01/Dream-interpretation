// Sample/demo content copied verbatim from the Flutter app (lib/data/design_data.dart).
// NOT verified traditional knowledge: every dream is seeded with contentStatus SAMPLE.
// test/seed-data.spec.ts re-parses the Dart file to ensure this stays in sync.

export interface SeedCategory {
  id: string;
  name: string;
  sortOrder: number;
}

export interface SeedDream {
  id: string;
  name: string;
  categoryId: string;
  short: string;
  meaning: string;
  advice: string;
  isGoodOmen: boolean;
  digits: string[];
  twoDigit: string[];
  threeDigit: string[];
  luckMoney: number;
  luckLove: number;
  luckHealth: number;
  sortOrder: number;
}

/** Category slugs are API identifiers; names are the Thai labels used by the app (order preserved). */
export const seedCategories: SeedCategory[] = [
  { id: 'animal', name: 'สัตว์', sortOrder: 1 },
  { id: 'body', name: 'ร่างกาย', sortOrder: 2 },
  { id: 'nature', name: 'ธรรมชาติ', sortOrder: 3 },
  { id: 'person', name: 'บุคคล', sortOrder: 4 },
  { id: 'object', name: 'สิ่งของ', sortOrder: 5 },
];

/**
 * Categories for real (sourced) content, organised by initial letter. Not part of the app's bundled
 * SAMPLE data, so they are kept apart from seedCategories (which must mirror the Flutter sample list).
 * The seed creates them so imports can reference them; it adds no dreams to them.
 */
export const contentCategories: SeedCategory[] = [
  { id: 'letter-k', name: 'หมวด ก', sortOrder: 6 },
  { id: 'letter-kh', name: 'หมวด ข', sortOrder: 7 },
  { id: 'letter-khw', name: 'หมวด ค', sortOrder: 8 },
  { id: 'letter-khr', name: 'หมวด ฆ', sortOrder: 9 },
  { id: 'letter-ng', name: 'หมวด ง', sortOrder: 10 },
  { id: 'letter-ch', name: 'หมวด จ', sortOrder: 11 },
  { id: 'letter-chg', name: 'หมวด ฉ', sortOrder: 12 },
  { id: 'letter-chc', name: 'หมวด ช', sortOrder: 13 },
  { id: 'letter-s', name: 'หมวด ซ', sortOrder: 14 },
  { id: 'letter-y', name: 'หมวด ญ', sortOrder: 15 },
];

/** Every category the seed creates. */
export const allCategories: SeedCategory[] = [...seedCategories, ...contentCategories];

export const seedDreams: SeedDream[] = [
  {
    id: 'snake',
    name: 'งู',
    categoryId: 'animal',
    short: 'จะได้พบเนื้อคู่ หรือมีโชคลาภ',
    meaning:
      'ฝันเห็นงูตามตำราโบราณ หมายถึงเนื้อคู่หรือคนรักกำลังจะเข้ามา หากงูรัดตัวแน่น ทายว่าจะได้คู่ครองในเร็ววัน ผู้มีคู่แล้วจะได้โชคลาภจากคนใกล้ตัว',
    advice: 'ให้ทำบุญใส่บาตรในวันเกิด อธิษฐานขอให้โชคนี้มาถึงโดยไว',
    isGoodOmen: true,
    digits: ['5', '6'],
    twoDigit: ['56', '65'],
    threeDigit: ['567', '556'],
    luckMoney: 84,
    luckLove: 90,
    luckHealth: 62,
    sortOrder: 1,
  },
  {
    id: 'elephant',
    name: 'ช้าง',
    categoryId: 'animal',
    short: 'จะมีผู้ใหญ่อุปถัมภ์ ยศถาบรรดาศักดิ์',
    meaning:
      'ฝันเห็นช้างหมายถึงบารมี จะได้รับการสนับสนุนจากผู้ใหญ่ หน้าที่การงานก้าวหน้า หากขี่ช้างทายว่าจะได้เลื่อนตำแหน่ง',
    advice: 'ถวายดอกดาวเรืองแด่พระพิฆเนศ แล้วขอพรเรื่องงาน',
    isGoodOmen: true,
    digits: ['9', '1'],
    twoDigit: ['91', '19'],
    threeDigit: ['919', '199'],
    luckMoney: 92,
    luckLove: 70,
    luckHealth: 75,
    sortOrder: 2,
  },
  {
    id: 'tooth-falling-out',
    name: 'ฟันหลุด',
    categoryId: 'body',
    short: 'ระวังเรื่องญาติผู้ใหญ่ สุขภาพ',
    meaning: 'ฝันว่าฟันหลุด ตำราว่าเป็นลางเตือนเรื่องญาติผู้ใหญ่หรือคนในบ้าน ควรดูแลสุขภาพและระมัดระวังการเดินทาง',
    advice: 'ตื่นเช้าให้บ้วนน้ำลายลงดิน กล่าว "ขอให้ฝันร้ายกลายเป็นดี" แล้วกรวดน้ำให้เจ้ากรรมนายเวร',
    isGoodOmen: false,
    digits: ['0', '8'],
    twoDigit: ['08', '80'],
    threeDigit: ['098', '809'],
    luckMoney: 45,
    luckLove: 40,
    luckHealth: 58,
    sortOrder: 3,
  },
  {
    id: 'flood',
    name: 'น้ำท่วม',
    categoryId: 'nature',
    short: 'ทรัพย์สินไหลมาเทมา',
    meaning: 'ฝันเห็นน้ำท่วมบ้าน หมายถึงจะมีทรัพย์สินเงินทองไหลเข้ามาอย่างล้นเหลือ หากน้ำใสยิ่งเป็นมงคล',
    advice: 'จุดธูป 9 ดอกบอกเจ้าที่ ขอให้โชคลาภไหลมาเทมา',
    isGoodOmen: true,
    digits: ['2', '7'],
    twoDigit: ['27', '72'],
    threeDigit: ['277', '720'],
    luckMoney: 88,
    luckLove: 65,
    luckHealth: 70,
    sortOrder: 4,
  },
  {
    id: 'fish',
    name: 'ปลา',
    categoryId: 'animal',
    short: 'จะได้ลาภก้อนเล็ก',
    meaning: 'ฝันเห็นปลาว่ายน้ำ ทายว่าจะได้ลาภลอย หากจับปลาได้จะได้เงินก้อนโดยไม่คาดคิด',
    advice: 'ปล่อยปลาในวันพระ ช่วยเสริมโชคตามฝัน',
    isGoodOmen: true,
    digits: ['8', '4'],
    twoDigit: ['84', '48'],
    threeDigit: ['844', '468'],
    luckMoney: 80,
    luckLove: 60,
    luckHealth: 72,
    sortOrder: 5,
  },
  {
    id: 'fire',
    name: 'ไฟไหม้',
    categoryId: 'nature',
    short: 'จะได้ลาภใหญ่ ธุรกิจรุ่งเรือง',
    meaning: 'ฝันเห็นไฟไหม้บ้าน ตำราโบราณว่าเป็นฝันดี กิจการจะรุ่งเรืองเหมือนไฟลุกโชน จะได้ลาภใหญ่',
    advice: 'ทำบุญถวายเทียนที่วัด เสริมความรุ่งเรือง',
    isGoodOmen: true,
    digits: ['3', '4'],
    twoDigit: ['34', '43'],
    threeDigit: ['347', '430'],
    luckMoney: 78,
    luckLove: 55,
    luckHealth: 66,
    sortOrder: 6,
  },
  {
    id: 'monk',
    name: 'พระ',
    categoryId: 'person',
    short: 'สิ่งศักดิ์สิทธิ์คุ้มครอง',
    meaning: 'ฝันเห็นพระสงฆ์ หมายถึงบุญบารมีส่งผล จะพ้นเคราะห์ และมีสิ่งศักดิ์สิทธิ์คุ้มครอง',
    advice: 'สวดบทอิติปิโส 9 จบ ก่อนนอน',
    isGoodOmen: true,
    digits: ['8', '9'],
    twoDigit: ['89', '98'],
    threeDigit: ['889', '908'],
    luckMoney: 75,
    luckLove: 80,
    luckHealth: 85,
    sortOrder: 7,
  },
  {
    id: 'dead-person',
    name: 'คนตาย',
    categoryId: 'person',
    short: 'จะมีอายุยืน พ้นเคราะห์',
    meaning: 'ฝันเห็นคนตาย ตำราว่าเป็นฝันกลับ ผู้ฝันจะมีอายุยืน เคราะห์ร้ายจะหมดไป',
    advice: 'กรวดน้ำอุทิศส่วนกุศล และสวดบทแก้ฝันร้ายก่อนนอน 3 คืน',
    isGoodOmen: false,
    digits: ['0', '9'],
    twoDigit: ['09', '90'],
    threeDigit: ['090', '900'],
    luckMoney: 60,
    luckLove: 55,
    luckHealth: 82,
    sortOrder: 8,
  },
  {
    id: 'gold',
    name: 'ทองคำ',
    categoryId: 'object',
    short: 'โชคลาภ เงินทองเพิ่มพูน',
    meaning: 'ฝันว่าได้ทองคำ ทายว่าจะได้ทรัพย์ หากใส่สร้อยทองจะได้เกียรติยศ',
    advice: 'ไหว้แม่กวนอิมด้วยผลไม้สีเหลือง',
    isGoodOmen: true,
    digits: ['5', '9'],
    twoDigit: ['59', '95'],
    threeDigit: ['559', '959'],
    luckMoney: 90,
    luckLove: 68,
    luckHealth: 70,
    sortOrder: 9,
  },
  {
    id: 'tiger',
    name: 'เสือ',
    categoryId: 'animal',
    short: 'จะได้อำนาจ บารมี',
    meaning: 'ฝันเห็นเสือ หมายถึงอำนาจวาสนา จะมีคนเกรงขาม หากเสือไล่ให้ระวังศัตรู',
    advice: 'บูชาพ่อแก่ ขอให้มีบารมีคุ้มครอง',
    isGoodOmen: true,
    digits: ['3', '7'],
    twoDigit: ['37', '73'],
    threeDigit: ['373', '737'],
    luckMoney: 70,
    luckLove: 50,
    luckHealth: 65,
    sortOrder: 10,
  },
];
