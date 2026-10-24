// Content ported from Claude Design `Dream App.dc.html`.
// Lottery numbers are kept as String to preserve leading zeros ("08").

import 'dreams_k.dart';

/// Two- and three-digit lucky numbers of a dream, stored as literal strings so
/// leading zeros survive ("08", "098"). Never derived from other fields.
class LuckyNumbers {
  /// For data that is already immutable (e.g. `const` list literals).
  ///
  /// This constructor stores the given lists as-is; it does NOT copy them, so a
  /// caller that keeps and mutates a list passed here would change this object.
  /// Use [LuckyNumbers.copy] for lists that may be modified later.
  // Private named parameters are passed as `twoDigit:` / `threeDigit:`.
  const LuckyNumbers({required this._twoDigit, required this._threeDigit});

  /// For input lists that may be mutable (e.g. parsed at runtime).
  ///
  /// Copies both lists into unmodifiable lists at construction time, so later
  /// changes to the input lists do not affect this object.
  factory LuckyNumbers.copy({required List<String> twoDigit, required List<String> threeDigit}) =>
      LuckyNumbers(twoDigit: List.unmodifiable(twoDigit), threeDigit: List.unmodifiable(threeDigit));

  /// The source says "ไม่ควรเสี่ยง": no lucky numbers at all (both lists empty).
  const LuckyNumbers.none() : _twoDigit = const [], _threeDigit = const [];

  /// Text shown instead of numbers for [LuckyNumbers.none].
  static const noLuckyNumbersText = 'ไม่ควรเสี่ยง';

  /// True for "ไม่ควรเสี่ยง" (no numbers in either list).
  bool get isNone => _twoDigit.isEmpty && _threeDigit.isEmpty;

  final List<String> _twoDigit;
  final List<String> _threeDigit;

  /// Unmodifiable copies; mutating the returned list throws [UnsupportedError].
  List<String> get twoDigit => List.unmodifiable(_twoDigit);
  List<String> get threeDigit => List.unmodifiable(_threeDigit);

  /// Display separator used throughout the UI (space, U+00B7, space).
  static const separator = ' · ';

  String get twoDisplay => isNone ? noLuckyNumbersText : _twoDigit.join(separator);
  String get threeDisplay => isNone ? noLuckyNumbersText : _threeDigit.join(separator);
  String get firstTwo => isNone ? noLuckyNumbersText : _twoDigit.first;

  /// Problems with the data; empty when valid. Each value must be exactly 2
  /// (or 3) ASCII digits 0-9: rejects empty lists, empty strings, spaces,
  /// non-digit characters (incl. Thai digits) and wrong lengths. Never fixes data.
  /// [LuckyNumbers.none] ("ไม่ควรเสี่ยง") is valid; one empty list on its own is not.
  List<String> validate() => isNone ? const [] : [
        if (_twoDigit.isEmpty) 'twoDigit is empty',
        if (_threeDigit.isEmpty) 'threeDigit is empty',
        for (final n in _twoDigit)
          if (!RegExp(r'^\d{2}$').hasMatch(n)) 'twoDigit "$n" is not 2 digits',
        for (final n in _threeDigit)
          if (!RegExp(r'^\d{3}$').hasMatch(n)) 'threeDigit "$n" is not 3 digits',
      ];
}

/// Sample forecast scores (0-100) shown as bars on the dream detail page.
/// These are design sample values, not verified predictions.
class LuckForecast {
  const LuckForecast({required this.money, required this.love, required this.health})
      : assert(money >= 0 && money <= 100, 'money must be 0-100'),
        assert(love >= 0 && love <= 100, 'love must be 0-100'),
        assert(health >= 0 && health <= 100, 'health must be 0-100');

  /// การเงิน
  final int money;

  /// ความรัก
  final int love;

  /// สุขภาพ
  final int health;

  /// Range problems for the given scores (each must be 0-100 inclusive); empty
  /// when valid. Works with assertions disabled; never clamps or fixes values.
  static List<String> check({required int money, required int love, required int health}) => [
        for (final (field, value) in [('money', money), ('love', love), ('health', health)])
          if (value < 0 || value > 100) '$field $value is outside 0-100',
      ];

  /// Runtime check of this forecast (the constructor asserts only run when
  /// assertions are enabled, e.g. debug builds and tests).
  List<String> validate() => check(money: money, love: love, health: health);
}

/// Illustration of a dream: from the API (https URL with the required attribution) or bundled with the app.
class DreamImage {
  /// https URL, or an asset path (`assets/…`) for bundled images. Neither is trusted to load:
  /// callers need a fallback.
  final String url;
  final String? alt, sourceUrl;

