// หมวด ก: 33 predictions (import file) and 10 decorative images that belong to the category page,
// never to individual predictions.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_k.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/dreams_k.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-01-k';

Map<String, Object?> importFile() =>
    jsonDecode(File('$incoming/dreams.json').readAsStringSync()) as Map<String, Object?>;
List<Map<String, Object?>> importDreams() => (importFile()['dreams'] as List).cast<Map<String, Object?>>();

DreamSummary summary(Map<String, Object?> d) {
  final n = d['numbers'] as Map<String, Object?>;
  return DreamSummary(
    id: d['id'] as String,
    name: d['name'] as String,
    category: const DreamCategory(letterKCategoryId, 'หมวด ก'),
    short: d['short'] as String,
    numbers: LuckyNumbers.copy(
      twoDigit: (n['twoDigit'] as List).cast<String>(),
      threeDigit: (n['threeDigit'] as List).cast<String>(),
    ),
    good: null,
    contentStatus: ContentStatus.verified,
  );
}

/// Remote repository that serves the 33 import records (only those with numbers can be represented).
class _Repo implements DreamRepository {
  final calls = <Map<String, Object?>>[];
  @override
  bool get isRemote => true;
  @override
  Future<List<DreamCategory>> categories() async => const [];
  @override
  Future<DreamPage> list({
    String? q,
    String? categoryId,
    int page = 1,
    int limit = DreamRepository.defaultPageSize,
    DreamSort sort = DreamSort.catalogue,
  }) async {
    calls.add({'category': categoryId, 'sort': sort, 'limit': limit});
    final items = [
      for (final d in importDreams())
        if (((d['numbers'] as Map)['twoDigit'] as List).isNotEmpty) summary(d),
    ];
    return DreamPage(items: items, page: 1, limit: limit, total: items.length);
  }

  @override
  Future<Dream?> byId(String id) async => null;
  @override
  void close() {}
}

Future<void> openLetterPage(WidgetTester tester, DreamRepository repo) async {
  tester.view.physicalSize = const Size(390, 6000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MahaDreamApp(repository: repo));
  await tester.pump();
  tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!.openFeat('13');
  await tester.pump();
  await tester.pump();
}

