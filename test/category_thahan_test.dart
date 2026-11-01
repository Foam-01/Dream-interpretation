// หมวด ท: 10 predictions (import file), bundled in the app and listed on their own page (feature '26').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_thahan.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_thahan.dart';
import 'package:maha_dream/data/dreams_thahan.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-14-thahan';

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
  group('import file (10 predictions)', () {
    test('has exactly 10 DRAFT records of หมวด ท with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), [
        'ท้อง',
        'ทอดแห',
        'ทะเล',
        'ทะเลาะ',
        'ทารก',
        'เทวดา',
        'เท้า',
        'ทำขวัญ',
        'เที่ยว',
        'แทง',
      ]);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(10));
      expect(dreams.every((d) => d['categoryId'] == letterThahanCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(5));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(2));
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

  group('bundled หมวด ท', () {
    test('lib/data/dreams_thahan.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsThahan, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsThahan[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect(
          (d.id, d.name, d.meaning, d.short, d.cat),
          (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ท'),
          reason: id,
        );
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด ถ; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsThahan.first.id);
      expect(dreams.skip(start).take(dreamsThahan.length).map((d) => d.id), dreamsThahan.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด ถ');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-thahan', name: 'หมวด ท', sortOrder: 19 }"));
      expect(letterThahanCategoryId, 'letter-thahan');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-thahan', 'หมวด ท')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('10 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesThahan.keys, dreamsThahan.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('thahan-')).toSet(), {for (final id in dreamImagesThahan.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesThahan.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsThahan.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsThahan.where((d) => dreamImageFor(d.id) == null).map((d) => d.id), isEmpty);
    });
  });

  group('หมวด ท page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ถ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('26'), keys.indexOf('25') + 1);
      expect(tabOf('26'), 'book');
      expect(feats['26']!.title, 'ทำนายฝันหมวด ท');
      expect(feats['26']!.type, FeatType.letter);
      expect(featureIcon('26'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 10', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('26');
      await tester.pump();
      expect(find.text('พบ 10 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(5));
      expect(find.text('แทง'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('thahan-belly');
      await tester.pump();
      expect(find.text('หมวด ท'), findsOneWidget);
      expect(find.text('ท้อง'), findsWidgets);
    });
  });
}
