// หมวด ง: 12 predictions (import file), bundled in the app and listed on their own page (feature '17').
// "งู" has only the two-digit number 33 in the source.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_ng.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_ng.dart';
import 'package:maha_dream/data/dreams_ch.dart';
import 'package:maha_dream/data/dreams_ng.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-05-ng';

List<Map<String, Object?>> importDreams() =>
    ((jsonDecode(File('$incoming/dreams.json').readAsStringSync()) as Map)['dreams'] as List)
        .cast<Map<String, Object?>>();

AppController controllerOf(WidgetTester tester) =>
    tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;

Future<void> openApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MahaDreamApp());
}

void main() {
  group('import file (12 predictions)', () {
    test('has exactly 12 DRAFT records of หมวด ง with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams, hasLength(12));
      expect(dreams.map((d) => d['id']).toSet(), hasLength(12));
      expect(dreams.map((d) => d['name']).toSet(), hasLength(12));
      expect(dreams.every((d) => d['categoryId'] == letterNgCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.map((d) => d['name']), containsAll(['เงินทอง', 'เงินที่ได้รับ']));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(7));
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
        expect(source.contains('เลขเสี่ยงโชค $line\n'), isTrue, reason: id);
      }
    });

    test('5 "ไม่ควรเสี่ยง" items; งู keeps its single two-digit number and no three-digit numbers', () {
      final dreams = importDreams();
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(5));
      final snake = dreams.firstWhere((d) => d['id'] == 'ng-snake');
      expect(snake['noLuckyNumbers'], isNot(true));
      expect(snake['numbers'], {
        'twoDigit': ['33'],
        'threeDigit': <String>[],
      });
    });
  });

  group('bundled หมวด ง', () {
    test('lib/data/dreams_ng.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsNg, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsNg[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ง'),
            reason: id);
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, before หมวด จ; all bundled data validates', () {
      expect(dreams.skip(dreams.length - dreamsCh.length - dreamsNg.length).take(dreamsNg.length).map((d) => d.id),
          dreamsNg.map((d) => d.id));
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-ng', name: 'หมวด ง', sortOrder: 10 }"));
      expect(letterNgCategoryId, 'letter-ng');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-ng', 'หมวด ง')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });

    test('backend migration allows two-digit-only numbers', () {
      final sql = File('backend/prisma/migrations/0004_two_digit_only_numbers/migration.sql').readAsStringSync();
      expect(sql, contains('ELSE cardinality("two_digit") > 0 END'));
    });
  });

  group('dream pictures (per dream)', () {
    test('12 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesNg.keys, dreamsNg.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('ng-')).toSet(), {for (final id in dreamImagesNg.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesNg.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsNg.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsNg.where((d) => dreamImageFor(d.id) == null), isEmpty);
    });
  });

  group('หมวด ง page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ฆ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('17'), keys.indexOf('16') + 1);
      expect(tabOf('17'), 'book');
      expect(feats['17']!.title, 'ทำนายฝันหมวด ง');
      expect(feats['17']!.type, FeatType.letter);
      expect(featureIcon('17'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 12 and nothing from other categories', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('17');
      await tester.pump();
      expect(find.text('พบ 12 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(5));
      expect(find.text('งู'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail of งู shows only the two-digit tile with 33', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('ng-snake');
      await tester.pump();
      expect(find.text('สองตัว'), findsOneWidget);
      expect(find.text('33'), findsOneWidget);
      expect(find.text('สามตัว'), findsNothing);
      expect(find.text('ไม่ควรเสี่ยง'), findsNothing);
      expect(find.text('หมวด ง'), findsOneWidget);
    });

    testWidgets('detail of a dream with three-digit numbers still shows both tiles', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('ng-given-money');
      await tester.pump();
      expect(find.text('06 · 07'), findsOneWidget);
      expect(find.text('607 · 807'), findsOneWidget);
    });
  });
}
