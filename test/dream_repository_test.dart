// I1: the data access boundary. SampleDreamRepository must follow the backend
// API contract (backend/test/dreams.e2e-spec.ts) and give the same results as
// the screens' current inline filtering, so switching sources later changes nothing.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/screens/home_screen.dart';

const repo = SampleDreamRepository();

List<String> ids(DreamPage p) => [for (final d in p.items) d.id];

Matcher invalid(String detail) => throwsA(
  isA<DreamRepositoryException>()
      .having((e) => e.kind, 'kind', DreamRepositoryErrorKind.invalidRequest)
      .having((e) => e.message, 'message', detail),
);

void main() {
  group('categories', () {
    test('match dreamCats (without "ทั้งหมด") in app order', () async {
      final cats = await repo.categories();
      expect(cats.map((c) => c.name), dreamCats.skip(1));
      expect(cats.map((c) => c.id), ['animal', 'body', 'nature', 'person', 'object']);
    });

    test('every dream belongs to a known category', () {
      final names = sampleCategories.map((c) => c.name).toSet();
      for (final d in dreams) {
        expect(names, contains(d.cat), reason: d.id);
      }
    });

    test('ids and names match the backend seed', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final seeded = [
        for (final m in RegExp(r"\{ id: '([a-z-]+)', name: '([^']+)', sortOrder: \d+ \}").allMatches(ts))
          DreamCategory(m[1]!, m[2]!),
      ];
      expect(seeded, sampleCategories);
    });

    test('returned list cannot be modified', () async {
      final cats = await repo.categories();
      expect(() => cats.add(const DreamCategory('x', 'x')), throwsUnsupportedError);
    });
  });

  group('list', () {
    test('defaults: all 10 in app order, page 1 of 1', () async {
      final p = await repo.list();
      expect(ids(p), dreams.map((d) => d.id));
      expect((p.page, p.limit, p.total, p.totalPages), (1, 20, 10, 1));
    });

    test('paginates with stable order and empty pages past the end', () async {
      expect(ids(await repo.list(limit: 4)), ['snake', 'elephant', 'tooth-falling-out', 'flood']);
      final p3 = await repo.list(limit: 4, page: 3);
      expect(ids(p3), ['gold', 'tiger']);
      expect((p3.total, p3.totalPages), (10, 3));
      final p99 = await repo.list(page: 99);
      expect(p99.items, isEmpty);
      expect(p99.total, 10);
    });

    test('searches name or short summary, trimmed, like the app', () async {
      expect(ids(await repo.list(q: 'งู')), ['snake']);
      expect(ids(await repo.list(q: '  ลาภก้อนเล็ก ')), ['fish']);
      expect(ids(await repo.list(q: '   ')), hasLength(10));
    });

    test('does not search meaning or numbers', () async {
      expect((await repo.list(q: '08')).items, isEmpty);
      expect((await repo.list(q: 'ตำราโบราณ')).items, isEmpty);
    });

    test('filters by category id and combines with search', () async {
      final animals = await repo.list(categoryId: 'animal');
      expect(animals.total, 4);
      expect(animals.items.every((d) => d.cat == 'สัตว์'), isTrue);
      expect((await repo.list(categoryId: 'animal', q: 'ไฟไหม้')).items, isEmpty);
    });

    test('no results gives zero pages', () async {
      final p = await repo.list(q: 'ไม่มีความฝันนี้');
      expect((p.total, p.totalPages), (0, 0));
    });

    test('gives the same results as the search screen filter for every category and query', () async {
      final catId = {for (final c in sampleCategories) c.name: c.id};
      for (final cat in dreamCats) {
        for (final raw in ['', 'งู', ' ฝัน ', 'จะ', 'โชค', 'xyz']) {
          final q = raw.trim();
          final expected = [
            for (final d in dreams)
              if ((cat == 'ทั้งหมด' || d.cat == cat) && (q.isEmpty || d.name.contains(q) || d.short.contains(q))) d.id,
          ];
          final p = await repo.list(q: raw, categoryId: cat == 'ทั้งหมด' ? null : catId[cat], limit: 100);
          expect(ids(p), expected, reason: 'cat=$cat q="$raw"');
        }
      }
    });

    test('rejects requests the API would reject (400)', () {
      expect(repo.list(limit: 0), invalid('limit must be between 1 and 100'));
      expect(repo.list(limit: 101), invalid('limit must be between 1 and 100'));
      expect(repo.list(page: 0), invalid('page must not be less than 1'));
      expect(repo.list(categoryId: 'Animal'), invalid('category must be a category id (lowercase slug)'));
      expect(repo.list(categoryId: 'unknown-cat'), invalid('category "unknown-cat" does not exist'));
      expect(repo.list(q: 'x' * 51), invalid('q must be at most 50 characters'));
      expect(repo.list(q: ' ${'x' * 50} '), completes, reason: 'length is checked after trimming');
    });

    test('errors arrive through the future, never thrown synchronously', () {
      late Future<DreamPage> f;
      expect(() => f = repo.list(limit: 0), returnsNormally);
      expect(f, throwsA(isA<DreamRepositoryException>()));
    });

    test('results complete synchronously (first-frame rendering)', () {
      expect(repo.list(), isA<SynchronousFuture<DreamPage>>());
      expect(repo.byId('snake'), isA<SynchronousFuture<Dream?>>());
      expect(repo.categories(), isA<SynchronousFuture<List<DreamCategory>>>());
    });

    test('page items cannot be modified', () async {
      final p = await repo.list();
      expect(() => p.items.clear(), throwsUnsupportedError);
    });
  });

  group('byId', () {
    test('returns the dream with leading zeros preserved', () async {
      final tooth = (await repo.byId('tooth-falling-out'))!;
      expect(tooth.numbers.twoDigit, ['08', '80']);
      expect(tooth.numbers.threeDigit, ['098', '809']);
      expect(tooth.digits, ['0', '8']);
      final dead = (await repo.byId('dead-person'))!;
      expect(dead.numbers.twoDigit, ['09', '90']);
      expect(dead.numbers.threeDigit, ['090', '900']);
    });

    test('returns the same object as dreamById for every dream', () async {
      for (final d in dreams) {
        expect(identical(await repo.byId(d.id), dreamById(d.id)), isTrue, reason: d.id);
      }
    });

    test('unknown id gives null; malformed id is invalid', () async {
      expect(await repo.byId('unicorn'), isNull);
      expect(repo.byId('BAD_ID'), invalid('id must be a lowercase slug (a-z, 0-9, -)'));
      expect(repo.byId(''), invalid('id must be a lowercase slug (a-z, 0-9, -)'));
    });

    test('custom source is respected', () async {
      final r = SampleDreamRepository(source: dreams.sublist(0, 2));
      expect(await r.byId('tooth-falling-out'), isNull);
      expect((await r.list()).total, 2);
    });
  });

  group('injection', () {
    test('defaults to the bundled sample data everywhere', () {
      expect(const MahaDreamApp().repository, isA<SampleDreamRepository>());
      expect(const AppShell().repository, isA<SampleDreamRepository>());
      expect(AppController().repository, isA<SampleDreamRepository>());
    });

    testWidgets('MahaDreamApp passes its repository to the controller', (tester) async {
      final custom = SampleDreamRepository(source: dreams.sublist(0, 1));
      await tester.pumpWidget(MahaDreamApp(repository: custom));
      // AppScope sits below AppShell, so look it up from a screen.
      final ctx = tester.element(find.byType(HomeScreen));
      final controller = ctx.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
      expect(identical(controller.repository, custom), isTrue);
    });
  });
}
