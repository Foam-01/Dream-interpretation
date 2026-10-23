// Lottery numbers are always kept as String to preserve leading zeros ("07").

class DreamCategory {
  final String id;
  final String name;
  final String icon;
  const DreamCategory(this.id, this.name, this.icon);
}

class Dream {
  final String id;
  final String keyword;
  final String categoryId;
  final String meaning;
  final List<String> numbers;
  final String? imageUrl;
  final String source;
  const Dream({
    required this.id,
    required this.keyword,
    required this.categoryId,
    required this.meaning,
    required this.numbers,
    this.imageUrl,
    this.source = 'ข้อมูลตัวอย่าง',
  });
}

class DigitMeaning {
  final String digit;
  final String meaning;
  final List<String> symbols;
  const DigitMeaning(this.digit, this.meaning, this.symbols);
}

class IndexEntry {
  final String number;
  final String name;
  final String? note;
  const IndexEntry(this.number, this.name, [this.note]);
}

class ContentItem {
  final String title;
  final String? subtitle;
  final String body;
  const ContentItem(this.title, this.body, {this.subtitle});
}

class LockedNumbers {
  final DateTime date;
  final List<String> twoDigits;
  final List<String> threeDigits;
  const LockedNumbers(this.date, this.twoDigits, this.threeDigits);
}

class FormulaResult {
  final String title;
  final List<String> numbers;
  final String explanation;
  const FormulaResult(this.title, this.numbers, this.explanation);
}
