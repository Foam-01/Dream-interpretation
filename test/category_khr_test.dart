// หมวด ฆ: 4 predictions (import file), bundled in the app and listed on their own page (feature '16').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_khr.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_khr.dart';
import 'package:maha_dream/data/dreams_khr.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-04-khr';

List<Map<String, Object?>> importDreams() =>
    ((jsonDecode(File('$incoming/dreams.json').readAsStringSync()) as Map)['dreams'] as List)
        .cast<Map<String, Object?>>();

AppController controllerOf(WidgetTester tester) =>
    tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;

Future<void> openPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MahaDreamApp());
  controllerOf(tester).openFeat('16');
  await tester.pump();
}

void main() {
  group('import file (4 predictions)', () {
    test('has exactly 4 DRAFT records of หมวด ฆ with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams, hasLength(4));
      expect(dreams.map((d) => d['id']).toSet(), hasLength(4));
      expect(dreams.every((d) => d['categoryId'] == letterKhrCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.map((d) => d['name']), ['ฆ้อง', 'ถูกฆ่า', 'ฆ่าตัวเอง', 'เฆี่ยน']);
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(4));
      for (final f in fixes) {
        final from = f['from'] as String;
        expect(from.allMatches(source), hasLength(1), reason: from);
        source = source.replaceFirst(from, f['to'] as String);
      }
      for (final d in importDreams()) {
        final id = d['id'] as String;
        expect(source.contains('${d['name']} '), isTrue, reason: id);
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

    test('2 "ไม่ควรเสี่ยง" items have no numbers; leading zeros kept', () {
      final dreams = importDreams();
      final none = dreams.where((d) => d['noLuckyNumbers'] == true).toList();
      expect(none.map((d) => d['id']), ['khr-killing-oneself', 'khr-whipping']);
      for (final d in none) {
        expect(d['numbers'], {'twoDigit': <String>[], 'threeDigit': <String>[]}, reason: d['id'] as String);
      }
      expect(dreams.first['numbers'], {
        'twoDigit': ['08', '09'],
        'threeDigit': ['708', '709'],
      });
    });
  });

  group('bundled หมวด ฆ', () {
    test('lib/data/dreams_khr.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsKhr, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsKhr[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ฆ'),
            reason: id);
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, last', () {
      expect(dreams.skip(dreams.length - dreamsKhr.length).map((d) => d.id), dreamsKhr.map((d) => d.id));
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-khr', name: 'หมวด ฆ', sortOrder: 9 }"));
      expect(letterKhrCategoryId, 'letter-khr');
      expect(sampleCategories.map((c) => (c.id, c.name)),
          [('letter-k', 'หมวด ก'), ('letter-kh', 'หมวด ข'), ('letter-khw', 'หมวด ค'), ('letter-khr', 'หมวด ฆ')]);
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('4 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesKhr.keys, dreamsKhr.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('khr-')).toSet(), {for (final id in dreamImagesKhr.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesKhr.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsKhr.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsKhr.where((d) => dreamImageFor(d.id) == null), isEmpty);
    });
  });

  group('หมวด ฆ page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ค and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('16'), keys.indexOf('15') + 1);
      expect(tabOf('16'), 'book');
      expect(feats['16']!.title, 'ทำนายฝันหมวด ฆ');
      expect(feats['16']!.type, FeatType.letter);
      expect(featureIcon('16'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 4 and nothing from other categories', (tester) async {
      await openPage(tester);
      expect(find.text('พบ 4 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(2));
      expect(find.text('ถูกฆ่า'), findsOneWidget);
      expect(find.text('ฆ่าตัวเอง'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('search: the 5th category chip is reachable by scrolling the chip row and filters to ฆ', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MahaDreamApp());
      controllerOf(tester).goSearch(resetCat: true);
      await tester.pumpAndSettle();
      // The horizontal Scrollable that holds the "ทั้งหมด" chip.
      final chipRow = find
          .ancestor(of: find.text('ทั้งหมด').first, matching: find.byType(Scrollable))
          .first;
      // Not built until scrolled into view (the row is a lazy ListView).
      await tester.scrollUntilVisible(find.text('หมวด ฆ'), 80, scrollable: chipRow);
      await tester.pumpAndSettle();
      await tester.tap(find.text('หมวด ฆ').first);
      await tester.pump();
      expect(controllerOf(tester).cat, 'หมวด ฆ');
      expect(find.text('พบ 4 รายการ'), findsOneWidget);
    });

    testWidgets('tapping a row opens that prediction; its detail keeps leading zeros', (tester) async {
      await openPage(tester);
      await tester.tap(find.text('ฆ้อง'));
      await tester.pump();
      expect(controllerOf(tester).page, isA<ResultPage>().having((p) => p.dreamId, 'dreamId', 'khr-gong'));
      expect(find.text('หมวด ฆ'), findsOneWidget);
      expect(find.text('08 · 09'), findsOneWidget);
      expect(find.text('708 · 709'), findsOneWidget);
    });
  });
}
