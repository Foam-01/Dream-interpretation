// หมวด ข: 25 predictions (import file), bundled in the app and listed on their own page (feature '14').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_kh.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_kh.dart';
import 'package:maha_dream/data/dreams_kh.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-02-kh';

List<Map<String, Object?>> importDreams() =>
    ((jsonDecode(File('$incoming/dreams.json').readAsStringSync()) as Map)['dreams'] as List)
        .cast<Map<String, Object?>>();

AppController controllerOf(WidgetTester tester) =>
    tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;

Future<void> openPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 6000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MahaDreamApp());
  controllerOf(tester).openFeat('14');
  await tester.pump();
}

void main() {
  group('import file (25 predictions)', () {
    test('has exactly 25 DRAFT records of หมวด ข with unique ids', () {
      final dreams = importDreams();
      expect(dreams, hasLength(25));
      expect(dreams.map((d) => d['id']).toSet(), hasLength(25));
      expect(dreams.every((d) => d['categoryId'] == letterKhCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(20));
      for (final f in fixes) {
        final from = f['from'] as String;
        expect(from.allMatches(source), hasLength(1), reason: from);
        source = source.replaceFirst(from, f['to'] as String);
      }
      for (final d in importDreams()) {
        final id = d['id'] as String;
        expect(source.contains('${d['name']} '), isTrue, reason: id);
        // Meanings split over two paragraphs are joined with one space: every word still appears in order.
        var from = 0;
        for (final w in (d['meaning'] as String).split(' ')) {
          from = source.indexOf(w, from);
          expect(from, isNonNegative, reason: '$id: "$w"');
        }
        final n = d['numbers'] as Map<String, Object?>;
        final all = [...(n['twoDigit'] as List), ...(n['threeDigit'] as List)];
        final line = d['noLuckyNumbers'] == true ? 'ไม่ควรเสี่ยง' : all.join(', ');
        expect(source.contains('เลขเสี่ยงโชค $line'), isTrue, reason: id);
      }
    });

    test('11 "ไม่ควรเสี่ยง" items have no numbers; same-name entries stay separate', () {
      final dreams = importDreams();
      final none = dreams.where((d) => d['noLuckyNumbers'] == true).toList();
      expect(none, hasLength(11));
      for (final d in none) {
        expect(d['numbers'], {'twoDigit': <String>[], 'threeDigit': <String>[]}, reason: d['id'] as String);
      }
      final names = dreams.map((d) => d['name']).toList();
      expect(names.where((n) => n == 'ขา'), hasLength(2));
      expect(names.where((n) => n == 'เขา'), hasLength(2));
    });
  });

  group('bundled หมวด ข', () {
    test('lib/data/dreams_kh.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsKh, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsKh[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ข'),
            reason: id);
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, after หมวด ก', () {
      expect(dreams.skip(dreams.length - dreamsKh.length).map((d) => d.id), dreamsKh.map((d) => d.id));
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-kh', name: 'หมวด ข', sortOrder: 7 }"));
      expect(letterKhCategoryId, 'letter-kh');
      expect(sampleCategories.map((c) => (c.id, c.name)), [('letter-k', 'หมวด ก'), ('letter-kh', 'หมวด ข')]);
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('25 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesKh, hasLength(25));
      expect(dreamImagesKh.keys, dreamsKh.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('kh-')).toSet(), {for (final id in dreamImagesKh.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesKh.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
      }
    });

    test('dreamImageFor finds หมวด ข pictures', () {
      expect(dreamsKh.where((d) => dreamImageFor(d.id) == null), isEmpty);
      expect(dreamImageFor('kh-dessert')!.url, 'assets/dreams/kh-dessert.jpg');
    });
  });

  group('หมวด ข page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ก and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('14'), keys.indexOf('13') + 1);
      expect(tabOf('14'), 'book');
      expect(feats['14']!.title, 'ทำนายฝันหมวด ข');
      expect(feats['14']!.type, FeatType.letter);
      expect(featureIcon('14'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 25 with ไม่ควรเสี่ยง and no หมวด ก entry', (tester) async {
      await openPage(tester);
      expect(find.text('พบ 25 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(11));
      expect(find.text('เขา'), findsNWidgets(2));
      expect(find.text('กบ'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('tapping a row opens that prediction; its detail shows หมวด ข and its numbers', (tester) async {
      await openPage(tester);
      await tester.tap(find.text('ขุด'));
      await tester.pump();
      expect(controllerOf(tester).page, isA<ResultPage>().having((p) => p.dreamId, 'dreamId', 'kh-digging'));
      expect(find.text('หมวด ข'), findsOneWidget);
      expect(find.text('10 · 12'), findsOneWidget);
      expect(find.text('101 · 121'), findsOneWidget);
      expect(find.textContaining('ตำราโบราณ'), findsNothing);
    });
  });
}
