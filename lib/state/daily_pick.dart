/// The daily selection turns over at 04:00 Thai time (UTC+7), not at midnight, whatever the device's time zone.
const dailyRolloverHour = 4;
const _thaiOffset = Duration(hours: 7);

/// The Thai calendar day a moment belongs to for the daily selection: before 04:00 it still counts as the previous day.
DateTime dailyPickDay(DateTime now) {
  final shifted = now.toUtc().add(_thaiOffset).subtract(const Duration(hours: dailyRolloverHour));
  return DateTime.utc(shifted.year, shifted.month, shifted.day);
}

/// The next 04:00 Thai time strictly after [now], as a UTC moment.
DateTime nextDailyRollover(DateTime now) {
  final day = dailyPickDay(now);
  return DateTime.utc(day.year, day.month, day.day + 1, dailyRolloverHour).subtract(_thaiOffset);
}

/// [count] items drawn at random from [items], the same draw on every device for the same pick day.
///
/// Device-independent: the pool is ordered by [idOf] first (so the source order does not matter), and the
/// generator is a fixed 32-bit algorithm instead of `dart:math` Random, whose sequence is not guaranteed
/// across platforms or SDK versions. Devices agree as long as they see the same catalogue.
List<T> dailyPick<T>(List<T> items, DateTime now, int count, String Function(T) idOf) {
  final day = dailyPickDay(now);
  final next = _mulberry32(day.year * 10000 + day.month * 100 + day.day);
  final pool = [...items]..sort((a, b) => idOf(a).compareTo(idOf(b)));
  // Partial Fisher–Yates: only the first [count] slots are needed.
  final n = count < pool.length ? count : pool.length;
  for (var i = 0; i < n; i++) {
    final j = i + next() % (pool.length - i);
    final t = pool[i];
    pool[i] = pool[j];
    pool[j] = t;
  }
  return pool.sublist(0, n);
}

/// Mulberry32: a small 32-bit generator; every step is masked so results match on any platform.
int Function() _mulberry32(int seed) {
  var s = seed & 0xFFFFFFFF;
  int mul(int a, int b) => (((a & 0xFFFF) * b) + ((((a >>> 16) * b) & 0xFFFF) << 16)) & 0xFFFFFFFF;
  return () {
    s = (s + 0x6D2B79F5) & 0xFFFFFFFF;
    var t = mul(s ^ (s >>> 15), s | 1);
    t = (t ^ (t + mul(t ^ (t >>> 7), t | 61))) & 0xFFFFFFFF;
    return (t ^ (t >>> 14)) & 0xFFFFFFFF;
  };
}
