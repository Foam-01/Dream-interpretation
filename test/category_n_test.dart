// หมวด น: 27 predictions (import file), bundled in the app and listed on their own page (feature '28').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_n.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_n.dart';
import 'package:maha_dream/data/dreams_n.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-16-n';

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
  group('import file (27 predictions)', () {
    test('has exactly 27 DRAFT records of หมวด น with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), [
        'นกที่จับได้',
        'นกบิน',
        'น้ำนมไหล',
        'นมผู้ชายโต',
        'นมคนอื่น',
        'นมให้เด็กอื่น',
        'นมโต',
        'นอนในเรือ',
        'นอนกลางดิน',
        'นอนในน้ำ',
        'นอนไม่เป็นระเบียบ',
        'นอนในเรือล่ม',
        'นั่งบนภูเขา',
        'นั่งเรือ',
        'นาค',
        'นาง',
        'น้ำค้าง',
        'น้ำท่วม',
        'น้ำหวาน',
        'น้ำหอม',
        'นุ่งขาวห่มขาว',
        'นุ่งขาวมาหา',
        'นุ่งแดง',
        'นุ่งผ้า',
        'เน่า',
        'เนื้อถูกเชือด',
        'เนื้อบริโภค',
      ]);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(27));
      expect(dreams.every((d) => d['categoryId'] == letterNCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(16));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(27));
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
        // The source runs entries together on one line, so no line break is required after the numbers.
        final ok = d['noLuckyNumbers'] == true
            ? RegExp('เลขเสี่ยงโชค (ไม่ควรเสี่ยง|ยังไม่มีโชคในการเสี่ยง)').hasMatch(source)
            : source.contains('เลขเสี่ยงโชค ${all.join(', ')}');
        expect(ok, isTrue, reason: id);
      }
    });
  });

  group('bundled หมวด น', () {
    test('lib/data/dreams_n.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsN, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsN[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect(
          (d.id, d.name, d.meaning, d.short, d.cat),
          (j['id'], j['name'], j['meaning'], j['short'], 'หมวด น'),
          reason: id,
        );
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด ธ; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsN.first.id);
      expect(dreams.skip(start).take(dreamsN.length).map((d) => d.id), dreamsN.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด ธ');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-n', name: 'หมวด น', sortOrder: 21 }"));
      expect(letterNCategoryId, 'letter-n');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-n', 'หมวด น')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('27 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesN.keys, dreamsN.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('n-')).toSet(), {for (final id in dreamImagesN.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesN.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsN.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsN.where((d) => dreamImageFor(d.id) == null), isEmpty);
    });
  });

  group('หมวด น page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ธ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('28'), keys.indexOf('27') + 1);
      expect(tabOf('28'), 'book');
      expect(feats['28']!.title, 'ทำนายฝันหมวด น');
      expect(feats['28']!.type, FeatType.letter);
      expect(featureIcon('28'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 27', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('28');
      await tester.pump();
      expect(find.text('พบ 27 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(16));
      expect(find.text('เนื้อบริโภค'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('n-catching-bird');
      await tester.pump();
      expect(find.text('หมวด น'), findsOneWidget);
      expect(find.text('นกที่จับได้'), findsWidgets);
    });
  });
}
