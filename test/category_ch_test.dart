// หมวด จ: 13 predictions (import file), bundled in the app and listed on their own page (feature '18').
// "จันทรคราส" says "ยังไม่มีโชคในการเสี่ยง" in the source, stored like "ไม่ควรเสี่ยง" (no numbers).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_ch.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_ch.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dreams_ch.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-06-ch';

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
  group('import file (13 predictions)', () {
    test('has exactly 13 DRAFT records of หมวด จ with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams, hasLength(13));
      expect(dreams.map((d) => d['id']).toSet(), hasLength(13));
      expect(dreams.map((d) => d['name']).toSet(), hasLength(13));
      expect(dreams.every((d) => d['categoryId'] == letterChCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(10));
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
        final none = id == 'ch-lunar-eclipse' ? 'ยังไม่มีโชคในการเสี่ยง' : 'ไม่ควรเสี่ยง';
        final line = d['noLuckyNumbers'] == true ? none : all.join(', ');
        expect(source.contains('เลขเสี่ยงโชค $line\n'), isTrue, reason: id);
      }
    });

    test('5 no-number items incl. จันทรคราส; leading zeros kept', () {
      final dreams = importDreams();
      final none = dreams.where((d) => d['noLuckyNumbers'] == true).map((d) => d['id']).toList();
      expect(none, hasLength(5));
      expect(none, contains('ch-lunar-eclipse'));
      expect(dreams.firstWhere((d) => d['id'] == 'ch-holding-moon')['numbers'], {
        'twoDigit': ['01', '02'],
        'threeDigit': ['071', '072'],
      });
    });
  });

  group('bundled หมวด จ', () {
    test('lib/data/dreams_ch.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsCh, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsCh[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด จ'),
            reason: id);
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, last; all bundled data validates', () {
      expect(dreams.skip(dreams.length - dreamsCh.length).map((d) => d.id), dreamsCh.map((d) => d.id));
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-ch', name: 'หมวด จ', sortOrder: 11 }"));
      expect(letterChCategoryId, 'letter-ch');
      expect(sampleCategories.map((c) => (c.id, c.name)), [
        ('letter-k', 'หมวด ก'),
        ('letter-kh', 'หมวด ข'),
        ('letter-khw', 'หมวด ค'),
        ('letter-khr', 'หมวด ฆ'),
        ('letter-ng', 'หมวด ง'),
        ('letter-ch', 'หมวด จ'),
      ]);
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('13 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesCh.keys, dreamsCh.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('ch-')).toSet(), {for (final id in dreamImagesCh.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesCh.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsCh.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsCh.where((d) => dreamImageFor(d.id) == null), isEmpty);
    });
  });

  group('หมวด จ page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ง and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('18'), keys.indexOf('17') + 1);
      expect(tabOf('18'), 'book');
      expect(feats['18']!.title, 'ทำนายฝันหมวด จ');
      expect(feats['18']!.type, FeatType.letter);
      expect(featureIcon('18'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 13 and nothing from other categories', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('18');
      await tester.pump();
      expect(find.text('พบ 13 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(5));
      expect(find.text('จันทรคราส'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail of จับดวงจันทร์ keeps leading zeros', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('ch-holding-moon');
      await tester.pump();
      expect(find.text('01 · 02'), findsOneWidget);
      expect(find.text('071 · 072'), findsOneWidget);
      expect(find.text('หมวด จ'), findsOneWidget);
    });
  });
}
