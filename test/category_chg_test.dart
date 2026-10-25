// หมวด ฉ: 3 predictions (import file), bundled in the app and listed on their own page (feature '19').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_chg.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dreams_chg.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-07-chg';

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
  group('import file (3 predictions)', () {
    test('has exactly 3 DRAFT records of หมวด ฉ with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), ['ฉัตร', 'ฉาบ', 'ฉิ่ง']);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(3));
      expect(dreams.every((d) => d['categoryId'] == letterChgCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null && d['noLuckyNumbers'] != true), isTrue);
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(1));
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
        expect(source.contains('เลขเสี่ยงโชค ${all.join(', ')}\n'), isTrue, reason: id);
      }
    });
  });

  group('bundled หมวด ฉ', () {
    test('lib/data/dreams_chg.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsChg, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsChg[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ฉ'),
            reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, last; all bundled data validates', () {
      expect(dreams.skip(dreams.length - dreamsChg.length).map((d) => d.id), dreamsChg.map((d) => d.id));
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-chg', name: 'หมวด ฉ', sortOrder: 12 }"));
      expect(letterChgCategoryId, 'letter-chg');
      expect((sampleCategories.last.id, sampleCategories.last.name), ('letter-chg', 'หมวด ฉ'));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('หมวด ฉ page', () {
    test('is listed in the ตำราทำนาย menu after หมวด จ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('19'), keys.indexOf('18') + 1);
      expect(tabOf('19'), 'book');
      expect(feats['19']!.title, 'ทำนายฝันหมวด ฉ');
      expect(feats['19']!.type, FeatType.letter);
      expect(featureIcon('19'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 3', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('19');
      await tester.pump();
      expect(find.text('พบ 3 รายการ'), findsOneWidget);
      expect(find.text('ฉิ่ง'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail of ฉาบ keeps leading zeros', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('chg-cymbals');
      await tester.pump();
      expect(find.text('04 · 08'), findsOneWidget);
      expect(find.text('104 · 108'), findsOneWidget);
      expect(find.text('หมวด ฉ'), findsOneWidget);
    });
  });
}
