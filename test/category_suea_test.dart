// หมวด ส: 19 predictions (import file), bundled in the app and listed on their own page (feature '42').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_suea.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dreams_suea.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-30-suea';

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
  group('import file (19 predictions)', () {
    test('has exactly 19 DRAFT records of หมวด ส with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), ['สนาม', 'สมอเรือ', 'สระน้ำ', 'สัปทน', 'สัปเหร่อ', 'สามเณร', 'สามง่าม', 'สายสะพาย', 'สาว', 'สิงโต', 'สุนัข', 'เสากระโดง', 'เสาเรือน', 'เสือ', 'เสือกัด', 'เสื้อผ้า', 'แส้', 'แสง', 'ไส้พุง']);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(19));
      expect(dreams.every((d) => d['categoryId'] == letterSueaCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(10));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(0));
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

  group('bundled หมวด ส', () {
    test('lib/data/dreams_suea.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsSuea, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsSuea[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect((d.id, d.name, d.meaning, d.short, d.cat), (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ส'),
            reason: id);
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด ศ; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsSuea.first.id);
      expect(dreams.skip(start).take(dreamsSuea.length).map((d) => d.id), dreamsSuea.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด ศ');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-suea', name: 'หมวด ส', sortOrder: 35 }"));
      expect(letterSueaCategoryId, 'letter-suea');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-suea', 'หมวด ส')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('หมวด ส page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ศ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('42'), keys.indexOf('41') + 1);
      expect(tabOf('42'), 'book');
      expect(feats['42']!.title, 'ทำนายฝันหมวด ส');
      expect(feats['42']!.type, FeatType.letter);
      expect(featureIcon('42'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 19', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('42');
      await tester.pump();
      expect(find.text('พบ 19 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(10));
      expect(find.text('ไส้พุง'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('suea-field');
      await tester.pump();
      expect(find.text('หมวด ส'), findsOneWidget);
      expect(find.text('สนาม'), findsWidgets);
    });
  });
}
