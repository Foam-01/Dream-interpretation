// หมวด ต: 29 predictions (import file), bundled in the app and listed on their own page (feature '24').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_t.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_t.dart';
import 'package:maha_dream/data/dreams_t.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-12-t';

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
  group('import file (29 predictions)', () {
    test('has exactly 29 DRAFT records of หมวด ต with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), [
        'ตกที่สูง',
        'ตกกองไฟ',
        'ตกข้าว',
        'ตกช้าง',
        'ตกทุกข์',
        'ตกเบ็ด',
        'ตกปลัก',
        'ตกเลือด',
        'ตกหลุม',
        'ปลูกต้นไม้',
        'ต้นไม้แห้ง',
        'ตะกวด',
        'ตะราง (ตาราง)',
        'ตักน้ำ',
        'ตัด',
        'ตัดผม',
        'ตัดศีรษะ',
        'ตับไต',
        'แว่นตาดำ',
        'ตาบอด',
        'ตาย',
        'ตุ้มหู',
        'เต้นรำ',
        'ไฟในเตา',
        'เตาไฟดับ',
        'เต่า',
        'แต่งตัว',
        'แตนต่อย',
        'ไต่',
      ]);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(29));
      expect(dreams.every((d) => d['categoryId'] == letterTCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(16));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(12));
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

  group('bundled หมวด ต', () {
    test('lib/data/dreams_t.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsT, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsT[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect(
          (d.id, d.name, d.meaning, d.short, d.cat),
          (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ต'),
          reason: id,
        );
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด ด; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsT.first.id);
      expect(dreams.skip(start).take(dreamsT.length).map((d) => d.id), dreamsT.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด ด');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-t', name: 'หมวด ต', sortOrder: 17 }"));
      expect(letterTCategoryId, 'letter-t');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-t', 'หมวด ต')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('28 checked pictures — every dream has one, bundled and registered', () {
      // ตะราง (t-jail) waits for a regenerated picture (the first one had English words on it).
      expect(dreamImagesT.keys, dreamsT.map((d) => d.id).where((id) => id != 't-jail'));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('t-')).toSet(), {for (final id in dreamImagesT.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesT.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsT.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsT.where((d) => dreamImageFor(d.id) == null).map((d) => d.id), ['t-jail']);
    });
  });

  group('หมวด ต page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ด and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('24'), keys.indexOf('23') + 1);
      expect(tabOf('24'), 'book');
      expect(feats['24']!.title, 'ทำนายฝันหมวด ต');
      expect(feats['24']!.type, FeatType.letter);
      expect(featureIcon('24'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 29', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('24');
      await tester.pump();
      expect(find.text('พบ 29 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(16));
      expect(find.text('ไต่'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('t-falling-high');
      await tester.pump();
      expect(find.text('หมวด ต'), findsOneWidget);
      expect(find.text('ตกที่สูง'), findsWidgets);
    });
  });
}
