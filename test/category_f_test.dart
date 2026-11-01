// หมวด ฝ: 4 predictions (import file), bundled in the app and listed on their own page (feature '32').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_f.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dreams_f.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-20-f';

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
  group('import file (4 predictions)', () {
    test('has exactly 4 DRAFT records of หมวด ฝ with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), ['ฝน', 'ฝัง', 'ฝังศพ', 'ฝี']);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(4));
      expect(dreams.every((d) => d['categoryId'] == letterFCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(1));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(3));
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
        final ok = d['noLuckyNumbers'] == true
            ? RegExp('เลขเสี่ยงโชค (ไม่ควรเสี่ยง|ยังไม่มีโชคในการเสี่ยง)\n').hasMatch(source)
            : source.contains('เลขเสี่ยงโชค ${all.join(', ')}\n');
        expect(ok, isTrue, reason: id);
      }
    });
  });

  group('bundled หมวด ฝ', () {
    test('lib/data/dreams_f.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsF, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsF[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ฝ'),
            reason: id);
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด ผ; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsF.first.id);
      expect(dreams.skip(start).take(dreamsF.length).map((d) => d.id), dreamsF.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด ผ');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-f', name: 'หมวด ฝ', sortOrder: 25 }"));
      expect(letterFCategoryId, 'letter-f');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-f', 'หมวด ฝ')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('หมวด ฝ page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ผ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('32'), keys.indexOf('31') + 1);
      expect(tabOf('32'), 'book');
      expect(feats['32']!.title, 'ทำนายฝันหมวด ฝ');
      expect(feats['32']!.type, FeatType.letter);
      expect(featureIcon('32'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 4', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('32');
      await tester.pump();
      expect(find.text('พบ 4 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(1));
      expect(find.text('ฝี'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('f-rain');
      await tester.pump();
      expect(find.text('หมวด ฝ'), findsOneWidget);
      expect(find.text('ฝน'), findsWidgets);
    });
  });
}
