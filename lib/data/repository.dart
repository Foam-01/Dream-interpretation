import '../models.dart';
import 'sample_data.dart' as sample;

/// Data access boundary. Currently backed by in-memory sample data with a
/// short artificial delay so loading states are visible; swap for an HTTP
/// client against the NestJS API later without touching the UI.
class DreamRepository {
  DreamRepository._();
  static final instance = DreamRepository._();

  Future<T> _delay<T>(T value) =>
      Future.delayed(const Duration(milliseconds: 350), () => value);

  static String normalize(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');

  Future<List<DreamCategory>> categories() => _delay(sample.categories);

  Future<List<Dream>> search(String query) {
    final q = normalize(query);
    if (q.isEmpty) return _delay(const <Dream>[]);
    return _delay(sample.dreams
        .where((d) => normalize(d.keyword).contains(q) || normalize(d.meaning).contains(q) || d.numbers.contains(q))
        .toList());
  }

  Future<List<Dream>> byCategory(String categoryId) =>
      _delay(sample.dreams.where((d) => d.categoryId == categoryId).toList());

  Future<List<Dream>> popular() => _delay(sample.dreams.take(6).toList());

  Future<List<DigitMeaning>> digitMeanings() => _delay(sample.digitMeanings);
  Future<List<IndexEntry>> animalIndex() => _delay(sample.animalIndex);
  Future<List<IndexEntry>> paeKongIndex() => _delay(sample.paeKongIndex);
  Future<List<ContentItem>> badDreamRemedies() => _delay(sample.badDreamRemedies);
  Future<List<ContentItem>> luckSeeking() => _delay(sample.luckSeeking);
  Future<List<ContentItem>> dreamPrayers() => _delay(sample.dreamPrayers);
  Future<List<ContentItem>> traditionalRules() => _delay(sample.traditionalRules);

  /// Lucky numbers aggregated from popular dreams.
  Future<List<String>> luckyNumbers() async {
    final all = (await popular()).expand((d) => d.numbers).where((n) => n.length == 2).toSet().toList();
    return all;
  }

  /// Returns null when no locked numbers were published for [date].
  Future<LockedNumbers?> lockedNumbers(DateTime date) {
    if (date.weekday == DateTime.sunday) return _delay(null);
    final seed = date.year * 10000 + date.month * 100 + date.day;
    String two(int i) => ((seed * (i + 7)) % 100).toString().padLeft(2, '0');
    String three(int i) => ((seed * (i + 13)) % 1000).toString().padLeft(3, '0');
    return _delay(LockedNumbers(date, [two(1), two(2), two(3)], [three(1), three(2)]));
  }

  /// Returns null when there is no history for that draw.
  Future<List<String>?> runningNumbers(DateTime drawDate) {
    final key = '${drawDate.year}-${drawDate.month.toString().padLeft(2, '0')}-${drawDate.day.toString().padLeft(2, '0')}';
    return _delay(sample.runningNumberHistory[key]);
  }

  /// Sample "draw date" formula: derived from day + month of the draw.
  FormulaResult drawDateFormula(DateTime d) {
    final a = (d.day + d.month) % 10;
    final b = (d.day * d.month) % 10;
    final c = (d.year % 100) % 10;
    return FormulaResult(
      'สูตรวันหวยออก',
      ['$a$b', '$b$a', '$a$c', '$a$b$c'],
      'นำวันที่ (${d.day}) + เดือน (${d.month}) = หลักหน่วย $a\n'
          'วันที่ × เดือน = หลักหน่วย $b\nหลักหน่วยของปี = $c',
    );
  }

  /// Sample astronomical formula: Thai weekday numerology (Sunday = 1 ... Saturday = 7).
  FormulaResult astronomicalFormula(DateTime d) {
    final weekdayNum = d.weekday % 7 + 1;
    final lunar = d.day % 15 == 0 ? 15 : d.day % 15;
    final x = (weekdayNum + lunar) % 10;
    return FormulaResult(
      'สูตรเลขดาราศาสตร์',
      ['$weekdayNum$x', '$x$weekdayNum', '${(x + 5) % 10}$weekdayNum'],
      'เลขประจำวัน ${_thaiWeekday(d)} = $weekdayNum\nค่าวันจันทรคติโดยประมาณ = $lunar\n'
          'ผลรวมหลักหน่วย = $x',
    );
  }

  static String _thaiWeekday(DateTime d) =>
      const ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์', 'อาทิตย์'][d.weekday - 1];
}

/// Thai lottery draws on the 1st and 16th of each month.
DateTime nextDrawDate(DateTime from) {
  final d = DateTime(from.year, from.month, from.day);
  if (d.day <= 1) return DateTime(d.year, d.month, 1);
  if (d.day <= 16) return DateTime(d.year, d.month, 16);
  return DateTime(d.year, d.month + 1, 1);
}

DateTime previousDrawDate(DateTime draw) =>
    draw.day == 16 ? DateTime(draw.year, draw.month, 1) : DateTime(draw.year, draw.month - 1, 16);

String thaiDate(DateTime d) {
  const months = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
  return '${d.day} ${months[d.month - 1]} ${d.year + 543}';
}
