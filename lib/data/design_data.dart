// Content ported from Claude Design `Dream App.dc.html`.
// Lottery numbers are kept as String to preserve leading zeros ("08").

import 'dreams_ang.dart';
import 'dreams_b.dart';
import 'dreams_ch.dart';
import 'dreams_chc.dart';
import 'dreams_chg.dart';
import 'dreams_d.dart';
import 'dreams_f.dart';
import 'dreams_fan.dart';
import 'dreams_hip.dart';
import 'dreams_k.dart';
import 'dreams_kh.dart';
import 'dreams_khr.dart';
import 'dreams_khw.dart';
import 'dreams_l.dart';
import 'dreams_m.dart';
import 'dreams_n.dart';
import 'dreams_ng.dart';
import 'dreams_p.dart';
import 'dreams_phan.dart';
import 'dreams_phueng.dart';
import 'dreams_r.dart';
import 'dreams_s.dart';
import 'dreams_sala.dart';
import 'dreams_samphao.dart';
import 'dreams_suea.dart';
import 'dreams_t.dart';
import 'dreams_thahan.dart';
import 'dreams_thong.dart';
import 'dreams_thung.dart';
import 'dreams_w.dart';
import 'dreams_y.dart';
import 'dreams_yak.dart';

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
  /// (or 3) ASCII digits 0-9: rejects empty strings, spaces, non-digit
  /// characters (incl. Thai digits) and wrong lengths. Never fixes data.
  /// [LuckyNumbers.none] ("ไม่ควรเสี่ยง") is valid. Otherwise two-digit numbers are
  /// required; the three-digit list may be empty (some sources give only two-digit numbers).
  List<String> validate() => isNone ? const [] : [
        if (_twoDigit.isEmpty) 'twoDigit is empty',
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

/// The app's bundled dreams: the real letter-category content (หมวด ก–อ), generated from the import
/// files (see lib/data/dreams_*.dart). The former SAMPLE design data lives in test/fixtures only.
const dreams = [...dreamsK, ...dreamsKh, ...dreamsKhw, ...dreamsKhr, ...dreamsNg, ...dreamsCh, ...dreamsChg, ...dreamsChc, ...dreamsS, ...dreamsY, ...dreamsD, ...dreamsT, ...dreamsThung, ...dreamsThahan, ...dreamsThong, ...dreamsN, ...dreamsB, ...dreamsP, ...dreamsPhueng, ...dreamsF, ...dreamsPhan, ...dreamsFan, ...dreamsSamphao, ...dreamsM, ...dreamsYak, ...dreamsR, ...dreamsL, ...dreamsW, ...dreamsSala, ...dreamsSuea, ...dreamsHip, ...dreamsAng];

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

const dreamCats = ['ทั้งหมด', 'หมวด ก', 'หมวด ข', 'หมวด ค', 'หมวด ฆ', 'หมวด ง', 'หมวด จ', 'หมวด ฉ', 'หมวด ช', 'หมวด ซ', 'หมวด ญ', 'หมวด ด', 'หมวด ต', 'หมวด ถ', 'หมวด ท', 'หมวด ธ', 'หมวด น', 'หมวด บ', 'หมวด ป', 'หมวด ผ', 'หมวด ฝ', 'หมวด พ', 'หมวด ฟ', 'หมวด ภ', 'หมวด ม', 'หมวด ย', 'หมวด ร', 'หมวด ล', 'หมวด ว', 'หมวด ศ', 'หมวด ส', 'หมวด ห', 'หมวด อ'];

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
    MenuItem('9', 'สูตรเลขเสียงโชค', 'ตัวเด่น · ตัวกัน ตามวันออกสลาก'),
    MenuItem('10', 'สูตรเลขวิ่งประจำวัน', 'เลขวิ่งตามวันออกสลาก'),
  ]),
  'ritual': MenuDef('แก้ฝัน & ขอโชค', 'พิธีมงคลจากความฝัน', [
    MenuItem('3', 'เคล็ดลับแก้ฝันร้าย', 'ปัดเป่าลางร้าย'),
    MenuItem('4', 'การขอโชคจากความฝัน', 'ไหว้ขอโชค–ลาภที่ประตูบ้าน'),
    MenuItem('11', 'บทสวดมนต์ความฝัน', 'สวดเมื่อฝัน ร้ายกลายเป็นดี'),
  ]),
  'book': MenuDef('ตำราทำนาย', 'ภูมิปัญญาโบราณ', [
    MenuItem('6', 'ภาพแป๊ะกงชี้โชค', '1,000 ตัวเลข พร้อมรูป'),
    MenuItem('5', 'ตารางชื่อสัตว์', 'ทำนายฝันจากสัตว์ + เลข'),
    MenuItem('12', 'หลักทำนายฝันตัวเลข', 'ตามตำราโบราณ'),
    MenuItem('1', 'พยากรณ์โชคชะตาชีวิต', 'ค้นความฝัน + ตัวเลข + รูป'),
    MenuItem('13', 'ทำนายฝันหมวด ก', 'คำทำนายความฝันที่ขึ้นต้นด้วย ก'),
    MenuItem('14', 'ทำนายฝันหมวด ข', 'คำทำนายความฝันที่ขึ้นต้นด้วย ข'),
    MenuItem('15', 'ทำนายฝันหมวด ค', 'คำทำนายความฝันที่ขึ้นต้นด้วย ค'),
    MenuItem('16', 'ทำนายฝันหมวด ฆ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฆ'),
    MenuItem('17', 'ทำนายฝันหมวด ง', 'คำทำนายความฝันที่ขึ้นต้นด้วย ง'),
    MenuItem('18', 'ทำนายฝันหมวด จ', 'คำทำนายความฝันที่ขึ้นต้นด้วย จ'),
    MenuItem('19', 'ทำนายฝันหมวด ฉ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฉ'),
    MenuItem('20', 'ทำนายฝันหมวด ช', 'คำทำนายความฝันที่ขึ้นต้นด้วย ช'),
    MenuItem('21', 'ทำนายฝันหมวด ซ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ซ'),
    MenuItem('22', 'ทำนายฝันหมวด ญ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ญ'),
    MenuItem('23', 'ทำนายฝันหมวด ด', 'คำทำนายความฝันที่ขึ้นต้นด้วย ด'),
    MenuItem('24', 'ทำนายฝันหมวด ต', 'คำทำนายความฝันที่ขึ้นต้นด้วย ต'),
    MenuItem('25', 'ทำนายฝันหมวด ถ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ถ'),
    MenuItem('26', 'ทำนายฝันหมวด ท', 'คำทำนายความฝันที่ขึ้นต้นด้วย ท'),
    MenuItem('27', 'ทำนายฝันหมวด ธ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ธ'),
    MenuItem('28', 'ทำนายฝันหมวด น', 'คำทำนายความฝันที่ขึ้นต้นด้วย น'),
    MenuItem('29', 'ทำนายฝันหมวด บ', 'คำทำนายความฝันที่ขึ้นต้นด้วย บ'),
    MenuItem('30', 'ทำนายฝันหมวด ป', 'คำทำนายความฝันที่ขึ้นต้นด้วย ป'),
    MenuItem('31', 'ทำนายฝันหมวด ผ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ผ'),
    MenuItem('32', 'ทำนายฝันหมวด ฝ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฝ'),
    MenuItem('33', 'ทำนายฝันหมวด พ', 'คำทำนายความฝันที่ขึ้นต้นด้วย พ'),
    MenuItem('34', 'ทำนายฝันหมวด ฟ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฟ'),
    MenuItem('35', 'ทำนายฝันหมวด ภ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ภ'),
    MenuItem('36', 'ทำนายฝันหมวด ม', 'คำทำนายความฝันที่ขึ้นต้นด้วย ม'),
    MenuItem('37', 'ทำนายฝันหมวด ย', 'คำทำนายความฝันที่ขึ้นต้นด้วย ย'),
    MenuItem('38', 'ทำนายฝันหมวด ร', 'คำทำนายความฝันที่ขึ้นต้นด้วย ร'),
    MenuItem('39', 'ทำนายฝันหมวด ล', 'คำทำนายความฝันที่ขึ้นต้นด้วย ล'),
    MenuItem('40', 'ทำนายฝันหมวด ว', 'คำทำนายความฝันที่ขึ้นต้นด้วย ว'),
    MenuItem('41', 'ทำนายฝันหมวด ศ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ศ'),
    MenuItem('42', 'ทำนายฝันหมวด ส', 'คำทำนายความฝันที่ขึ้นต้นด้วย ส'),
    MenuItem('43', 'ทำนายฝันหมวด ห', 'คำทำนายความฝันที่ขึ้นต้นด้วย ห'),
    MenuItem('44', 'ทำนายฝันหมวด อ', 'คำทำนายความฝันที่ขึ้นต้นด้วย อ'),
  ]),
};