  /// Required for API images; null for images bundled by the content owner.
  final String? credit, license;
  const DreamImage({
    required this.url,
    required String this.credit,
    required String this.license,
    this.alt,
    this.sourceUrl,
  });

  /// An image bundled with the app (supplied by the content owner; no attribution line).
  const DreamImage.asset(this.url, {this.alt}) : credit = null, license = null, sourceUrl = null;

  bool get isAsset => url.startsWith('assets/');

  /// Caption shown with the image, e.g. "ภาพ: ชื่อผู้ถ่าย · CC BY 4.0"; null when there is no credit.
  String? get attribution => credit == null ? null : 'ภาพ: $credit${license == null ? '' : ' · $license'}';
}

/// Citation of the interpretation text (API field `source`), kept apart from the image credit.
class DreamSource {
  final String id, title;
  final String? author, publisher, edition, url;
  final int? year;

  /// Page or section within the source, e.g. "หน้า 12".
  final String? locator;
  const DreamSource({
    required this.id,
    required this.title,
    this.author,
    this.publisher,
    this.edition,
    this.year,
    this.url,
    this.locator,
  });

  /// One line for display: title, author, year and locator when known.
  String get citation => [title, ?author, if (year != null) '$year', ?locator].join(' · ');
}

class Dream {
  /// Stable identifier (English slug). Never derived from list position.
  final String id;
  final String name, cat, short, meaning;
  final LuckyNumbers numbers;

  /// Single lucky digits; may be empty for sourced content.
  final List<String> digits;

  /// Optional for sourced content (printed sources rarely give advice, omen polarity or scores);
  /// always present in the bundled SAMPLE data.
  final String? advice;
  final LuckForecast? luckForecast;
  final bool? good;

  final DreamImage? image;
  final DreamSource? source;

  /// Extra search keywords from the API.
  final List<String> aliases;
  const Dream(this.id, this.name, this.cat, this.numbers, this.digits, this.short, this.meaning, this.luckForecast,
      this.good, this.advice,
      {this.image, this.source, this.aliases = const []});

  // Compatibility getters kept for existing call sites (display strings unchanged).
  String get two => numbers.twoDisplay;
  String get three => numbers.threeDisplay;
  String get firstTwo => numbers.firstTwo;

  /// Data problems of this dream, prefixed by the failing part; empty when valid.
  List<String> validate() => [
        for (final p in numbers.validate()) 'numbers: $p',
        for (final p in luckForecast?.validate() ?? const <String>[]) 'luckForecast: $p',
      ];
}

/// The app's bundled dreams: the real หมวด ก content, generated from the import file
/// (see lib/data/dreams_k.dart). The former SAMPLE design data lives in test/fixtures only.
const dreams = dreamsK;

/// Looks a dream up by its stable [id]; null when no dream has that id.
Dream? dreamById(String id, [List<Dream> source = dreams]) {
  for (final d in source) {
    if (d.id == id) return d;
  }
  return null;
}

/// Data check for [source] (numbers and luck scores), identifying dreams by id.
/// Throws [StateError] on invalid data instead of silently fixing it.
///
/// `main()` calls this inside `assert(...)`, so in the app it only runs when
/// assertions are enabled (debug); release builds skip it.
bool debugValidateDreams([List<Dream> source = dreams]) {
  for (final d in source) {
    final problems = d.validate();
    if (problems.isNotEmpty) throw StateError('Dream "${d.id}" has invalid data: ${problems.join('; ')}');
  }
  return true;
}

const dreamCats = ['ทั้งหมด', 'หมวด ก'];

class MenuItem {
  final String key, title, desc;
  const MenuItem(this.key, this.title, this.desc);
}

class MenuDef {
  final String title, sub;
  final List<MenuItem> items;
  const MenuDef(this.title, this.sub, this.items);
}

const menus = <String, MenuDef>{
  'lucky': MenuDef('เลขเด็ด', 'สูตรเลขประจำงวด', [
    MenuItem('2', 'สรุปเลขนำโชค 0–9', 'ความฝันพร้อมรูป แยกตามเลข'),
    MenuItem('7', 'เลขล็อคตามวัน', 'บน · ล่าง ประจำวัน'),
    MenuItem('8', 'สูตรเลขเด่น', 'งวดวันที่ 1 และ 16'),
    MenuItem('9', 'สูตรเลขเสียงโชค', 'ดาราศาสตร์ ตัวเด่น ตัวกัน'),
    MenuItem('10', 'สูตรเลขวิ่งประจำวัน', 'เลขวิ่งเด่นวันนี้'),
  ]),
  'ritual': MenuDef('แก้ฝัน & ขอโชค', 'พิธีมงคลจากความฝัน', [
    MenuItem('3', 'เคล็ดลับแก้ฝันร้าย', 'ปัดเป่าลางร้าย'),
    MenuItem('4', 'การขอโชคจากความฝัน', 'ขอเลขก่อนนอน'),
    MenuItem('11', 'บทสวดมนต์ความฝัน', 'สวดก่อนนอน–หลังตื่น'),
  ]),
  'book': MenuDef('ตำราทำนาย', 'ภูมิปัญญาโบราณ', [
    MenuItem('6', 'ภาพแป๊ะกงชี้โชค', '1,000 ตัวเลข พร้อมรูป'),
    MenuItem('5', 'ตารางชื่อสัตว์', 'ทำนายฝันจากสัตว์ + เลข'),
    MenuItem('12', 'หลักทำนายฝันตัวเลข', 'ตามตำราโบราณ'),
    MenuItem('1', 'พยากรณ์โชคชะตาชีวิต', 'จากความฝัน + ตัวเลข'),
    MenuItem('13', 'ทำนายฝันหมวด ก', 'คำทำนายความฝันที่ขึ้นต้นด้วย ก'),
  ]),
};

