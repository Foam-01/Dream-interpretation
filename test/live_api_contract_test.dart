// Optional contract check of ApiDreamRepository against a running backend.
// Skipped unless LIVE_API_BASE_URL is set, e.g.
//   LIVE_API_BASE_URL=http://localhost:3000/api/v1 flutter test test/live_api_contract_test.dart
// Read-only: GET requests only. Expects the seeded SAMPLE catalogue.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/api_dream_repository.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';

void main() {
  final base = Platform.environment['LIVE_API_BASE_URL'] ?? '';
  final skip = base.isEmpty ? 'LIVE_API_BASE_URL not set' : null;
  late ApiDreamRepository repo;

  setUpAll(() {
    if (skip == null) repo = ApiDreamRepository(Uri.parse(base));
  });
  tearDownAll(() {
    if (skip == null) repo.close();
  });

  test('categories match the app', () async {
    expect(await repo.categories(), sampleCategories);
  }, skip: skip);

  test('list, search, category filter and paging parse', () async {
    final all = await repo.list();
    expect(all.total, 10);
    expect(all.items.first.id, 'snake');
    expect((await repo.list(q: 'งู')).items.map((d) => d.id), ['snake']);
    expect((await repo.list(categoryId: 'animal')).total, 4);
    final p3 = await repo.list(page: 3, limit: 4);
    expect(p3.items.map((d) => d.id), ['gold', 'tiger']);
  }, skip: skip);

  test('every public dream parses (all pages, list and detail), whatever the catalogue holds', () async {
    var page = 1;
    var seen = 0;
    while (true) {
      final p = await repo.list(page: page, limit: 100, sort: DreamSort.name);
      for (final s in p.items) {
        final d = await repo.byId(s.id);
        expect(d, isNotNull, reason: s.id);
        expect(d!.numbers.twoDigit, s.numbers.twoDigit, reason: s.id);
      }
      seen += p.items.length;
      if (page >= p.totalPages) break;
      page++;
    }
    expect(seen, greaterThan(0));
  }, skip: skip);

  test('detail keeps leading zeros; unknown id is null; bad requests are typed', () async {
    final tooth = (await repo.byId('tooth-falling-out'))!;
    expect(tooth.numbers.twoDigit, ['08', '80']);
    expect(tooth.numbers.threeDigit, ['098', '809']);
    final dead = (await repo.byId('dead-person'))!;
    expect(dead.numbers.twoDigit, ['09', '90']);
    expect(dead.numbers.threeDigit, ['090', '900']);
    expect(await repo.byId('unicorn'), isNull);
    await expectLater(
      repo.list(limit: 101),
      throwsA(isA<DreamRepositoryException>().having((e) => e.code, 'code', 'VALIDATION_ERROR')),
    );
  }, skip: skip);
}