enum FeatType { day, digit, steps, remedies, chant, running, sound, animals, pae, draw, table, letter }

class FeatDef {
  final String title, sub;
  final FeatType type;
  const FeatDef(this.title, this.sub, this.type);
}

const feats = <String, FeatDef>{
  '2': FeatDef('สรุปเลขนำโชค 0–9', 'ความฝันพร้อมรูป แยกตามเลข', FeatType.digit),
  '3': FeatDef('เคล็ดลับแก้ฝันร้าย', 'ปัดเป่าลางร้ายตามตำรา', FeatType.remedies),
  '4': FeatDef('การขอโชคจากความฝัน', 'ไหว้ขอโชค–ลาภที่ประตูบ้าน', FeatType.steps),
  '5': FeatDef('ทำนายฝันจากสัตว์', 'ตารางชื่อสัตว์ + เลข + รูป', FeatType.animals),
  '6': FeatDef('ภาพแป๊ะกงชี้โชค', '1,000 ตัวเลข 000–999', FeatType.pae),
  '7': FeatDef('เลขล็อคตามวัน', 'บน · ล่าง ประจำวัน', FeatType.day),
  '8': FeatDef('สูตรเลขเด่นประจำวัน', 'งวดวันที่ 1 และ 16', FeatType.draw),
  '9': FeatDef('สูตรเลขเสียงโชค', 'ตัวเด่น · ตัวกัน ตามวันออกสลาก', FeatType.sound),
  '10': FeatDef('สูตรเลขวิ่งประจำวัน', 'เลขวิ่งตามวันออกสลาก', FeatType.running),
  '11': FeatDef('บทสวดมนต์ความฝัน', 'สวดเมื่อฝัน ร้ายกลายเป็นดี', FeatType.chant),
  '12': FeatDef('หลักทำนายฝันตัวเลข', 'ตามตำราโบราณ', FeatType.table),
  '13': FeatDef('ทำนายฝันหมวด ก', 'คำทำนายความฝันที่ขึ้นต้นด้วย ก', FeatType.letter),
  '14': FeatDef('ทำนายฝันหมวด ข', 'คำทำนายความฝันที่ขึ้นต้นด้วย ข', FeatType.letter),
  '15': FeatDef('ทำนายฝันหมวด ค', 'คำทำนายความฝันที่ขึ้นต้นด้วย ค', FeatType.letter),
  '16': FeatDef('ทำนายฝันหมวด ฆ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฆ', FeatType.letter),
  '17': FeatDef('ทำนายฝันหมวด ง', 'คำทำนายความฝันที่ขึ้นต้นด้วย ง', FeatType.letter),
  '18': FeatDef('ทำนายฝันหมวด จ', 'คำทำนายความฝันที่ขึ้นต้นด้วย จ', FeatType.letter),
  '19': FeatDef('ทำนายฝันหมวด ฉ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฉ', FeatType.letter),
  '20': FeatDef('ทำนายฝันหมวด ช', 'คำทำนายความฝันที่ขึ้นต้นด้วย ช', FeatType.letter),
  '21': FeatDef('ทำนายฝันหมวด ซ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ซ', FeatType.letter),
  '22': FeatDef('ทำนายฝันหมวด ญ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ญ', FeatType.letter),
  '23': FeatDef('ทำนายฝันหมวด ด', 'คำทำนายความฝันที่ขึ้นต้นด้วย ด', FeatType.letter),
  '24': FeatDef('ทำนายฝันหมวด ต', 'คำทำนายความฝันที่ขึ้นต้นด้วย ต', FeatType.letter),
  '25': FeatDef('ทำนายฝันหมวด ถ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ถ', FeatType.letter),
  '26': FeatDef('ทำนายฝันหมวด ท', 'คำทำนายความฝันที่ขึ้นต้นด้วย ท', FeatType.letter),
  '27': FeatDef('ทำนายฝันหมวด ธ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ธ', FeatType.letter),
  '28': FeatDef('ทำนายฝันหมวด น', 'คำทำนายความฝันที่ขึ้นต้นด้วย น', FeatType.letter),
  '29': FeatDef('ทำนายฝันหมวด บ', 'คำทำนายความฝันที่ขึ้นต้นด้วย บ', FeatType.letter),
  '30': FeatDef('ทำนายฝันหมวด ป', 'คำทำนายความฝันที่ขึ้นต้นด้วย ป', FeatType.letter),
  '31': FeatDef('ทำนายฝันหมวด ผ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ผ', FeatType.letter),
  '32': FeatDef('ทำนายฝันหมวด ฝ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฝ', FeatType.letter),
  '33': FeatDef('ทำนายฝันหมวด พ', 'คำทำนายความฝันที่ขึ้นต้นด้วย พ', FeatType.letter),
  '34': FeatDef('ทำนายฝันหมวด ฟ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ฟ', FeatType.letter),
  '35': FeatDef('ทำนายฝันหมวด ภ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ภ', FeatType.letter),
  '36': FeatDef('ทำนายฝันหมวด ม', 'คำทำนายความฝันที่ขึ้นต้นด้วย ม', FeatType.letter),
  '37': FeatDef('ทำนายฝันหมวด ย', 'คำทำนายความฝันที่ขึ้นต้นด้วย ย', FeatType.letter),
  '38': FeatDef('ทำนายฝันหมวด ร', 'คำทำนายความฝันที่ขึ้นต้นด้วย ร', FeatType.letter),
  '39': FeatDef('ทำนายฝันหมวด ล', 'คำทำนายความฝันที่ขึ้นต้นด้วย ล', FeatType.letter),
  '40': FeatDef('ทำนายฝันหมวด ว', 'คำทำนายความฝันที่ขึ้นต้นด้วย ว', FeatType.letter),
  '41': FeatDef('ทำนายฝันหมวด ศ', 'คำทำนายความฝันที่ขึ้นต้นด้วย ศ', FeatType.letter),
  '42': FeatDef('ทำนายฝันหมวด ส', 'คำทำนายความฝันที่ขึ้นต้นด้วย ส', FeatType.letter),
  '43': FeatDef('ทำนายฝันหมวด ห', 'คำทำนายความฝันที่ขึ้นต้นด้วย ห', FeatType.letter),
  '44': FeatDef('ทำนายฝันหมวด อ', 'คำทำนายความฝันที่ขึ้นต้นด้วย อ', FeatType.letter),
};

