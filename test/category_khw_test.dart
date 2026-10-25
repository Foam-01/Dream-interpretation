// หมวด ค: 24 predictions (import file), bundled in the app and listed on their own page (feature '15').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_khw.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_khw.dart';
import 'package:maha_dream/data/dreams_k.dart';
import 'package:maha_dream/data/dreams_kh.dart';
import 'package:maha_dream/data/dreams_khw.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-03-khw';

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
  controllerOf(tester).openFeat('15');
  await tester.pump();
}

void main() {
  group('import file (24 predictions)', () {
    test('has exactly 24 DRAFT records of หมวด ค with unique ids', () {
      final dreams = importDreams();
      expect(dreams, hasLength(24));
      expect(dreams.map((d) => d['id']).toSet(), hasLength(24));
      expect(dreams.every((d) => d['categoryId'] == letterKhwCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md')
          .readAsStringSync()
          .replaceAll('\r\n', '\n')
          // คู่รัก: the source breaks the word ความ|ซื่อสัตย์ across paragraphs; the import joins it.
          .replaceFirst('และความ\n\nซื่อสัตย์', 'และความซื่อสัตย์');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(16));
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

    test('14 "ไม่ควรเสี่ยง" items have no numbers; leading zeros kept; names are unique', () {
      final dreams = importDreams();
      final none = dreams.where((d) => d['noLuckyNumbers'] == true).toList();
      expect(none, hasLength(14));
      for (final d in none) {
        expect(d['numbers'], {'twoDigit': <String>[], 'threeDigit': <String>[]}, reason: d['id'] as String);
      }
      expect(dreams.firstWhere((d) => d['id'] == 'khw-giving-birth')['numbers'], {
        'twoDigit': ['01', '02'],
        'threeDigit': ['301', '402'],
      });
      final names = dreams.map((d) => d['name']).toList();
      expect(names.toSet(), hasLength(names.length));
      expect(names, containsAll(['คนตาย', 'คนชุดดำ', 'คอขาด', 'ผูกคอ', 'คดีความ']));
    });
  });

  group('bundled หมวด ค', () {
    test('lib/data/dreams_khw.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsKhw, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsKhw[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ค'),
            reason: id);
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, after หมวด ข', () {
      expect(dreams.skip(dreamsK.length + dreamsKh.length).take(dreamsKhw.length).map((d) => d.id),
          dreamsKhw.map((d) => d.id));
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-khw', name: 'หมวด ค', sortOrder: 8 }"));
      expect(letterKhwCategoryId, 'letter-khw');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-khw', 'หมวด ค')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('24 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesKhw.keys, dreamsKhw.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('khw-')).toSet(), {for (final id in dreamImagesKhw.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesKhw.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsKhw.firstWhere((d) => d.id == key).name}');
      }
    });

    test('dreamImageFor finds หมวด ค pictures', () {
      expect(dreamsKhw.where((d) => dreamImageFor(d.id) == null), isEmpty);
    });
  });

  group('หมวด ค page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ข and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('15'), keys.indexOf('14') + 1);
      expect(tabOf('15'), 'book');
      expect(feats['15']!.title, 'ทำนายฝันหมวด ค');
      expect(feats['15']!.type, FeatType.letter);
      expect(featureIcon('15'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 24 with ไม่ควรเสี่ยง and nothing from other categories', (tester) async {
      await openPage(tester);
      expect(find.text('พบ 24 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(14));
      expect(find.text('คอขาด'), findsOneWidget);
      expect(find.text('ผูกคอ'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
      expect(find.text('ขุด'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('tapping a row opens that prediction; its detail keeps leading zeros', (tester) async {
      await openPage(tester);
      await tester.tap(find.text('คลอดบุตร'));
      await tester.pump();
      expect(controllerOf(tester).page, isA<ResultPage>().having((p) => p.dreamId, 'dreamId', 'khw-giving-birth'));
      expect(find.text('หมวด ค'), findsOneWidget);
      expect(find.text('01 · 02'), findsOneWidget);
      expect(find.text('301 · 402'), findsOneWidget);
      expect(find.textContaining('ตำราโบราณ'), findsNothing);
    });
  });
}