void main() {
  group('import file (33 predictions)', () {
    test('has exactly 33 DRAFT records of หมวด ก with unique ids', () {
      final dreams = importDreams();
      expect(dreams, hasLength(33));
      expect(dreams.map((d) => d['id']).toSet(), hasLength(33));
      expect(dreams.every((d) => d['categoryId'] == letterKCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
    });

    test('every prediction text is verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync();
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(12));
      for (final f in fixes) {
        final from = f['from'] as String;
        expect(from.allMatches(source), hasLength(1), reason: from);
        source = source.replaceFirst(from, f['to'] as String);
      }
      for (final d in importDreams()) {
        expect(source.contains(d['meaning'] as String), isTrue, reason: d['id'] as String);
        expect(source.contains(d['name'] as String), isTrue, reason: d['id'] as String);
      }
    });

    test('numbers are strings with leading zeros intact; "ไม่ควรเสี่ยง" items have none', () {
      final byId = {for (final d in importDreams()) d['id']: d['numbers'] as Map<String, Object?>};
      expect(byId['k-klot-parasol'], {
        'twoDigit': ['09', '00'],
        'threeDigit': ['109', '009'],
      });
      expect((byId['k-crystal-orb']!['threeDigit'] as List), contains('099'));
      for (final id in ['k-jaw', 'k-lost-key', 'k-cart-passing', 'k-growing-old']) {
        expect(byId[id], {'twoDigit': <String>[], 'threeDigit': <String>[]}, reason: id);
      }
      for (final n in byId.values) {
        for (final v in [...(n['twoDigit'] as List), ...(n['threeDigit'] as List)]) {
          expect(v, isA<String>());
        }
      }
    });

    test('same-name entries were renamed apart', () {
      final names = importDreams().map((d) => d['name']).toList();
      expect(names.toSet(), hasLength(names.length), reason: 'same-name entries were renamed apart');
      expect(names, containsAll(['กินอาหาร', 'กินอาหารกับญาติ', 'นั่งเกวียน', 'เกวียนผ่าน']));
    });

    test('no prediction carries an image or refers to an image file', () {
      final raw = File('$incoming/dreams.json').readAsStringSync();
      expect(importDreams().any((d) => d.containsKey('image')), isFalse);
      expect(raw.contains('.jpg'), isFalse);
      expect(importDreams().any((d) => RegExp(r'^k-\d+$').hasMatch(d['id'] as String)), isFalse);
    });
  });

  group('dream pictures (per dream)', () {
    test('33 pictures — every dream has one, bundled and registered', () {
      final ids = dreams.map((d) => d.id).toSet();
      expect(dreamImagesK, hasLength(33));
      expect(ids.containsAll(dreamImagesK.keys), isTrue);
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('k-')).toSet(), {for (final id in dreamImagesK.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesK.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
      }
      expect(File('pubspec.yaml').readAsStringSync(), contains('- assets/dreams/'));
    });

    test('every dream has a picture; กางร่ม and แก่ use the regenerated ones', () {
      expect(dreamsK.where((d) => dreamImageFor(d.id) == null), isEmpty);
      // Not k-06 (shows 157) / k-10 left (smoking): the regenerated pictures.
      expect(dreamImagesK['k-umbrella']!.url, 'assets/dreams/k-umbrella.jpg');
      expect(dreamImagesK['k-growing-old']!.url, 'assets/dreams/k-growing-old.jpg');
    });

    test('an API image wins over the bundled one', () {
      const remote = DreamImage(url: 'https://img.example.org/a.jpg', credit: 'c', license: 'l');
      expect(dreamImageFor('k-frog', remote), same(remote));
      expect(dreamImageFor('k-frog')!.url, 'assets/dreams/k-frog.jpg');
    });
  });

  group('หมวด ก page', () {
    testWidgets('is listed in the ตำราทำนาย menu and maps to the book tab', (tester) async {
      expect(menus['book']!.items.map((i) => i.key), contains('13'));
      expect(tabOf('13'), 'book');
      expect(feats['13']!.type, FeatType.letter);
    });

    testWidgets('API mode: list sorted by the API, each row with its own picture or the placeholder', (tester) async {
      final repo = _Repo();
      await openLetterPage(tester, repo);
      // Home asks for its own list first; exactly one request is for หมวด ก.
      expect(repo.calls.where((c) => c['category'] == letterKCategoryId).single, {
        'category': letterKCategoryId,
        'sort': DreamSort.name,
        'limit': 100,
      });
      expect(find.byKey(const ValueKey('decorative-strip')), findsNothing);
      expect(find.text('ภาพตกแต่งประจำหมวด ไม่ใช่เลขเสี่ยงโชค'), findsNothing);
      expect(find.text('พบ 29 รายการ'), findsOneWidget);
      expect(find.text('กินอาหาร'), findsOneWidget);
      expect(find.text('กินอาหารกับญาติ'), findsOneWidget);
      Finder rowOf(String name) => find.ancestor(of: find.text(name), matching: find.byType(InkWell)).first;
      expect(find.descendant(of: rowOf('กบ'), matching: find.byType(Image)), findsOneWidget);
      expect(find.descendant(of: rowOf('กอด'), matching: find.byType(Image)), findsOneWidget);
    });

    testWidgets('tapping a row opens that prediction', (tester) async {
      await openLetterPage(tester, _Repo());
      await tester.tap(find.text('กลอง'));
      await tester.pump();
      final ctl = tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;
      expect(ctl.page, isA<ResultPage>().having((p) => p.dreamId, 'dreamId', 'k-drum'));
    });

    testWidgets('a missing bundled picture shows the placeholder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DreamImageView(
              image: DreamImage.asset('assets/dreams/missing.jpg'),
              placeholderLabel: 'ภาพ',
              width: 60,
              height: 60,
            ),
          ),
        ),
      );
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await tester.pump();
      expect(find.text('ภาพ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('offline (bundled) mode: lists the real 33 with ไม่ควรเสี่ยง, no network', (tester) async {
      tester.view.physicalSize = const Size(390, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MahaDreamApp());
      tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!.openFeat('13');
      await tester.pump();
      expect(find.text('พบ 33 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(4));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('bundled real content (replaces the former sample data)', () {
    test('lib/data/dreams_k.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsK, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsK[i];
        final n = (j['numbers'] as Map?) ?? const {};
        expect(
          (d.id, d.name, d.meaning, d.short, d.cat),
          (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ก'),
          reason: j['id'] as String,
        );
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: j['id'] as String);
        expect(d.numbers.twoDigit, n['twoDigit'] ?? const [], reason: j['id'] as String);
        expect(d.numbers.threeDigit, n['threeDigit'] ?? const [], reason: j['id'] as String);
        expect(d.aliases, j['aliases'] ?? const [], reason: j['id'] as String);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('no sample data is left in the app', () {
      expect(dreams.map((d) => d.id).where((id) => !id.startsWith('k-') && !id.startsWith('kh-') && !id.startsWith('khw-') && !id.startsWith('khr-') && !id.startsWith('ng-') && !id.startsWith('ch-') && !id.startsWith('chg-')), isEmpty);
      expect(dreams.take(dreamsK.length).map((d) => d.id), dreamsK.map((d) => d.id), reason: 'หมวด ก comes first');
      expect(dreamCats, ['ทั้งหมด', 'หมวด ก', 'หมวด ข', 'หมวด ค', 'หมวด ฆ', 'หมวด ง', 'หมวด จ', 'หมวด ฉ']);
      expect(debugValidateDreams(), isTrue);
    });

    test('bundled categories match the backend content categories', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-k', name: 'หมวด ก', sortOrder: 6 }"));
      expect(letterKCategoryId, 'letter-k');
    });

    testWidgets('detail of a "ไม่ควรเสี่ยง" dream shows that, never numbers or a made-up source', (tester) async {
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MahaDreamApp());
      tester
          .element(find.byType(Scaffold).first)
          .getInheritedWidgetOfExactType<AppScope>()!
          .notifier!
          .openDream('k-jaw');
      await tester.pump();
      expect(find.text('เลขเสี่ยงโชค'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsOneWidget);
      expect(find.text('สองตัว'), findsNothing);
      expect(find.text('หมวด ก'), findsOneWidget);
      expect(find.textContaining('ตำราโบราณ'), findsNothing);
      expect(find.text('พยากรณ์โชคชะตา'), findsNothing);
    });

    testWidgets('detail of a dream with numbers keeps leading zeros', (tester) async {
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MahaDreamApp());
      tester
          .element(find.byType(Scaffold).first)
          .getInheritedWidgetOfExactType<AppScope>()!
          .notifier!
          .openDream('k-klot-parasol');
      await tester.pump();
      expect(find.text('09 · 00'), findsOneWidget);
      expect(find.text('109 · 009'), findsOneWidget);
    });
  });
}
