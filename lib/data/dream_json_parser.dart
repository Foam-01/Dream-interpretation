// Strict JSON → domain conversion for the backend API responses
// (backend/src/dreams/dto/dream-response.dto.ts). Unknown fields are ignored so
// the API can add fields; missing or malformed required fields are rejected —
// never defaulted or converted (a number where a string is required is an error,
// so "08" can never silently become 8).
import 'design_data.dart';
import 'dream_repository.dart';

/// The response does not match the API contract. [path] names the bad field.
class DreamJsonException implements Exception {
  final String path, problem;
  const DreamJsonException(this.path, this.problem);

  @override
  String toString() => 'DreamJsonException: $path $problem';
}

final _slug = RegExp(r'^[a-z0-9-]{1,64}$');
final _digit = RegExp(r'^\d$');

/// `{"data":[{"id","name"}]}` from `GET /dream-categories`.
List<DreamCategory> parseCategoryList(Object? json) {
  final data = _list(_map(json, r'$')['data'], 'data');
  return [for (var i = 0; i < data.length; i++) _category(data[i], 'data[$i]')];
}

/// `{"data":[summary…],"meta":{page,limit,total,totalPages}}` from `GET /dreams`.
DreamPage parseDreamPage(Object? json) {
  final root = _map(json, r'$');
  final data = _list(root['data'], 'data');
  final meta = _map(root['meta'], 'meta');
  final page = _int(meta['page'], 'meta.page', min: 1);
  final limit = _int(meta['limit'], 'meta.limit', min: 1);
  final total = _int(meta['total'], 'meta.total', min: 0);
  final totalPages = _int(meta['totalPages'], 'meta.totalPages', min: 0);
  final result = DreamPage(
    items: [for (var i = 0; i < data.length; i++) _summary(_map(data[i], 'data[$i]'), 'data[$i]')],
    page: page,
    limit: limit,
    total: total,
  );
  if (result.totalPages != totalPages) throw DreamJsonException('meta.totalPages', 'does not match total/limit');
  if (result.items.length > limit) throw DreamJsonException('data', 'has more items than meta.limit');
  return result;
}

/// `{"data":{detail}}` from `GET /dreams/:id`.
Dream parseDreamDetail(Object? json) {
  final m = _map(_map(json, r'$')['data'], 'data');
  final s = _summary(m, 'data');
  final digits = _strings(m['digits'], 'data.digits');
  for (var i = 0; i < digits.length; i++) {
    if (!_digit.hasMatch(digits[i])) throw DreamJsonException('data.digits[$i]', 'is not a single digit');
  }
  if (digits.isEmpty) throw const DreamJsonException('data.digits', 'is empty');
  final luck = _map(m['luckForecast'], 'data.luckForecast');
  final money = _int(luck['money'], 'data.luckForecast.money');
  final love = _int(luck['love'], 'data.luckForecast.love');
  final health = _int(luck['health'], 'data.luckForecast.health');
  // Check before constructing: LuckForecast's asserts would throw in debug only.
  final problems = LuckForecast.check(money: money, love: love, health: health);
  if (problems.isNotEmpty) throw DreamJsonException('data.luckForecast', problems.join('; '));
  final dream = Dream(
    s.id,
    s.name,
    s.cat,
    s.numbers,
    List.unmodifiable(digits),
    s.short,
    _string(m['meaning'], 'data.meaning'),
    LuckForecast(money: money, love: love, health: health),
    s.good,
    _string(m['advice'], 'data.advice'),
  );
  final invalid = dream.validate();
  if (invalid.isNotEmpty) throw DreamJsonException('data', invalid.join('; '));
  return dream;
}

/// `{"error":{"code","message"}}` → code, or null when the body is not an envelope.
String? parseErrorCode(Object? json) {
  if (json is! Map<String, Object?>) return null;
  final error = json['error'];
  if (error is! Map<String, Object?>) return null;
  final code = error['code'];
  return code is String && code.isNotEmpty ? code : null;
}

DreamSummary _summary(Map<String, Object?> m, String path) {
  final id = _string(m['id'], '$path.id');
  if (!_slug.hasMatch(id)) throw DreamJsonException('$path.id', 'is not a slug');
  final numbersJson = _map(m['numbers'], '$path.numbers');
  final numbers = LuckyNumbers.copy(
    twoDigit: _strings(numbersJson['twoDigit'], '$path.numbers.twoDigit'),
    threeDigit: _strings(numbersJson['threeDigit'], '$path.numbers.threeDigit'),
  );
  final problems = numbers.validate();
  if (problems.isNotEmpty) throw DreamJsonException('$path.numbers', problems.join('; '));
  return DreamSummary(
    id: id,
    name: _string(m['name'], '$path.name'),
    category: _category(m['category'], '$path.category'),
    short: _string(m['short'], '$path.short'),
    good: _bool(m['isGoodOmen'], '$path.isGoodOmen'),
    numbers: numbers,
    contentStatus: switch (m['contentStatus']) {
      'SAMPLE' => ContentStatus.sample,
      'VERIFIED' => ContentStatus.verified,
      _ => throw DreamJsonException('$path.contentStatus', 'is not SAMPLE or VERIFIED'),
    },
  );
}

DreamCategory _category(Object? json, String path) {
  final m = _map(json, path);
  final id = _string(m['id'], '$path.id');
  if (!_slug.hasMatch(id)) throw DreamJsonException('$path.id', 'is not a slug');
  return DreamCategory(id, _string(m['name'], '$path.name'));
}

Map<String, Object?> _map(Object? v, String path) =>
    v is Map<String, Object?> ? v : throw DreamJsonException(path, 'is not an object');

List<Object?> _list(Object? v, String path) =>
    v is List<Object?> ? v : throw DreamJsonException(path, 'is not an array');

/// Non-empty string; numbers are rejected, not converted.
String _string(Object? v, String path) {
  if (v is! String) throw DreamJsonException(path, 'is not a string');
  if (v.trim().isEmpty) throw DreamJsonException(path, 'is empty');
  return v;
}

List<String> _strings(Object? v, String path) {
  final l = _list(v, path);
  return [
    for (var i = 0; i < l.length; i++)
      l[i] is String ? l[i] as String : throw DreamJsonException('$path[$i]', 'is not a string'),
  ];
}

bool _bool(Object? v, String path) => v is bool ? v : throw DreamJsonException(path, 'is not a boolean');

int _int(Object? v, String path, {int? min}) {
  if (v is! int) throw DreamJsonException(path, 'is not an integer');
  if (min != null && v < min) throw DreamJsonException(path, 'is less than $min');
  return v;
}
