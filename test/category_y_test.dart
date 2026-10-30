// หมวด ญ: 8 predictions (import file), bundled in the app and listed on their own page (feature '22').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_y.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_y.dart';
import 'package:maha_dream/data/dreams_y.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-10-y';

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
  group('import file (8 predictions)', () {
    test('has exactly 8 DRAFT records of หมวด ญ with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), [
        'ญาติมิตร',
        'หญิงชุดดำ',
        'หญิงแปลกหน้า',
        'หญิงแก้ผ้า',
        'หญิงแก่',
        'หญิงนุ่งขาว',
        'หญิงนุ่งแดง',
        'หญิงสาว',
      ]);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(8));
      expect(dreams.every((d) => d['categoryId'] == letterYCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(6));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(4));
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

  group('bundled หมวด ญ', () {
    test('lib/data/dreams_y.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsY, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsY[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect(
          (d.id, d.name, d.meaning, d.short, d.cat),
          (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ญ'),
          reason: id,
        );
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด ซ; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsY.first.id);
      expect(dreams.skip(start).take(dreamsY.length).map((d) => d.id), dreamsY.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด ซ');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-y', name: 'หมวด ญ', sortOrder: 15 }"));
      expect(letterYCategoryId, 'letter-y');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-y', 'หมวด ญ')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('8 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesY.keys, dreamsY.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('y-')).toSet(), {for (final id in dreamImagesY.keys) '$id.jpg'});
      for (final MapEntry(:key, :value) in dreamImagesY.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsY.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsY.where((d) => dreamImageFor(d.id) == null), isEmpty);
    });
  });

  group('หมวด ญ page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ซ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('22'), keys.indexOf('21') + 1);
      expect(tabOf('22'), 'book');
      expect(feats['22']!.title, 'ทำนายฝันหมวด ญ');
      expect(feats['22']!.type, FeatType.letter);
      expect(featureIcon('22'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 8', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('22');
      await tester.pump();
      expect(find.text('พบ 8 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(6));
      expect(find.text('หญิงสาว'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('y-relatives');
      await tester.pump();
      expect(find.text('หมวด ญ'), findsOneWidget);
      expect(find.text('ญาติมิตร'), findsWidgets);
    });
  });
}