/// Which bottom tab a feature belongs to.
String tabOf(String k) => const ['3', '4', '11'].contains(k)
    ? 'ritual'
    : const ['5', '6', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44'].contains(k)
        ? 'book'
        : 'lucky';

const dayShort = ['อา', 'จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส'];
const dayFull = ['อาทิตย์', 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์'];
const dayColor = ['แดง', 'เหลือง', 'ชมพู', 'เขียว', 'ส้ม', 'ฟ้า', 'ม่วง'];
const dayElement = ['ไฟ', 'น้ำ', 'ไฟ', 'ดิน', 'ลม', 'น้ำ', 'ดิน'];

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
  // Feature 4: the owner's book page "การขอโชคจากความฝัน" (backend/content/incoming/feature-04-luck-ritual/source.md),
  // split at its sentence breaks; each title is words from that step.
  '4': [
    ['เตรียมเครื่องสักการะ', 'เตรียมเครื่องสักการะ ดอกไม้ ธูป (5 ดอก) เทียน พร้อมเครื่องเซ่นไหว้บูชา, ผลไม้ตามควร ที่ประตูบ้าน'],
    ['จุดธูปเทียนบูชา', 'หันหน้าไปทางทิศตะวันออกเฉียงเหนือ จุดธูปเทียนบูชา'],
    ['ภาวนาขอโชค–ลาภ', 'สำรวมจิตให้เป็นสมาธิ อาราธนาพระคุณของท่านเป็นที่พึ่งจากแป๊ะกง เจ้าที่เจ้าทาง และสิ่งศักดิ์สิทธิ์ทั้งหลาย ภาวนาขอโชค–ลาภ'],
    ['กราบ 3 ครั้ง', 'ยกธูปขึ้นจบศีรษะแล้วกราบ 3 ครั้ง'],
    ['ถวายเครื่องเซ่นไหว้บูชา', 'หลังเสร็จพิธีไหว้แล้ว ถวายเครื่องเซ่นไหว้บูชา ยกขึ้นจบศีรษะ'],
    ['ทำทักษิณาวรรต 3 รอบ', 'ทำทักษิณาวรรต (เวียนเป็นวงกลม เลี้ยวทางขวาตามเข็มนาฬิกา) 3 รอบ แล้วกราบอีกครั้ง'],
  ],
};

const prayers = <String, List<String>>{
  '4': ['', 'ท่านจักให้ลาภผล ความสำเร็จตามความมุ่งหวังเป็นประสิทธิ์'],
};

const thaiDigits = '๐๑๒๓๔๕๖๗๘๙';
