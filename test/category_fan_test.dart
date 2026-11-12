// หมวด ฟ: 9 predictions (import file), bundled in the app and listed on their own page (feature '34').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_fan.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_fan.dart';
import 'package:maha_dream/data/dreams_fan.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-22-fan';

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
  group('import file (9 predictions)', () {
    test('has exactly 9 DRAFT records of หมวด ฟ with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), [
        'ฟันคลอน',
        'ฟันหัก',
        'ฟ้าผ่าตัว',
        'ฟ้าผ่าต้นไม้',
        'ไฟบนภูเขา',
        'ไฟในเตา',
        'ไฟไหม้บ้าน',
        'ไฟโคมและเทียน',
        'ไฟไหม้ป่า',
      ]);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(9));
      expect(dreams.every((d) => d['categoryId'] == letterFanCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(5));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(9));
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

  group('bundled หมวด ฟ', () {
    test('lib/data/dreams_fan.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsFan, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsFan[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect(
          (d.id, d.name, d.meaning, d.short, d.cat),
          (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ฟ'),
          reason: id,
        );
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด พ; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsFan.first.id);
      expect(dreams.skip(start).take(dreamsFan.length).map((d) => d.id), dreamsFan.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด พ');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-fan', name: 'หมวด ฟ', sortOrder: 27 }"));
      expect(letterFanCategoryId, 'letter-fan');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-fan', 'หมวด ฟ')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('9 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesFan.keys, dreamsFan.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('fan-')).toSet(), {for (final id in dreamImagesFan.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesFan.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsFan.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsFan.where((d) => dreamImageFor(d.id) == null), isEmpty);
    });
  });

  group('หมวด ฟ page', () {
    test('is listed in the ตำราทำนาย menu after หมวด พ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('34'), keys.indexOf('33') + 1);
      expect(tabOf('34'), 'book');
      expect(feats['34']!.title, 'ทำนายฝันหมวด ฟ');
      expect(feats['34']!.type, FeatType.letter);
      expect(featureIcon('34'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 9', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('34');
      await tester.pump();
      expect(find.text('พบ 9 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(5));
      expect(find.text('ไฟไหม้ป่า'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('fan-loose-tooth');
      await tester.pump();
      expect(find.text('หมวด ฟ'), findsOneWidget);
      expect(find.text('ฟันคลอน'), findsWidgets);
    });
  });
}
