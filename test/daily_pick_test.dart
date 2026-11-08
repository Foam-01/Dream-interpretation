import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/state/daily_pick.dart';

// Thai wall-clock time (UTC+7) as a UTC moment, so tests do not depend on the machine's time zone.
DateTime th(int y, int m, int d, [int h = 0, int min = 0]) =>
    DateTime.utc(y, m, d, h, min).subtract(const Duration(hours: 7));

void main() {
  final items = List.generate(114, (i) => 'd${i.toString().padLeft(3, '0')}');
  String id(String s) => s;

  test('the pick day turns over at 04:00 Thai time, not midnight', () {
    expect(dailyPickDay(th(2026, 10, 31, 3, 59)), DateTime.utc(2026, 10, 30));
    expect(dailyPickDay(th(2026, 10, 31, 4)), DateTime.utc(2026, 10, 31));
  });

  test('the device time zone does not move the rollover', () {
    final bangkok = th(2026, 10, 31, 4);
    expect(dailyPickDay(bangkok.toLocal()), dailyPickDay(bangkok));
  });

  test('next rollover is the coming 04:00 Thai time', () {
    expect(nextDailyRollover(th(2026, 10, 30, 12)), th(2026, 10, 31, 4));
    expect(nextDailyRollover(th(2026, 10, 31, 2)), th(2026, 10, 31, 4));
    expect(nextDailyRollover(th(2026, 10, 31, 4)), th(2026, 11, 1, 4));
  });

  test('same pick day gives the same ten distinct items', () {
    final a = dailyPick(items, th(2026, 10, 30, 9), 10, id);
    final b = dailyPick(items, th(2026, 10, 31, 3, 59), 10, id);
    expect(a, b);
    expect(a.toSet().length, 10);
  });

  test('a new pick day gives a different draw', () {
    expect(dailyPick(items, th(2026, 10, 31, 3, 59), 10, id), isNot(dailyPick(items, th(2026, 10, 31, 4), 10, id)));
  });

  test('source order does not change the draw', () {
    final day = th(2026, 10, 30, 9);
    expect(dailyPick(items.reversed.toList(), day, 10, id), dailyPick(items, day, 10, id));
  });

  // The backend pins the same draw (backend/src/dreams/daily-pick.spec.ts): API and offline mode agree.
  test('the draw is pinned, so any platform or SDK change that alters it fails here', () {
    expect(dailyPick(items, th(2026, 10, 30, 9), 3, id), _pinned);
  });

  test('offline repository: ten distinct pictured dreams, the same all day, answered at once', () async {
    const repo = SampleDreamRepository();
    final morning = await repo.daily(th(2026, 11, 8, 9));
    final night = await repo.daily(th(2026, 11, 9, 3, 59));
    expect(morning, hasLength(10));
    expect(morning.map((d) => d.id).toSet(), hasLength(10));
    expect(morning.every((d) => dreamImageFor(d.id, d.image) != null), isTrue);
    expect(night.map((d) => d.id), morning.map((d) => d.id));
    expect(repo.daily(th(2026, 11, 8, 9)), isA<SynchronousFuture<List<DreamSummary>>>());
  });

  test('fewer items than requested returns them all', () {
    expect(dailyPick(['a', 'b', 'c'], th(2026, 10, 30), 10, id).toSet(), {'a', 'b', 'c'});
  });
}

const _pinned = ['d001', 'd016', 'd062'];