enum FeatType { day, digit, steps, animals, pae, draw, table, letter }

class FeatDef {
  final String title, sub;
  final FeatType type;
  const FeatDef(this.title, this.sub, this.type);
}

const feats = <String, FeatDef>{
  '1': FeatDef('พยากรณ์โชคชะตาชีวิต', 'จากวันเกิด + ความฝัน', FeatType.day),
  '2': FeatDef('สรุปเลขนำโชค 0–9', 'ความฝันพร้อมรูป แยกตามเลข', FeatType.digit),
  '3': FeatDef('เคล็ดลับแก้ฝันร้าย', 'ปัดเป่าลางร้ายตามตำรา', FeatType.steps),
  '4': FeatDef('การขอโชคจากความฝัน', 'ขอเลขก่อนนอน', FeatType.steps),
  '5': FeatDef('ทำนายฝันจากสัตว์', 'ตารางชื่อสัตว์ + เลข + รูป', FeatType.animals),
  '6': FeatDef('ภาพแป๊ะกงชี้โชค', '1,000 ตัวเลข 000–999', FeatType.pae),
  '7': FeatDef('เลขล็อคตามวัน', 'บน · ล่าง ประจำวัน', FeatType.day),
  '8': FeatDef('สูตรเลขเด่นประจำงวด', 'งวดวันที่ 1 และ 16', FeatType.draw),
  '9': FeatDef('สูตรเลขเสียงโชค', 'ตามหลักดาราศาสตร์ไทย', FeatType.day),
  '10': FeatDef('สูตรเลขวิ่งประจำวัน', 'เลขวิ่งเด่นวันนี้', FeatType.day),
  '11': FeatDef('บทสวดมนต์ความฝัน', 'สวดก่อนนอน–หลังตื่น', FeatType.steps),
  '12': FeatDef('หลักทำนายฝันตัวเลข', 'ตามตำราโบราณ', FeatType.table),
  '13': FeatDef('ทำนายฝันหมวด ก', 'คำทำนายความฝันที่ขึ้นต้นด้วย ก', FeatType.letter),
};

/// Which bottom tab a feature belongs to.
String tabOf(String k) => const ['3', '4', '11'].contains(k)
    ? 'ritual'
    : const ['1', '5', '6', '12', '13'].contains(k)
        ? 'book'
        : 'lucky';

const dayShort = ['อา', 'จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส'];
const dayFull = ['อาทิตย์', 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์'];
const dayColor = ['แดง', 'เหลือง', 'ชมพู', 'เขียว', 'ส้ม', 'ฟ้า', 'ม่วง'];
const dayElement = ['ไฟ', 'น้ำ', 'ไฟ', 'ดิน', 'ลม', 'น้ำ', 'ดิน'];

const lore = [
  ['0', 'ไข่ · วงกลม', 'ความว่างเปล่า การเริ่มต้นใหม่ ฝันเห็นไข่ ลูกบอล'],
  ['1', 'เสา · พระ', 'ผู้นำ ความเป็นหนึ่ง ฝันเห็นพระ เสาธง'],
  ['2', 'หงส์ · คู่', 'ความรัก คู่ครอง ฝันเห็นนก สิ่งของเป็นคู่'],
  ['3', 'หู · ยันต์', 'ความขัดแย้ง การสื่อสาร ฝันเห็นตรี ภูเขา'],
  ['4', 'เก้าอี้', 'ความมั่นคง บ้าน ที่ดิน ฝันเห็นบ้าน โต๊ะ'],
  ['5', 'ตะขอ · งู', 'เสน่ห์ ความรัก ฝันเห็นงู สตรี'],
  ['6', 'ช้อน · ตะกร้อ', 'การเงิน ความสุข ฝันเห็นอาหาร'],
  ['7', 'ไม้เท้า', 'ผู้ใหญ่ โชคลาภ ฝันเห็นคนแก่ เทวดา'],
  ['8', 'ฟักทอง · น้ำเต้า', 'ทรัพย์สมบูรณ์ ฝันเห็นผลไม้ ปลา'],
  ['9', 'ช้าง · ยอดเขา', 'ความก้าวหน้า บารมี ฝันเห็นช้าง ทอง'],
];

// name, meaning, main digit, two-digit
const animals = [
  ['งู', 'เนื้อคู่', '5', '56'], ['ช้าง', 'บารมี', '9', '91'], ['เสือ', 'อำนาจ', '3', '37'],
  ['ปลา', 'ลาภลอย', '8', '84'], ['ไก่', 'ข่าวดี', '2', '23'], ['หมู', 'อุดมสมบูรณ์', '6', '69'],
  ['หมา', 'มิตรภาพ', '4', '46'], ['แมว', 'เสน่ห์', '2', '25'], ['วัว', 'ขยัน', '7', '76'],
  ['ม้า', 'เดินทาง', '3', '35'], ['เต่า', 'อายุยืน', '0', '02'], ['จระเข้', 'ศัตรู', '1', '17'],
  ['ลิง', 'เจ้าเล่ห์', '4', '49'], ['กบ', 'ฝนตกลาภมา', '8', '81'], ['นก', 'อิสระ', '2', '29'],
  ['หนู', 'ทรัพย์สะสม', '1', '12'],
];

const paeWords = [
  'ฤๅษี', 'ปลาช่อน', 'หอยทาก', 'ห่าน', 'ชาวนา', 'นางฟ้า', 'เรือสำเภา', 'ม้าขาว', 'ดอกบัว', 'พระจันทร์',
  'กระต่าย', 'ร่มกระดาษ', 'ชาวประมง', 'เจ้าพ่อ', 'ไก่ฟ้า', 'ขุนศึก', 'พัดจีน', 'ปู', 'เทพธิดา', 'ตะเกียง',
  'กิเลน', 'ขอทาน', 'นกยูง', 'ค้างคาว', 'เจดีย์', 'หญิงสาว', 'ชาม', 'มังกร', 'ปลาทอง', 'ชาวสวน',
  'งูเหลือม', 'ประตูวัง', 'กระจก', 'ไม้กวาด', 'เต่าทอง', 'ดาบ', 'สะพาน', 'กบ', 'ลูกท้อ', 'พ่อค้า',
];

const steps = <String, List<List<String>>>{
  '3': [
    ['ตั้งสติเมื่อตื่น', 'อย่าเพิ่งเล่าฝันร้ายให้ใครฟังก่อนล้างหน้า'],
    ['บ้วนน้ำลาย', 'บ้วนน้ำลายลงดิน 3 ครั้ง กล่าว "ร้ายกลายเป็นดี"'],
    ['กรวดน้ำ', 'กรวดน้ำอุทิศให้เจ้ากรรมนายเวร'],
    ['ทำบุญใส่บาตร', 'ภายใน 3 วัน ถวายข้าวสุกและน้ำสะอาด'],
  ],
  '4': [
    ['ชำระกาย', 'อาบน้ำ แต่งกายสะอาด สีมงคลประจำวัน'],
    ['จุดธูปบูชา', 'จุดธูป 9 ดอก บอกเจ้าที่และสิ่งศักดิ์สิทธิ์'],
    ['ตั้งจิตอธิษฐาน', 'ขอให้ฝันบอกเลขอย่างชัดเจน'],
    ['จดทันทีที่ตื่น', 'จดสิ่งที่เห็นในฝัน แล้วค้นในแอพ'],
  ],
  '11': [
    ['บทสวดก่อนนอน', 'อิติปิโส ภะคะวา อะระหัง สัมมาสัมพุทโธ... (9 จบ)'],
    ['บทแก้ฝันร้าย', 'ทุสสุปินัง ปาปะกัง ทุนนิมิตตัง อะมังคะลัง...'],
    ['บทขอโชคลาภ', 'นะโมพุทธายะ (108 จบ) แล้วอธิษฐาน'],
  ],
};

const prayers = <String, List<String>>{
  '3': ['คาถาแก้ฝันร้าย', 'ทุสสุปินัง ปาปะกัง ทุนนิมิตตัง\nพุทธานุภาเวนะ วินาสะเมนตุ'],
  '4': ['คาถาขอเลขก่อนนอน', 'นะโมพุทธายะ ขอฝันบอกเลขให้ชัดแจ้ง'],
  '11': ['สวดจบ อธิษฐาน', 'ขอให้ฝันดี มีโชค มีชัย'],
};

const thaiDigits = '๐๑๒๓๔๕๖๗๘๙';
